Class HL7Demo.Data.Allergens Extends %Persistent [ ProcedureBlock ]
{

Property Common As %String(MAXLEN = 500);

Property FirstVersion As %String(MAXLEN = 500);

Property GI As %String(MAXLEN = 500);

Property Group As %String(MAXLEN = 500);

Property IUISAllergen As %String(MAXLEN = 500);

Property Length As %String(MAXLEN = 500);

Property Species As %String(MAXLEN = 500);

Property Type As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="AllergensDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Common</Value>
</Value>
<Value name="3">
<Value>FirstVersion</Value>
</Value>
<Value name="4">
<Value>GI</Value>
</Value>
<Value name="5">
<Value>Group</Value>
</Value>
<Value name="6">
<Value>IUISAllergen</Value>
</Value>
<Value name="7">
<Value>Length</Value>
</Value>
<Value name="8">
<Value>Species</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.AllergensD</DataLocation>
<DefaultData>AllergensDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.AllergensD</IdLocation>
<IndexLocation>^HL7Demo.Data.AllergensI</IndexLocation>
<StreamLocation>^HL7Demo.Data.AllergensS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

