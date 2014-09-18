Class HL7Demo.Data.Providers Extends %Persistent [ ProcedureBlock ]
{

Property FirstName As %String(MAXLEN = 500);

Property IDNumber As %String(MAXLEN = 500);

Property LastName As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="ProvidersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FirstName</Value>
</Value>
<Value name="3">
<Value>IDNumber</Value>
</Value>
<Value name="4">
<Value>LastName</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.ProvidersD</DataLocation>
<DefaultData>ProvidersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.ProvidersD</IdLocation>
<IndexLocation>^HL7Demo.Data.ProvidersI</IndexLocation>
<StreamLocation>^HL7Demo.Data.ProvidersS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

