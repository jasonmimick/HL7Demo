Class HL7Demo.Util Extends %RegisteredObject
{

ClassMethod HL7DateTime(DollarHValue As %String = "") As %String
{
	If ( DollarHValue = "" ) {
		Set DollarHValue = $H
	}
	Quit $ZStrip($ZDateTime(DollarHValue,8,2),"*p")
}

ClassMethod HL7DateTimeToDollarH(HL7Value As %String = "") As %String
{
	Set year=$e(HL7Value,1,4)
	Set month = $e(HL7Value,5,6)
	Set day = $e(HL7Value,7,8)
	Set hour = $e(HL7Value,9,10)
	Set minute = $e(HL7Value,11,12)
	Quit $ZDateTimeH(month_"/"_day_"/"_year_" "_hour_":"_minute)
}

ClassMethod RandomHL7DateTime(FromDate) As %String
{
	Set Today = +$H, Span = Today - +FromDate 
	Set Date=Today - $Random(Span)
	Set Date=Date_","_$Random(24*60*60)
	Set RandomDate=##class(HL7Demo.Util).HL7DateTime(Date)
	Quit RandomDate
}

Parameter csAllergySeverity = "Allergy Severity";

Parameter csAllergenType = "Allergen Type";

Parameter csDiagnosisType = "Diagnosis Type";

ClassMethod LoadCodeSets() [ Internal ]
{
	Quit:$Data(^||hl7demo.CodeSets)
	Kill ^||hl7demo.CodeSets
	Set codeset=##class(HL7Demo.Util).%GetParameter("csAllergySeverity")
	Set i=0
	Set ^||hl7demo.CodeSets(codeset,$i(i))="SV^Severe"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="MO^Moderate"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="MI^Mild"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="U^Unknown"
	Set ^||hl7demo.CodeSets(codeset)=i
	Set i=0
	Set codeset=##class(HL7Demo.Util).%GetParameter("csAllergenType")
	Set ^||hl7demo.CodeSets(codeset,$i(i))="DA^Drug allergy"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="FA^Food allergy"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="MA^Miscellaneous allergy"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="MC^Miscellaneous contraindication"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="EA^Environmental Allergy"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="AA^Animal Allergy"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="PA^Plant Allergy"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="LA^Pollen Allergy"
	Set ^||hl7demo.CodeSets(codeset)=i
	
	Set i=0
	Set codeset=##class(HL7Demo.Util).%GetParameter("csDiagnosisType")
	Set ^||hl7demo.CodeSets(codeset,$i(i))="A^Admitting"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="W^Working"
	Set ^||hl7demo.CodeSets(codeset,$i(i))="F^Final"
	Set ^||hl7demo.CodeSets(codeset)=i
}

ClassMethod RandomCodedValue(CodeSet As %String) As %String
{
	Do ##class(HL7Demo.Util).LoadCodeSets()
	Set i=$Random(^||hl7demo.CodeSets(CodeSet))
	Set:i=0 i=1
	Quit $Get(^||hl7demo.CodeSets(CodeSet,i))
}

ClassMethod RandomTableLookup(Segment, Field, ByRef Segments, ValidResults As %List = "") As %String
{
	If ( ValidResults = "" ) {
		Set ValidResults = $ListBuild()
	}
	// Find table ref
	Set TableRef=""
	For j=1:1:Segments {
		If ($Data(Segments(j,Segment,Field,"table"))) { 
			Set TableRef=Segments(j,Segment,Field,"table")
			Quit
		}
	}
	Quit:TableRef="" ""
	Set version=$Piece(TableRef,":",1)
	Set id=$Piece(TableRef,":",2)
	Merge lookup=^EnsHL7.Description(version,"CT",id)
	If ( $ListData(ValidResults) ) {
		Set id=$ListGet(ValidResults,$Random($ListLength(ValidResults))+1)
		Quit id_"^"_lookup(id)
	}
	Set count=0
	Set i=$Order(lookup(""))
	// Spin through - count entries and organize 
	While (i'="") { 
		Set count=count+1
		Set order(count)=i_"^"_lookup(i)
		Set i=$Order(lookup(i))
	}
	Set id=$Random(count)+1
	Quit order(id)
}

ClassMethod RandomProvider() As %String
{
	Set providerId=$Random(^HL7Demo.Data.ProvidersD)+1
	Set provider =##class(HL7Demo.Data.Providers).%OpenId(providerId)
	Quit provider.IDNumber_"^"_provider.LastName_"^"_provider.FirstName
}

ClassMethod RandomLabOrder(Output lab) As %String
{
	Set labId=$Random(^HL7Demo.Data.CommonLabOrdersD)+1
	Set lab=##class(HL7Demo.Data.CommonLabOrders).%OpenId(labId)
	Quit lab.LOINCcode_"^"_lab.LOINCshortname_"^LN^"_lab.LOINClongcommonname
}
ClassMethod LDLLabOrder(Output lab) As %String
{
	Set LDLids = $listbuild(43,169)
	set labId = $list(LDLids,$random( $listlength(LDLids) )+1)
	Set lab=##class(HL7Demo.Data.CommonLabOrders).%OpenId(labId)
	Quit lab.LOINCcode_"^"_lab.LOINCshortname_"^LN^"_lab.LOINClongcommonname
}
ClassMethod LDLLabResult(Output result) As %String
{
	
	Set resultIds = $listbuild(63,68,92,135,219,249,761,764,765)
	Set resultId = $list(resultIds,$random($listlength(resultIds))+1)
	Set result=##class(HL7Demo.Data.CommonLabResults).%OpenId(resultId)
	Set return = result.LOINCNUM_"^"_result.LONGNAME
	Quit return
}

ClassMethod RandomLabResult(Output result) As %String
{
	
	Set resultId = $Random(^HL7Demo.Data.CommonLabResultsD)+1
	Set result=##class(HL7Demo.Data.CommonLabResults).%OpenId(resultId)
	Set return = result.LOINCNUM_"^"_result.LONGNAME
	Quit return
}

ClassMethod LoadVitalSignConceptCache()
{
	Kill ^||hl7demo.VitalSignConcepts
	Set rs=##class(%ResultSet).%New()
	Set sc=rs.Prepare("SELECT ConceptCode, ConceptName From HL7Demo_Data.VitalSignResultCodes")
	Set sc=rs.Execute()
	While ( rs.Next() ) {
		Set cn=rs.Get("ConceptName"),cc=rs.Get("ConceptCode")
		Set ^||hl7demo.VitalSignConcepts(cn)=$ListBuild(cn,cc)
	}
}

ClassMethod LoadSampleDocuments()
{
	Kill ^hl7demo.Documents,^hl7demo.DocumentsIndex
	Set dir=$System.Util.InstallDirectory()_"Data/HL7Demo.Data/Documents/Text"
	Set rs=##class(%ResultSet).%New("%File:FileSet")
	Set sc=rs.Execute(dir, "*.txt")
	While ( rs.Next() ) {
		//Break
		Set name=rs.Get("Name")
		Set fn=$Piece($Piece(name,"/",$Length(name,"/")),".",1,2)
		Set fs=##class(%Stream.FileCharacter).%New()
		Set fs.Filename=name
		Set gs=##class(%Stream.GlobalCharacter).%New()
		Set gs.%Location="^hl7demo.Documents("""_fn_""")"
		Set sc=gs.CopyFromAndSave(fs)
		Write "Saved ",name," to ",gs.%Location,!
		Set ^hl7demo.DocumentsIndex(fn)=gs.Id
		Set docType = $p(fn,".")
		//Set ^hl7demo.DocumentsIndex("doc",docType)=$g(^hl7demo.DocumentsIndex("doc",docType),0)+1
		Set ^hl7demo.DocumentsIndex("doc",docType)=$g(^hl7demo.DocumentsIndex("doc",docType))_$lb(fn)
	}
}

ClassMethod LoadImages()
{
	//Break
	// Load images
	Set dir=$System.Util.InstallDirectory()_"Data/HL7Demo.Data/Documents/Images"
	Set rs=##class(%ResultSet).%New("%File:FileSet")
	Set sc=rs.Execute(dir, "*.*")
	While ( rs.Next() ) {
		//Break
		Set name=rs.Get("Name")
		Set fn=$Piece($Piece(name,"/",$Length(name,"/")),".",1,2)
		Set ft=$Piece(name,".",$Length(name,"."))  // file type
		Set fs=##class(%Stream.FileBinary).%New()
		Set fs.Filename=name
		Set gs=##class(%Stream.GlobalCharacter).%New()
		Set gs.%Location="^hl7demo.Documents(""img"","""_fn_""","""_ft_""")"
		// convert to base 64
		Set sc=fs.Rewind()
		While ( 'fs.AtEnd ) {
			//Break
			Set chunk=fs.Read(50,.l)
			Set b64chunk=$system.Encryption.Base64Encode(chunk)
			Set sc=gs.Write(b64chunk)
		}
		Set sc=gs.%Save()
		Write "Saved ",name," to ",gs.%Location,!
		Set ^hl7demo.DocumentsIndex(fn)=gs.Id
		Set docType = $p(fn,".")
		//Set ^hl7demo.DocumentsIndex("img",docType)=$g(^hl7demo.DocumentsIndex("img",docType),0)+1
		Set ^hl7demo.DocumentsIndex("img",docType)=$g(^hl7demo.DocumentsIndex("img",docType))_$lb(fn)
	}
}

ClassMethod LoadDocs()
{
	Do ##class(HL7Demo.Util).LoadSampleDocuments()
	Do ##class(HL7Demo.Util).LoadImages()
	Do ##class(HL7Demo.Util).LoadRandomQuotes()
}

ClassMethod LoadRandomQuotes(NumberQuotes = 10) As %String
{
	Kill ^hl7demo.Quotes
	Write "Loading ",NumberQuotes_" random quotes",!
	For i=1:1:NumberQuotes {
		W:i#10 " "_i
		Kill data
		Set quoteUrl = "/api/v1/random"
		Set req=##class(%Net.HttpRequest).%New()
		Set req.Server="www.iheartquotes.com"
		Set sc=req.Get(quoteUrl)
		If ( $$$ISERR(sc) ) { Continue }
		While ( 'req.HttpResponse.Data.AtEnd ) {
			//Break
			Set line = req.HttpResponse.Data.ReadLine()
			If ( line [ "iheartquotes" ) {
				If ( $g(data)="" ) {
					Set data=line
				}
				Quit
			}
			Set data=$g(data)_line
		}
		Set ^hl7demo.Quotes($i(^hl7demo.Quotes))=data
		//Quit data
	}
	Write !,"Complete.",!
}

ClassMethod GetRandomDocument(DocType As %String, Output DocId) As %String
{
	//Break
	If ( DocType = "PR" ) {
		//Quit ##class(HL7Demo.Util).GetRandomQuote()
		Quit $Get(^hl7demo.Quotes($R(^hl7demo.Quotes)+1))
	}
	//Set numDocs = $Get(^hl7demo.DocumentsIndex("doc",DocType),0)
	//If ( numDocs = 0 ) { 	// default "ED.3"
	//}
	//Set id=$Random(numDocs)+1
	//Set fn=DocType_"."_id
	
	Set docIds = $Get(^hl7demo.DocumentsIndex("doc",DocType))
	Set fn=$ListGet(docIds,$Random($ListLength(docIds))+1)
	
	Set streamID = ^hl7demo.DocumentsIndex(fn)
	Set DocId=fn
	Set doc = $Piece(^hl7demo.Documents(fn,streamID,1),$C(10,10),2)
	Quit doc
}

ClassMethod GetRandomImage(DocType As %String, Output DocId) As %String
{
	// DocType = CN,DS,ED,EKG
	If ( "CN,DS,ED,EKG" '[ DocType ) {
		Set DocType = "ED"
	}
	
	//Set numDocs = $Get(^hl7demo.DocumentsIndex("img",DocType),0)
	Set docIds = $Get(^hl7demo.DocumentsIndex("img",DocType))
	Set fn=$ListGet(docIds,$Random($ListLength(docIds))+1)
	//Set id=$Random(numDocs)+1
	//Set fn=DocType_"."_id
	Set streamID = ^hl7demo.DocumentsIndex(fn)
	Set DocId=fn
	Set imageType = $Order(^hl7demo.Documents("img",fn,""))
	Set DocId = $ListBuild(fn,imageType)
	//Set doc = ^hl7demo.Documents("img",fn,imageType,streamID,1)
	Set doc = fn_"."_imageType
	Quit doc
}

}

