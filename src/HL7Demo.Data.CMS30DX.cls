Class HL7Demo.Data.CMS30DX Extends %Persistent [ ProcedureBlock ]
{

Property DIAGNOSISCODE As %String(MAXLEN = 500);

Property LONGDESCRIPTION As %String(MAXLEN = 500);

Property SHORTDESCRIPTION As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="CMS30DXDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DIAGNOSISCODE</Value>
</Value>
<Value name="3">
<Value>LONGDESCRIPTION</Value>
</Value>
<Value name="4">
<Value>SHORTDESCRIPTION</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.CMS30DXD</DataLocation>
<DefaultData>CMS30DXDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.CMS30DXD</IdLocation>
<IndexLocation>^HL7Demo.Data.CMS30DXI</IndexLocation>
<StreamLocation>^HL7Demo.Data.CMS30DXS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

