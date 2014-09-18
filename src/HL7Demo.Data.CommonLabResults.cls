Class HL7Demo.Data.CommonLabResults Extends %Persistent [ ProcedureBlock ]
{

Property CLASS As %String(MAXLEN = 500);

Property LOINCNUM As %String(MAXLEN = 500);

Property LONGNAME As %String(MAXLEN = 500);

Property RANK As %String(MAXLEN = 500);

Property SHORTNAME As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="CommonLabResultsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLASS</Value>
</Value>
<Value name="3">
<Value>LOINCNUM</Value>
</Value>
<Value name="4">
<Value>LONGNAME</Value>
</Value>
<Value name="5">
<Value>RANK</Value>
</Value>
<Value name="6">
<Value>SHORTNAME</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.CommonLabResultsD</DataLocation>
<DefaultData>CommonLabResultsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.CommonLabResultsD</IdLocation>
<IndexLocation>^HL7Demo.Data.CommonLabResultsI</IndexLocation>
<StreamLocation>^HL7Demo.Data.CommonLabResultsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

