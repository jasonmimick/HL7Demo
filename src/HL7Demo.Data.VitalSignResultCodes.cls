Class HL7Demo.Data.VitalSignResultCodes Extends %Persistent [ ProcedureBlock ]
{

Property CodeSystemCode As %String(MAXLEN = 500);

Property CodeSystemName As %String(MAXLEN = 500);

Property CodeSystemOID As %String(MAXLEN = 500);

Property CodeSystemVersion As %String(MAXLEN = 500);

Property ConceptCode As %String(MAXLEN = 500);

Property ConceptName As %String(MAXLEN = 500);

Property HL7Table0396Code As %String(MAXLEN = 500);

Property PreferredAlternateCode As %String(MAXLEN = 500);

Property PreferredConceptName As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="VitalSignResultCodesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CodeSystemCode</Value>
</Value>
<Value name="3">
<Value>CodeSystemName</Value>
</Value>
<Value name="4">
<Value>CodeSystemOID</Value>
</Value>
<Value name="5">
<Value>CodeSystemVersion</Value>
</Value>
<Value name="6">
<Value>ConceptCode</Value>
</Value>
<Value name="7">
<Value>ConceptName</Value>
</Value>
<Value name="8">
<Value>HL7Table0396Code</Value>
</Value>
<Value name="9">
<Value>PreferredAlternateCode</Value>
</Value>
<Value name="10">
<Value>PreferredConceptName</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.VitalSignRe3FE9D</DataLocation>
<DefaultData>VitalSignResultCodesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.VitalSignRe3FE9D</IdLocation>
<IndexLocation>^HL7Demo.Data.VitalSignRe3FE9I</IndexLocation>
<StreamLocation>^HL7Demo.Data.VitalSignRe3FE9S</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

