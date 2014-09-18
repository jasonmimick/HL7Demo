Class HL7Demo.Data.CommonLabOrders Extends %Persistent [ ProcedureBlock ]
{

Property CLASS As %String(MAXLEN = 500);

Property COMPONENT As %String(MAXLEN = 500);

Property Comments As %String(MAXLEN = 500);

Property ExampleUnitsUCUM As %String(MAXLEN = 500);

Property IncompleteName As %String(MAXLEN = 500);

Property LOINCcode As %String(MAXLEN = 500);

Property LOINClongcommonname As %String(MAXLEN = 500);

Property LOINCshortname As %String(MAXLEN = 500);

Property METHOD As %String(MAXLEN = 500);

Property PROPERTY As %String(MAXLEN = 500);

Property RankOrder As %String(MAXLEN = 500);

Property SCALE As %String(MAXLEN = 500);

Property SPCMN As %String(MAXLEN = 500);

Property TM As %String(MAXLEN = 500);

Property UsuallynotperformedatareferrallabX As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="CommonLabOrdersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLASS</Value>
</Value>
<Value name="3">
<Value>COMPONENT</Value>
</Value>
<Value name="4">
<Value>Comments</Value>
</Value>
<Value name="5">
<Value>ExampleUnitsUCUM</Value>
</Value>
<Value name="6">
<Value>IncompleteName</Value>
</Value>
<Value name="7">
<Value>LOINCcode</Value>
</Value>
<Value name="8">
<Value>LOINClongcommonname</Value>
</Value>
<Value name="9">
<Value>LOINCshortname</Value>
</Value>
<Value name="10">
<Value>METHOD</Value>
</Value>
<Value name="11">
<Value>PROPERTY</Value>
</Value>
<Value name="12">
<Value>RankOrder</Value>
</Value>
<Value name="13">
<Value>SCALE</Value>
</Value>
<Value name="14">
<Value>SPCMN</Value>
</Value>
<Value name="15">
<Value>TM</Value>
</Value>
<Value name="16">
<Value>UsuallynotperformedatareferrallabX</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.CommonLabOrdersD</DataLocation>
<DefaultData>CommonLabOrdersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.CommonLabOrdersD</IdLocation>
<IndexLocation>^HL7Demo.Data.CommonLabOrdersI</IndexLocation>
<StreamLocation>^HL7Demo.Data.CommonLabOrdersS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

