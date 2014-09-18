Class HL7Demo.PeopleDataLoader Extends CSV.Loader
{

ClassMethod UnitTest() As %Status
{
	Set dataFolder = $System.Util.InstallDirectory()_"/Data/HL7Demo.People"
	Set packageName = "HL7Demo.Data"
	Set loader=##class(HL7Demo.PeopleDataLoader).%New(dataFolder,packageName)
	Set sc=loader.Load()
	Do $system.OBJ.DisplayError(sc)
	Quit sc
}

ClassMethod LoadRawData() As %Status
{
	Set dataFolder = $System.Util.InstallDirectory()_"/Data/HL7Demo.Data"
	Set packageName = "HL7Demo.Data"
	Set loader=##class(HL7Demo.PeopleDataLoader).%New(dataFolder,packageName)
	Set sc=loader.Load()
	Do $system.OBJ.DisplayError(sc)
	Quit sc
}

ClassMethod t(num = 0)
{
	if ( num > 0 ) {
		Set ^hl7demo.MessageCount = num
	} else {
		Kill ^hl7demo.MessageCount
	}
	Do ##class(HL7Demo.PeopleDataLoader).GenerateA01s(1)
}

Parameter NumberDebugMessages = 5; //100;

Parameter MaxNumberMedMessages = 10;

Parameter MaxNumberLabMessages = 5;

Parameter MaxNumberNotesMessages = 4;

ClassMethod post(hl7Sender as EnsLib.HTTP.GenericOperation,
				 HL7Message as EnsLib.HL7.Message) [ Internal ]
{
	set stream = ##class(%GlobalCharacterStream).%New()
	set sc=HL7Message.OutputToLibraryStream(stream)
	do stream.Rewind()
	set http= ##class(EnsLib.HTTP.GenericMessage).%New(stream,,stream)
	do http.HTTPHeaders.SetAt(stream.Size,"content-length")
	do http.HTTPHeaders.SetAt("application/hl7","content-type")
	do http.HTTPHeaders.SetAt("POST","httprequest")
	//write "stream.Size=",stream.Size,!
	write stream.ReadLine()
	do stream.Rewind()

	set sc=hl7Sender.OnMessage(http,.response)
}

ClassMethod GenerateDrugAlertMessage(numberOfPatients = 10,maxResultsPerPatient = 10)
{
	set hl7Sender = ##class(EnsLib.HTTP.GenericOperation).%New("DemoDataSender")
	Set sc=hl7Sender.OnInit()
	// http://requestb.in/pcf9cepc
	set target = $listbuild("localhost",9980,"/drug-alert-data-feed")
	//set target = $listbuild("requestb.in",80,"/1784prb1")
	set hl7Sender.Adapter.HTTPServer = $list(target,1)
	set hl7Sender.Adapter.HTTPPort = $list(target,2)
	set hl7Sender.Adapter.URL = $list(target,3)
	//set hl7Sender.Adapter.HTTPServer = "requestb.in"
	//set hl7Sender.Adapter.HTTPPort = 80
	//set hl7Sender.Adapter.URL = "/pcf9cepc"
	Do ##class(HL7Demo.Util).LoadVitalSignConceptCache()
	Set rs=##class(%ResultSet).%New("HL7Demo.Data.People:Extent")
	Set sc=rs.Execute()
	While ( rs.Next() ) {
		quit:($increment(msgCount)>numberOfPatients)
		Set id=rs.Get("ID")
		do ..SendOneDrugAlertMessage(id,hl7Sender,maxResultsPerPatient)
	}
}
ClassMethod SendOneDrugAlertMessage(id,hl7Sender,maxResultsPerPatient) 
{
	//set ^||hl7demo.DocType="2.5Meds:OMP_O09Meds"
	//set ^||hl7demo.versionOverride="2.5"
	set ^||hl7demo.segment.path("DG1")="PIDgrp.DG1(1)"
	set ^||hl7demo.segment.path("PID")="PIDgrp.PID"
	set ^||hl7demo.segment.path("PV1")="PIDgrp.PV1grp.PV1"
	set ^||hl7demo.segment.path("FT1")="ORCgrp(1).FT1(1)"
	set ^||hl7demo.segment.path("RXO")="ORCgrp(1).RXO"
	set ^||hl7demo.segment.path("RXR")="ORCgrp(1).RXR(1)"
	set ^||hl7demo.segment.path("ORC")="ORCgrp(1).ORC"
	set ^||hl7demo.segment.path("TQ1")="ORCgrp(1).TQ1grp(1).TQ1"
	set ^||hl7demo.diagnosis = $listbuild(4780,4781,4782,9203,9308)	
	Kill Map,Message
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","ADT_A01",1,.Segments)
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","OMP_O09",1,.MedsSegments)
  	//Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5Meds","OMP_O09Meds",1,.MedsSegments)
	//Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","ORU_R01",1,.LabsSegments)
	Do ##class(HL7Demo.Test1).GetADTLogicalMap("ADT^A08",.Map)
	Set sc=##class(HL7Demo.PeopleDataLoader).LoadMap(id,.Map,.Segments)
	// build med message with Amitriptyline
	Do ##class(HL7Demo.Test1).GetADTLogicalMap("OMP^O09",.MedsMap)
	Merge MedsMap("PID")=Map("PID")
	Merge MedsMap("PV1")=Map("PV1")
	Merge MedsMap("DG1")=Map("DG1")
	zw MedsMap
	Set sc=##class(HL7Demo.PeopleDataLoader).LoadMedsMapForTachycard(id,.MedsMap,.MedsSegments)
	if $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
	Do ##class(HL7Demo.Test1).CreateMessage(.MedsSegments,.MedsMap,.MedsMessage,.HL7Message)
	w HL7Message.RawContent
	do ..post(hl7Sender,HL7Message)

}
ClassMethod GenerateDiabetesAlertMessage(numberOfPatients = 10,maxResultsPerPatient = 10)
{
	set hl7Sender = ##class(EnsLib.HTTP.GenericOperation).%New("DemoDataSender")
	Set sc=hl7Sender.OnInit()
	// http://requestb.in/pcf9cepc
	set hl7Sender.Adapter.HTTPServer = "localhost"
	set hl7Sender.Adapter.HTTPPort = 9980
	set hl7Sender.Adapter.URL = "/diabetes-alert-data-feed"
	//set hl7Sender.Adapter.HTTPServer = "requestb.in"
	//set hl7Sender.Adapter.HTTPPort = 80
	//set hl7Sender.Adapter.URL = "/pcf9cepc"
	Do ##class(HL7Demo.Util).LoadVitalSignConceptCache()
	Set rs=##class(%ResultSet).%New("HL7Demo.Data.People:Extent")
	Set sc=rs.Execute()
	While ( rs.Next() ) {
		quit:($increment(msgCount)>numberOfPatients)
		Set id=rs.Get("ID")
		do ..SendOneDiabetesAlertMessage(id,hl7Sender,maxResultsPerPatient)
	}
}
ClassMethod SendOneDiabetesAlertMessage(id,hl7Sender,maxResultsPerPatient) 
{
	set ^||hl7demo.DocType="2.5:ORU_R01"
	set ^||hl7demo.segment.path("PID")="PIDgrpgrp(1).PIDgrp.PID"
	set ^||hl7demo.segment.path("ORC")="PIDgrpgrp(1).ORCgrp(1).ORC"
	set ^||hl7demo.segment.path("OBR")="PIDgrpgrp(1).ORCgrp(1).OBR"
	set ^||hl7demo.segment.path("OBX")="PIDgrpgrp(1).ORCgrp(1).OBXgrp(1).OBX"
	
	Kill Map,Message
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","ADT_A01",1,.Segments)
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","ORU_R01",1,.LabsSegments)
	Do ##class(HL7Demo.Test1).GetADTLogicalMap("ADT^A08",.Map)
	Set sc=##class(HL7Demo.PeopleDataLoader).LoadMap(id,.Map,.Segments)
	//Do ##class(HL7Demo.Test1).CreateMessage(.Segments,.Map,.Message,.HL7Message)
	//do ..post(hl7Sender,HL7Message)
	Do ##class(HL7Demo.Test1).GetADTLogicalMap("ORU^R01",.LabsMap)
	Merge LabsMap("PID")=Map("PID")
	Merge LabsMap("PV1")=Map("PV1")
	Set sc=##class(HL7Demo.PeopleDataLoader).LoadLabsMapForLDL(id,.LabsMap,.LabsSegments)
	//Set sc=##class(HL7Demo.PeopleDataLoader).LoadLabsMap(id,.LabsMap,.LabsSegments)
	if $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
	Do ##class(HL7Demo.Test1).CreateMessage(.LabsSegments,.LabsMap,.LabsMessage,.HL7Message)
	do ..post(hl7Sender,HL7Message)

}
ClassMethod GenerateA01s(Test As %Boolean = 0, DumpFiles As %Boolean = 0)
{
	//Do ##class(HL7Demo.Util).LoadDocs()
	//Break
	Set hl7Sender = ##class(HL7Demo.MsgSender).%New("HL7Demo.TCPMessageSender")
	set hl7Sender = ##class(EnsLib.HTTP.GenericOperation).%New("DemoDataSender")
	Set sc=hl7Sender.OnInit()
	set hl7Sender.Adapter.HTTPServer = "localhost"
	set hl7Sender.Adapter.HTTPPort = 9980
	set hl7Sender.Adapter.URL = "/sample-data-feed"
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","ADT_A01",1,.Segments)
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","OMP_O09",1,.MedsSegments)
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","ORU_R01",1,.LabsSegments)
	Do ##class(HL7Demo.Test1).SegmentsForMessageType("2.5","MDM_T02",1,.NotesSegments)
	
	Do ##class(HL7Demo.Util).LoadVitalSignConceptCache()
	Set rs=##class(%ResultSet).%New("HL7Demo.Data.People:Extent")
	Set sc=rs.Execute()
	While ( rs.Next() ) {
		Set id=rs.Get("ID")
		Quit:((Test)&(id>##class(HL7Demo.PeopleDataLoader).%GetParameter("NumberDebugMessages")))
		Quit:($G(^hl7demo.MessageCount,1000000)<id)	
		Set person=##class(HL7Demo.Data.People).%OpenId(id)
		Set OutputFileName = person.GivenName_person.MiddleInitial_person.Surname 
		
		Kill Map,Message
		Do ##class(HL7Demo.Test1).GetADTLogicalMap("ADT^A08",.Map)
		Set sc=##class(HL7Demo.PeopleDataLoader).LoadMap(id,.Map,.Segments)
		if $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
		Do ##class(HL7Demo.Test1).CreateMessage(.Segments,.Map,.Message,.HL7Message)
		do ..post(hl7Sender,HL7Message)
		
		// Vital Sign Observations
		Kill VitalsMap,VitalsMessage
		Do ##class(HL7Demo.Test1).GetADTLogicalMap("ADT^A08",.VitalsMap)
		Merge VitalsMap("PID")=Map("PID")
		Merge VitalsMap("PV1")=Map("PV1")
		Set sc=##class(HL7Demo.PeopleDataLoader).LoadVitalsMap(id,.VitalsMap,.Segments)
		if $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
		Do ##class(HL7Demo.Test1).CreateMessage(.Segments,.VitalsMap,.VitalsMessage,.HL7Message)
		do ..post(hl7Sender,HL7Message)

		// Medications
		Set numberOfMeds=$Random(##class(HL7Demo.PeopleDataLoader).%GetParameter("MaxNumberMedMessages"))+1
		For i=1:1:numberOfMeds {
			Kill MedsMap,MedsMessage
			Do ##class(HL7Demo.Test1).GetADTLogicalMap("OMP^O09",.MedsMap)
			Merge MedsMap("PID")=Map("PID")
			Merge MedsMap("PV1")=Map("PV1")
			Set sc=##class(HL7Demo.PeopleDataLoader).LoadMedsMap(id,.MedsMap,.MedsSegments)
			if $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
			Do ##class(HL7Demo.Test1).CreateMessage(.MedsSegments,.MedsMap,.MedsMessage,.HL7Message)
			do ..post(hl7Sender,HL7Message)
			
		}
		
		// Labs
		Set numberOfLabs=$Random(##class(HL7Demo.PeopleDataLoader).%GetParameter("MaxNumberLabMessages"))+1
		For i=1:1:numberOfLabs {
			Kill LabsMap,LabsMessage
			Do ##class(HL7Demo.Test1).GetADTLogicalMap("ORU^R01",.LabsMap)
			Merge LabsMap("PID")=Map("PID")
			Merge LabsMap("PV1")=Map("PV1")
			Set sc=##class(HL7Demo.PeopleDataLoader).LoadLabsMap(id,.LabsMap,.LabsSegments)
			if $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
			Do ##class(HL7Demo.Test1).CreateMessage(.LabsSegments,.LabsMap,.LabsMessage,.HL7Message)
			do ..post(hl7Sender,HL7Message)
		}
		
		// Notes
		Set numberOfNotes=$Random(##class(HL7Demo.PeopleDataLoader).%GetParameter("MaxNumberNotesMessages"))+1
		For i=1:1:numberOfNotes {
			Kill NotesMap,NotesMessage
			Do ##class(HL7Demo.Test1).GetADTLogicalMap("MDM^T02",.NotesMap)
			Merge NotesMap("PID")=Map("PID")
			Merge NotesMap("PV1")=Map("PV1")
			// flip-a-coin either document or image
			If ( $Random(2) ) {
				Set sc=##class(HL7Demo.PeopleDataLoader).LoadNotesMap(id,.NotesMap,.NotesSegments)
			} Else {
				Set sc=##class(HL7Demo.PeopleDataLoader).LoadNotesImageMap(id,.NotesMap,.NotesSegments)
				Set gotImg=1
			}			
			If ( '$G(gotImg,0)) {
				Set sc=##class(HL7Demo.PeopleDataLoader).LoadNotesImageMap(id,.NotesMap,.NotesSegments)
			}	
			if $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
			Do ##class(HL7Demo.Test1).CreateMessage(.NotesSegments,.NotesMap,.NotesMessage,.HL7Message)
			do ..post(hl7Sender,HL7Message)
		}
		Set gotImg=0
		
		
	}
	Kill ^||hl7demo.CodeSets    // force reload of code set on next run
}

ClassMethod DumpMessage(ByRef Message, fstream As %Library.FileCharacterStream)
{
	
	//u 0 w fname,!
	Set i=$Order(Message(""))
	while ( i'="") {
		//Do Message(i).OutputToDevice()
		//Write $c(10)
		Set sc=Message(i).OutputToLibraryStream(fstream)
		
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
		//Set seg=Message(i).OutputToString()
		//Break
		//Set sc=fstream.WriteLine(seg)
		Set sc=fstream.Write($C(10))
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)

		Set i=$Order(Message(i))
	}
	Set sc=fstream.Write( $c(13) )
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)

	Set sc=fstream.Flush()
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
}

/// Given an HL7Demo.Data.People ID - load up the Map of data elements
/// a lÃ¡ the HL7 way
ClassMethod LoadMap(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set fields = $lb("PatientName","PatientAddress","Race","PhoneNumberHome","PatientAccountNumber","DateOfBirth","SSNNumberPatient","AdministrativeSex")
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	Set Map("PID","PatientName")=dude.Surname_"^"_dude.GivenName_"^"_dude.MiddleInitial
	Set Map("PID","PatientAddress")=dude.StreetAddress_"^^"_dude.City_"^"_dude.State_"^"_dude.ZipCode
	Set Map("PID","PhoneNumberHome")=dude.TelephoneNumber
	Set Map("PID","PatientAccountNumber")=$random(1000000)
	Set Map("PID","PatientIdentifierList")=dude.GUID_"^^^PiedmontEMR^MR"
	Set Map("PID","DateTimeofBirth")=##class(HL7Demo.Util).HL7DateTime($ZDH(dude.Birthday))
	Set Map("PID","SSNNumberPatient")=dude.NationalID
	Set Map("PID","AdministrativeSex")=$S(dude.Gender="male":"M",1:"F")
	
	Set Map("PV1","PatientClass")="I"
	Set Map("PV1","AttendingDoctor")=##class(HL7Demo.Util).RandomProvider()
	Set Map("PV1","VisitNumber")=dude.CCNumber
	Set Map("PV1","AdmitDateTime")=##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
	
	Set numberAllergies=$Random(10)+1
	For i=1:1:numberAllergies {
		Set Map("AL1",i,"SetIDAL1")=i
		Set allergyId = $Random(^HL7Demo.Data.AllergensD)+1
		Set allergy = ##class(HL7Demo.Data.Allergens).%OpenId(allergyId)
		Set Map("AL1",i,"AllergenCodeMnemonicDescript")=allergy.Species_"^"_allergy.Group_" "_allergy.Type_" "_allergy.IUISAllergen
		Set Map("AL1",i,"AllergenTypeCode")=##class(HL7Demo.Util).RandomCodedValue(##class(HL7Demo.Util).%GetParameter("csAllergenType"))
		Set Map("AL1",i,"AllergySeverityCode")=##class(HL7Demo.Util).RandomCodedValue(##class(HL7Demo.Util).%GetParameter("csAllergySeverity"))
		Set Map("AL1",i,"IdentificationDate")=##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
		Set Map("AL1",i,"AllergyReactionCode")=""	// don't need
	}
	Set Map("AL1")=numberAllergies
	
	
	Set numDX = $Random(10)+1
	if ( $data(^||hl7demo.diagnosis) ) {
		set numDX = 1
	}
	For i=1:1:numDX {
		Set Map("DG1",i,"SetIDDG1")=i
		// Override for specific diagnosis you want!
		if ( '$data(^||hl7demo.diagnosis) ) {
			Set dxId = $Random(^HL7Demo.Data.CMS30DXD)+1
			Set dx=##class(HL7Demo.Data.CMS30DX).%OpenId(dxId)
			Set Map("DG1",i,"DiagnosisCodeDG1")=dx.DIAGNOSISCODE_"^"_dx.SHORTDESCRIPTION
			Set Map("DG1",i,"DiagnosisDescription")=dx.LONGDESCRIPTION
			Set Map("DG1",i,"DiagnosisDateTime")=##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
			Set Map("DG1",i,"DiagnosisType")=##class(HL7Demo.Util).RandomCodedValue(##class(HL7Demo.Util).%GetParameter("csDiagnosisType"))
			Set Map("DG1")=numDX
		} else {
			set diags = ^||hl7demo.diagnosis
			set diagi = $random($listlength(diags))+1
			Set dxId = $list(^||hl7demo.diagnosis,diagi)
			Set dx=##class(HL7Demo.Data.CMS30DX).%OpenId(dxId)
			Set Map("DG1","DiagnosisCodeDG1")=dx.DIAGNOSISCODE_"^"_dx.SHORTDESCRIPTION
			Set Map("DG1","DiagnosisDescription")=dx.LONGDESCRIPTION
			Set Map("DG1","DiagnosisDateTime")=##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
			Set Map("DG1",i,"DiagnosisType")=##class(HL7Demo.Util).RandomCodedValue(##class(HL7Demo.Util).%GetParameter("csDiagnosisType"))
	
		}
	}
	Quit sc
}

ClassMethod TachycardDxCodes()
{
	
	set ids = $listbuild(4780,4781,4782,9203,9308)	
	for i=1:1:$ll(ids) {
		Set dx=##class(HL7Demo.Data.CMS30DX).%OpenId( $list(ids,i) )
		//zw dx
		write dx.DIAGNOSISCODE,!
	}
}
ClassMethod LoadMedsMapForTachycard(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	Set Map("ORC","OrderControl")=##class(HL7Demo.Util).RandomTableLookup("ORC","OrderControl",.Segments)
	Set Map("ORC","PlacerOrderNumber")=""
	Set Map("ORC","FillerOrderNumber")=""
	Set startTS = ##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
	Set $p(qt,"^",4)=startTS
	If ( $Random(2) ) { // optionall add end
		Set startH = ##class(HL7Demo.Util).HL7DateTimeToDollarH(startTS)
		Set endTS = ##class(HL7Demo.Util).RandomHL7DateTime(startH)
		Set $P(qt,"^",5)=endTS
	}
	Set Map("ORC","QuantityTiming")=qt
	Set Map("ORC","DateTimeofTransaction")=startTS
	Set Map("ORC","OrderingProvider")=##class(HL7Demo.Util).RandomProvider()
	
	//TQ1
	Set rp=##class(HL7Demo.Util).RandomTableLookup("TQ1","RepeatPattern",.Segments)
	Set $p(rp,"^",5)=$Random(7)		// TO-DO make this more robust
	Set Map("TQ1","RepeatPattern")=rp
	Set sdq=$Random(100)
	Set sd=sdq_"^"_$case(sdq#5,0:"Hours",1:"Days",2:"Weeks",3:"Months",4:"Years")
	Set Map("TQ1","ServiceDuration")=sd
	Set Map("TQ1","Startdatetime")=startTS
	Set Map("TQ1","Priority")=##class(HL7Demo.Util).RandomTableLookup("TQ1","Priority",.Segments)

	//RXO
	//Set medId=$Random(^HL7Demo.Data.MedicationsD)+1
	Set medId=312	//Amitriptyline
	Set med=##class(HL7Demo.Data.Medications).%OpenId(medId)
	
	Set Map("RXO","RequestedGiveCode")=med.Name_"^"_med.Name_" "_med.NDCID_" "_med.DrugType
	// either tablets or mgs
	Set tablet=$Random(2)
	If ( tablet ) {
		Set rgam=$Random(3)+1
		Set rgu=""
	} Else {
		Set rgam=$Random(500)+1
		Set rgu="mg^mg"
	}
	Set Map("RXO","RequestedGiveAmountMinimum")=rgam
	Set Map("RXO","RequestedGiveUnits")=rgu
	Set dtl=##class(HL7Demo.Util).RandomTableLookup("RXO","DeliverToLocation",.Segments)
	Set Map("RXO","DeliverToLocation")=dtl

	// FT1 to hold the Diagnosis code!
	set diags = ^||hl7demo.diagnosis
	set diagi = $random($listlength(diags))+1
	Set dxId = $list(^||hl7demo.diagnosis,diagi)
	Set dx=##class(HL7Demo.Data.CMS30DX).%OpenId(dxId)
	set tachyDiag=dx.DIAGNOSISCODE_"^"_dx.LONGDESCRIPTION

	Set Map("FT1","DiagnosisCodeFT1")=tachyDiag
	set Map("FT1","SetIDFT1")=1

	set Map("RXR","Route")="Oral"
	Quit sc
}
ClassMethod LoadMedsMap(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	Set Map("ORC","OrderControl")=##class(HL7Demo.Util).RandomTableLookup("ORC","OrderControl",.Segments)
	Set Map("ORC","PlacerOrderNumber")=""
	Set Map("ORC","FillerOrderNumber")=""
	Set startTS = ##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
	Set $p(qt,"^",4)=startTS
	If ( $Random(2) ) { // optionall add end
		Set startH = ##class(HL7Demo.Util).HL7DateTimeToDollarH(startTS)
		Set endTS = ##class(HL7Demo.Util).RandomHL7DateTime(startH)
		Set $P(qt,"^",5)=endTS
	}
	Set Map("ORC","QuantityTiming")=qt
	Set Map("ORC","DateTimeofTransaction")=startTS
	Set Map("ORC","OrderingProvider")=##class(HL7Demo.Util).RandomProvider()
	
	//TQ1
	Set rp=##class(HL7Demo.Util).RandomTableLookup("TQ1","RepeatPattern",.Segments)
	Set $p(rp,"^",5)=$Random(7)		// TO-DO make this more robust
	Set Map("TQ1","RepeatPattern")=rp
	Set sdq=$Random(100)
	Set sd=sdq_"^"_$case(sdq#5,0:"Hours",1:"Days",2:"Weeks",3:"Months",4:"Years")
	Set Map("TQ1","ServiceDuration")=sd
	Set Map("TQ1","Startdatetime")=startTS
	Set Map("TQ1","Priority")=##class(HL7Demo.Util).RandomTableLookup("TQ1","Priority",.Segments)
	
	//RXO
	Set medId=$Random(^HL7Demo.Data.MedicationsD)+1
	Set med=##class(HL7Demo.Data.Medications).%OpenId(medId)
	
	Set Map("RXO","RequestedGiveCode")=med.Name_"^"_med.Name_" "_med.NDCID_" "_med.DrugType
	// either tablets or mgs
	Set tablet=$Random(2)
	If ( tablet ) {
		Set rgam=$Random(3)+1
		Set rgu=""
	} Else {
		Set rgam=$Random(500)+1
		Set rgu="mg^mg"
	}
	Set Map("RXO","RequestedGiveAmountMinimum")=rgam
	Set Map("RXO","RequestedGiveUnits")=rgu
	Set dtl=##class(HL7Demo.Util).RandomTableLookup("RXO","DeliverToLocation",.Segments)
	Set Map("RXO","DeliverToLocation")=dtl
	Quit sc
}

ClassMethod LoadLabsMapForLDL(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	Set pon="PIED"_$i(^hl7demo.piedmont.ordernumbers)
	Set Map("ORC","PlacerOrderNumber")=pon
	Set Map("ORC","FillerOrderNumber")=pon
	Set startTS = ##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
	Set $p(qt,"^",4)=startTS
	If ( $Random(2) ) { // optionall add end
		Set startH = ##class(HL7Demo.Util).HL7DateTimeToDollarH(startTS)
		Set endTS = ##class(HL7Demo.Util).RandomHL7DateTime(startH)
		Set $P(qt,"^",5)=endTS
	}
	Set Map("ORC","QuantityTiming")=qt
	Set Map("ORC","DateTimeofTransaction")=startTS
	Set provider=##class(HL7Demo.Util).RandomProvider()
	Set Map("ORC","OrderingProvider")=provider
	Set Map("ORC","OrderStatus")=##class(HL7Demo.Util).RandomTableLookup("ORC","OrderStatus",.Segments,$LB("CM")) //,"IP","SC"))
	Set Map("ORC","OrderType")="LAB"  

	//OBR
	// OrderType
	#dim lab As HL7Demo.Data.CommonLabOrders
	Set Map("OBR","SetIDOBR")=1
	Set Map("OBR","UniversalServiceIdentifier")=##class(HL7Demo.Util).LDLLabOrder(.lab)
	Set Map("OBR","PriorityOBR")=""
	Set Map("OBR","RequestedDateTime")=startTS
	Set Map("OBR","ObservationDateTime")=startTS
	Set Map("OBR","ResultsRptStatusChngDateTime")=startTS
	Set resultStatus="F"
	Set Map("OBR","ResultStatus")=resultStatus
	
	
	Set Map("OBX",1,"SetIDOBX")=1
	Set Map("OBX",1,"ObservationIdentifier")=##class(HL7Demo.Util).LDLLabResult(.result)
	Set Map("OBX",1,"ValueType")="SN"
	// Generate a random LDL level between 25 and 220
	Set value = $random(220)+25
	Set Map("OBX",1,"ObservationValue")=value
	Set Map("OBX",1,"Units")=lab.ExampleUnitsUCUM
	Set Map("OBX",1,"ObservationResultStatus")=resultStatus
		
	Set Map("OBX")=1
	//zw Map
	Quit sc
}


ClassMethod LoadLabsMap(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	//Set Map("ORC","OrderControl")=##class(HL7Demo.Util).RandomTableLookup("ORC","OrderControl",.Segments,$LB("NW"))
	Set pon="PIED"_$i(^hl7demo.piedmont.ordernumbers)
	Set Map("ORC","PlacerOrderNumber")=pon
	Set Map("ORC","FillerOrderNumber")=pon
	Set startTS = ##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
	Set $p(qt,"^",4)=startTS
	If ( $Random(2) ) { // optionall add end
		Set startH = ##class(HL7Demo.Util).HL7DateTimeToDollarH(startTS)
		Set endTS = ##class(HL7Demo.Util).RandomHL7DateTime(startH)
		Set $P(qt,"^",5)=endTS
	}
	Set Map("ORC","QuantityTiming")=qt
	Set Map("ORC","DateTimeofTransaction")=startTS
	Set provider=##class(HL7Demo.Util).RandomProvider()
	Set Map("ORC","OrderingProvider")=provider
	Set Map("ORC","OrderStatus")=##class(HL7Demo.Util).RandomTableLookup("ORC","OrderStatus",.Segments,$LB("CM")) //,"IP","SC"))
	Set Map("ORC","OrderType")="LAB"  //##class(HL7Demo.Util).RandomTableLookup("ORC","OrderType",.Segments)

	//OBR
	// OrderType
	#dim lab As HL7Demo.Data.CommonLabOrders
	Set Map("OBR","SetIDOBR")=1
	Set Map("OBR","UniversalServiceIdentifier")=##class(HL7Demo.Util).RandomLabOrder(.lab)
	Set Map("OBR","PriorityOBR")=""
	Set Map("OBR","RequestedDateTime")=startTS
	Set Map("OBR","ObservationDateTime")=startTS
	Set Map("OBR","ResultsRptStatusChngDateTime")=startTS
	//Set resultStatus=##class(HL7Demo.Util).RandomTableLookup("OBR","ResultStatus",.Segments,$lb("P","F"))
	Set resultStatus="F"
	Set Map("OBR","ResultStatus")=resultStatus
	
	
	//Many OBX
	Set obxCount=$Random(10)+1
	For i=1:1:obxCount {
		Set Map("OBX",i,"SetIDOBX")=i
		Set Map("OBX",i,"ObservationIdentifier")=##class(HL7Demo.Util).RandomLabResult(.result)
		Set Map("OBX",i,"ValueType")="NM"
		Set value=$Random(1000)   //_lab.ExampleUnitsUCUM
		Set Map("OBX",i,"ObservationValue")=value
		Set Map("OBX",i,"Units")=lab.ExampleUnitsUCUM
		Set Map("OBX",i,"ObservationResultStatus")=resultStatus
		
	}
	Set Map("OBX")=obxCount
	Quit sc
}

/// Return just one note - can call multiple times from main loop
ClassMethod LoadNotesMap(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	//TXA||Progress note||200810130907|HB01^Winterbottom^Henry||||ISCGP001^Moore^James|||19815951^TRANS
 	//OBX||FT|RTF^TRANS||Patient seems vague complaining of dizziness and fatigue need to check blood sugar and Haemoglobin. ||||||R
	Set TS=##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
	// Let's support - Progress Notes, Consultations, Discharge Summary, ED Report
	// PR,CN,DS,ED
	Set NoteType=##class(HL7Demo.Util).RandomTableLookup("TXA","DocumentType",.Segments,$LB("PR","CN","DS","ED"))
	//Set NoteType="ED"
	Set Map("TXA","DocumentType")=NoteType
	Set Map("TXA","ActivityDateTime")=TS
	Set provider=##class(HL7Demo.Util).RandomProvider()
	Set Map("TXA","PrimaryActivityProviderCodeN")=provider
	Set originator=##class(HL7Demo.Util).RandomProvider()
	Set Map("TXA","OriginatorCodeName")=originator
	Set dns=$Random(3)
	Set DocNameSpace=$Case(dns#3,0:"USNMA",1:"PIED",2:"UofVA")
	Set Map("TXA","UniqueDocumentNumber")=$I(^||hl7demo.DocumentCounter)_"^"_DocNameSpace
	Set document=##class(HL7Demo.Util).GetRandomDocument($Piece(NoteType,"^",1))
	Set numberLines = $Length(document,$C(10))
	for i=1:1:numberLines {
		Set Map("OBX",i,"ValueType")="FT"
		Set Map("OBX",i,"ObservationIdentifier")="TXT^"_DocNameSpace
		Set Map("OBX",i,"ObservationValue")=$Piece(document,$C(10),i)
		Set Map("OBX",i,"ObservationResultStatus")="R"	
	}
	Set Map("OBX")=numberLines
	Quit sc
}

/// Return just one note - can call multiple times from main loop
ClassMethod LoadNotesImageMap(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	//TXA||Progress note||200810130907|HB01^Winterbottom^Henry||||ISCGP001^Moore^James|||19815951^TRANS
 	//OBX||FT|RTF^TRANS||Patient seems vague complaining of dizziness and fatigue need to check blood sugar and Haemoglobin. ||||||R
	Set TS=##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
	// Let's support - Progress Notes, Consultations, Discharge Summary, ED Report
	// PR,CN,DS,ED
	Set nt=$Random(4)
	Set NoteType=$Case(nt#3,0:"PR",1:"CN",2:"DS",3:"ED")
	Set DocNumber = $I(^||hl7demo.DocumentCounter)
	Set dt=dude.Surname_" "_dude.GivenName_" "_NoteType_DocNumber
	Set Map("TXA","DocumentType")=dt
	Set Map("TXA","ActivityDateTime")=TS
	Set provider=##class(HL7Demo.Util).RandomProvider()
	Set Map("TXA","PrimaryActivityProviderCodeN")=provider
	Set originator=##class(HL7Demo.Util).RandomProvider()
	Set Map("TXA","OriginatorCodeName")=originator
	Set dns=$Random(3)
	Set DocNameSpace=$Case(dns#3,0:"USNMA",1:"PIED",2:"UofVA")
	Set Map("TXA","UniqueDocumentNumber")=DocNumber_"^"_DocNameSpace
	Set Map("TXA","UniqueDocumentFileName")=dt
	Set document=##class(HL7Demo.Util).GetRandomImage($Piece(NoteType,"^",1),.it)
	Set Map("TXA","DocumentContentPresentation")=$zconvert($P(document,".",$L(document,".")),"U")
	Set numberLines = $Length(document,$C(13,10))
	Set IMGPATH="../custom/hl7demo_img/"
	for i=1:1:numberLines {
		Set Map("OBX",i,"ValueType")="RP"  //"ED"  //"FT"
		Set Map("OBX",i,"ObservationIdentifier")=$zconvert($lg(it,2),"U")_"^"_DocNameSpace
		//Set Map("OBX",i,"ObservationValue")="^^"_$zconvert($lg(it,2),"U")_"^Base64^"_$Piece(document,$C(13,10),i)
		Set path=IMGPATH_document
		Set Map("OBX",i,"ObservationValue")=path
		//Set Map("OBX",i,"ObservationResultStatus")="R"	
	}
	Set Map("OBX")=numberLines
	Quit sc
}

ClassMethod LoadVitalsMap(PersonID As %String, ByRef Map, ByRef Segments) As %Status
{
	Set sc=$$$OK
	Set dude=##class(HL7Demo.Data.People).%OpenId(PersonID)
	If ('$IsObject(dude) ) {
		Quit %objlasterror
	}
	// Each "Vital" will contain every type
	// Vitals - Height, Weight, BP Diastolic,BP Systolic, Oxygen, Respiratory Rate, Body Temp,Heart Rate = 8
	Set NumberOfOBXPerVital = 8
	Set numVitals = $Random(10)+1
	For i=1:1:numVitals {
		Set TS=##class(HL7Demo.Util).RandomHL7DateTime($ZDH(dude.Birthday))
		// Height
		Set SetId = ((i-1)*NumberOfOBXPerVital)+1
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("Height")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		
		Set Map("OBX",SetId,"ObservationValue")=dude.Centimeters
		Set Map("OBX",SetId,"Units")="cm"
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
		// Weight
		Set SetId = ((i-1)*NumberOfOBXPerVital)+2
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("Weight Measured")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		Set weightFlux=$Random(30)
		If ( $Random(2) ) {
			Set weight=dude.Kilograms+weightFlux
		} Else {
			Set weight = dude.Kilograms - weightFlux
		}
		Set Map("OBX",SetId,"ObservationValue")=weight
		Set Map("OBX",SetId,"Units")="kg"
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
		// Blood Pressure - BP Diastolic
		Set SetId = ((i-1)*NumberOfOBXPerVital)+3
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("BP Diastolic")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		// normal < 80, prehypertension 81-90, high > 90
		If ( $Random(2) ) {		// Flip-coin, either high, low, or normal based on median normal
			Set value = $Random(30)+80  // swings 30 
		} Else {
			Set value = 80-$Random(30)
		}
		Set Map("OBX",SetId,"ObservationValue")=value
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
		
		// systolic 
		// normal < 120, prehypertension 120-139, hi > 140
		Set SetId = ((i-1)*NumberOfOBXPerVital)+4
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("BP Systolic")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		If ( $Random(2) ) {		// Flip-coin, either high, low, or normal based on median normal
			Set value = $Random(30)+120  // swings 30 
		} Else {
			Set value = 120-$Random(30)
		}
		Set Map("OBX",SetId,"ObservationValue")=value
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
		// Oxygen
		Set SetId = ((i-1)*NumberOfOBXPerVital)+5
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("O2 % BldC Oximetry")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		// Normal is 94-98%
		If ( $Random(2) ) {		// Flip-coin, either high, low, or normal based on median normal
			Set value = $Random(4)+94  
		} Else {
			Set value = 94-$Random(4)
		}
		Set Map("OBX",SetId,"ObservationValue")=value
		Set Map("OBX",SetId,"Units")="%"
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
		
		// Respiratory Rate
		Set SetId = ((i-1)*NumberOfOBXPerVital)+6
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("Respiratory Rate")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		// Normal is 15-20/min, sick > 20, really sick > 30
		If ( $Random(2) ) {		// Flip-coin, either high, low, or normal based on median normal
			Set value = $Random(10)+15   
		} Else {
			Set value = 20-$Random(10)
		}
		Set Map("OBX",SetId,"ObservationValue")=value
		Set Map("OBX",SetId,"Units")="/min"
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
		// Body Temperature
		Set SetId = ((i-1)*NumberOfOBXPerVital)+7
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("Body Temperature")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		// Normal is 98.6 - or 36.1-37.8C
		If ( $Random(2) ) {		// Flip-coin, either high, low, or normal based on median normal
			Set value = $Random(5)+98.6   
		} Else {
			Set value = 98.6-$Random(5)
		}
		Set Map("OBX",SetId,"ObservationValue")=value
		Set Map("OBX",SetId,"Units")="F"
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
		// Heart Rate
		Set SetId = ((i-1)*NumberOfOBXPerVital)+8
		Set Map("OBX",SetId,"SetIDOBX")=SetId
		Set io=^||hl7demo.VitalSignConcepts("Heart Rate")
		Set Map("OBX",SetId,"ObservationIdentifier")=$lg(io,2)_"^"_$lg(io,1)
		Set Map("OBX",SetId,"ValueType")="NM"
		// Normal is 60-100
		If ( $Random(2) ) {		
			Set value = $Random(20)+80   
		} Else {
			Set value = 80-$Random(20)
		}
		Set Map("OBX",SetId,"ObservationValue")=value
		Set Map("OBX",SetId,"Units")="/min"
		Set Map("OBX",SetId,"ObservationResultStatus")="F"
		Set Map("OBX",SetId,"DateTimeoftheObservation")=TS
		
	}
	Set Map("OBX")=numVitals*NumberOfOBXPerVital
	Quit $$$OK
}

}

