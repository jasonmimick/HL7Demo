Class HL7Demo.Test2 Extends %RegisteredObject
{

ClassMethod t1()
{
	Set msg =##class(EnsLib.HL7.Message).%New()
	Set controlID = ##class(EnsLib.HL7.Message).NewControlID()
	//Set msg.
	Set pid=##class(EnsLib.HL7.Segment).%New()
	Do pid.SetValueAt("PID",0)
	Do pid.SetValueAt("F",8)
	Do pid.SetValueAt("Hello",1)
	Do pid.SetValueAt("1.2",1.2)
	//Do msg.AddChild(1,pid)
	Do msg.OutputToDevice()
	w !
	Do pid.OutputToDevice()
}

ClassMethod CreateMessage(ByRef Segments, ByRef Map, Output MSegs, Output hl7m)
{
	set hl7m = ##class(EnsLib.HL7.Message).%New()
	Set hl7m.DocType="2.5:ADT_A01"
	//Break
	For i=1:1:Segments {
		Set segname=$Order(Segments(i,""))
		// Only process Segments we actually have data for
		Continue:'$Data(Map(segname))
		Set segRepeat = 1
		// Do we have repeats for this segment?
		If ( $Get(Map(segname),0)> 0 ) {	// yup
			Set segRepeat=Map(segname)
			//break
			For j=1:1:segRepeat {
				Set field=$Order(Segments(i,segname,"")) 
				Set seg=##class(EnsLib.HL7.Segment).%New()
				Do seg.SetValueAt(segname,0)
				While ( field'="" ) {
					Set value = $Get(Map(segname,j,field))
					Set position = $listget(Segments(i,segname,field),1)
					Do seg.SetValueAt(value,position)
					Set field=$Order(Segments(i,segname,field))
				}
				Set MSegs($i(MSegs))=seg
				Set sc=hl7m.SetSegmentAt(seg,segname_"("_MSegs_")")
			}
		} Else {   // just one instance of segment
			Set field=$Order(Segments(i,segname,"")) 
			Set seg=##class(EnsLib.HL7.Segment).%New()
			Do seg.SetValueAt(segname,0)
			While ( field'="" ) {
				Set value = $Get(Map(segname,field))
				Set position = $listget(Segments(i,segname,field),1)
				Do seg.SetValueAt(value,position)
				Set field=$Order(Segments(i,segname,field))
			}
			Set MSegs($i(MSegs))=seg
			Set sc=hl7m.SetSegmentAt(seg,segname)
			
		}
		
	}
	//break
}

ClassMethod SegmentsForMessageType(Version As %String = "2.5", MsgType As %String = "ADT_A01", AddOptionalSegments As %Boolean = 0, Output Segments) As %Status
{
	Set sc=$$$OK
	Set Segments = 0
	If '$Data(^EnsHL7.Schema(Version,"MS",MsgType)) Quit sc
	Set struct=^EnsHL7.Schema(Version,"MS",MsgType)
	For i=1:1:$Length(struct,"~") {
	//For i=1:1:$Get(^EnsHL7.Schema(Version,"MS",MsgType,"array"),0) {
		Set seginfo=$Piece(struct,"~",i)
		//Set segname=^EnsHL7.Schema(Version,"MS",MsgType,"array",i,"name")
		Continue:$Piece(seginfo,":",1)'=Version
		Set segname=$Piece(seginfo,":",2)
		//Set isOptional = $Get(^EnsHL7.Schema(Version,"MS",MsgType,"array",i,"opt"),0)
		//If ( isOptional && 'AddOptionalSegments ) {
		//	Continue	// Seg is optional, but don't want optional
		//}
		//If ($Extract(segname,4,5)="()" ) { Set segname=$Extract(segname,1,3) }
		//Set segtype=^EnsHL7.Schema(Version,"MS",MsgType,"array",i,"type")
		Set segtype=segname
		Set Segments($i(Segments),segname)=segtype
		// add segment field info
		Set fieldName=$Order(^EnsHL7.Schema(Version,"SS",segname,"names",""))
		While ( fieldName'="" ) {
			Set fieldNum = ^EnsHL7.Schema(Version,"SS",segname,"names",fieldName)
			Set dt=$listget(^EnsHL7.Schema(Version,"SS",segname),fieldNum)
			Set Segments(Segments,segname,fieldName)=$ListBuild(fieldNum,$lg(dt,1))
			// is there a coded-table lookup for this field?
			If ( $Data(^EnsHL7.Schema(Version,"SS",segname,"tables",fieldNum) ) ) {
				Set Segments(Segments,segname,fieldName,"table")=^EnsHL7.Schema(Version,"SS",segname,"tables",fieldNum)
			}
			Set fieldName=$Order(^EnsHL7.Schema(Version,"SS",segname,"names",fieldName))
		
		}
		
	}
	//break
	Quit sc
}

/*
// defaults
MSHData("SendingApplication")="PiedmontEMR"
MshData("SendingFacility")="Piedmont Healthcare"
MMSHData("ReceivingApplication")="HSDEMO"
MSHData("ReceivingFacility")="HealthShare Demo"
MSHData("DataTimeOfMessage")=$H


*/
ClassMethod GetMSHMap(MessageType As %String, ByRef MSHData = "", Output Map)
{
	
	If ('$Data(MSHData("SendingApplication"))) {
		Set MSHData("SendingApplication")="Piedmont Healthcare"
	}
	If ('$Data(MSHData("SendingFacility"))) {
		Set MSHData("SendingFacility")="PiedmontEMR"
	}
	If ('$Data(MSHData("ReceivingApplication"))) {
		Set MSHData("ReceivingApplication")="HSDEMO"
	}
	If ('$Data(MSHData("ReceivingFacility"))) {
		Set MSHData("ReceivingFacility")="HealthShare Demo"
	} 
	If ('$Data(MSHData("DateTimeOfMessage"))) {
		Set MSHData("DateTimeOfMessage")=$zstrip($zdatetime($h,8,2),"*p")
	}
	Set MSHData("ProcessingID")="D"
	Set MSHData("MessageControlID")=$i(^||hl7demo.MessageCounter)
	Set MSHData("MessageType")=MessageType
	Set MSHData("EncodingCharacters")="^~\&"
	Set MSHData("VersionID")="2.5"
	Merge Map("MSH")=MSHData
}

/// This returns a map like
/// Seg(segname,fieldName) of the data fields we wish to populate
/// for a sample ADT_A01 message
ClassMethod GetADTA01LogicalMap(Output Map)
{
	Do ##class(HL7Demo.Test1).GetMSHMap("ADT^A01",,.Map)
	Set fields = $lb("PatientName","PatientAddress","Race","PhoneNumberHome","PatientAccountNumber","DateOfBirth","SSNNumberPatient","AdministrativeSex")
	For i=1:1:$listlength(fields) {
		Set Map("PID",$listget(fields,i))=""
	}
	//Set Map("EVN","EventTypeCode")="A01"
	
	//Set Map("EVN","EventOccurred")=Map("MSH","DateTimeOfMessage")
	
	Set Map("EVN","DateTimePlannedEvent")=Map("MSH","DateTimeOfMessage")
	Set Map("PID","SetIDPID")=1
	Set Map("PV1","SetIDPV1")="1"
}

ClassMethod GetADTLogicalMap(MessageType As %String = "A08", Output Map)
{
	Do ##class(HL7Demo.Test1).GetMSHMap(MessageType,,.Map)
	Set fields = $lb("PatientName","PatientAddress","Race","PhoneNumberHome","PatientAccountNumber","DateOfBirth","SSNNumberPatient","AdministrativeSex")
	For i=1:1:$listlength(fields) {
		Set Map("PID",$listget(fields,i))=""
	}
	//Set Map("EVN","EventTypeCode")="A01"
	
	//Set Map("EVN","EventOccurred")=Map("MSH","DateTimeOfMessage")
	
	Set Map("EVN","DateTimePlannedEvent")=Map("MSH","DateTimeOfMessage")
	Set Map("PID","SetIDPID")=1
	Set Map("PV1","SetIDPV1")="1"
	
	/*
	Set al1Fields = $lb("SetIDAL1","AllergenTypeCode","AllergenCodeMnemonicDescript","AllergySeverityCode","AllergyReactionCode","IdentificationDate")
	For i=1:1:$listlength(al1Fields) {
		Set Map("AL1",$listget(al1Fields,i))=""
	}
	*/
}

}



