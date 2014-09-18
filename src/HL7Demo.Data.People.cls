Class HL7Demo.Data.People Extends %Persistent [ ProcedureBlock ]
{

Property Birthday As %String(MAXLEN = 500);

Property BloodType As %String(MAXLEN = 500);

Property CCExpires As %String(MAXLEN = 500);

Property CCNumber As %String(MAXLEN = 500);

Property CCType As %String(MAXLEN = 500);

Property CVV2 As %String(MAXLEN = 500);

Property Centimeters As %String(MAXLEN = 500);

Property City As %String(MAXLEN = 500);

Property Company As %String(MAXLEN = 500);

Property Country As %String(MAXLEN = 500);

Property CountryFull As %String(MAXLEN = 500);

Property Domain As %String(MAXLEN = 500);

Property EmailAddress As %String(MAXLEN = 500);

Property FeetInches As %String(MAXLEN = 500);

Property GUID As %String(MAXLEN = 500);

Property Gender As %String(MAXLEN = 500);

Property GivenName As %String(MAXLEN = 500);

Property Kilograms As %String(MAXLEN = 500);

Property Latitude As %String(MAXLEN = 500);

Property Longitude As %String(MAXLEN = 500);

Property MiddleInitial As %String(MAXLEN = 500);

Property MothersMaiden As %String(MAXLEN = 500);

Property NationalID As %String(MAXLEN = 500);

Property Number As %String(MAXLEN = 500);

Property Occupation As %String(MAXLEN = 500);

Property Password As %String(MAXLEN = 500);

Property Pounds As %String(MAXLEN = 500);

Property State As %String(MAXLEN = 500);

Property StreetAddress As %String(MAXLEN = 500);

Property Surname As %String(MAXLEN = 500);

Property TelephoneNumber As %String(MAXLEN = 500);

Property UPS As %String(MAXLEN = 500);

Property Username As %String(MAXLEN = 500);

Property Vehicle As %String(MAXLEN = 500);

Property ZipCode As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="PeopleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Birthday</Value>
</Value>
<Value name="3">
<Value>BloodType</Value>
</Value>
<Value name="4">
<Value>CCExpires</Value>
</Value>
<Value name="5">
<Value>CCNumber</Value>
</Value>
<Value name="6">
<Value>CCType</Value>
</Value>
<Value name="7">
<Value>CVV2</Value>
</Value>
<Value name="8">
<Value>Centimeters</Value>
</Value>
<Value name="9">
<Value>City</Value>
</Value>
<Value name="10">
<Value>Company</Value>
</Value>
<Value name="11">
<Value>Country</Value>
</Value>
<Value name="12">
<Value>CountryFull</Value>
</Value>
<Value name="13">
<Value>Domain</Value>
</Value>
<Value name="14">
<Value>EmailAddress</Value>
</Value>
<Value name="15">
<Value>FeetInches</Value>
</Value>
<Value name="16">
<Value>GUID</Value>
</Value>
<Value name="17">
<Value>Gender</Value>
</Value>
<Value name="18">
<Value>GivenName</Value>
</Value>
<Value name="19">
<Value>Kilograms</Value>
</Value>
<Value name="20">
<Value>Latitude</Value>
</Value>
<Value name="21">
<Value>Longitude</Value>
</Value>
<Value name="22">
<Value>MiddleInitial</Value>
</Value>
<Value name="23">
<Value>MothersMaiden</Value>
</Value>
<Value name="24">
<Value>NationalID</Value>
</Value>
<Value name="25">
<Value>Number</Value>
</Value>
<Value name="26">
<Value>Occupation</Value>
</Value>
<Value name="27">
<Value>Password</Value>
</Value>
<Value name="28">
<Value>Pounds</Value>
</Value>
<Value name="29">
<Value>State</Value>
</Value>
<Value name="30">
<Value>StreetAddress</Value>
</Value>
<Value name="31">
<Value>Surname</Value>
</Value>
<Value name="32">
<Value>TelephoneNumber</Value>
</Value>
<Value name="33">
<Value>UPS</Value>
</Value>
<Value name="34">
<Value>Username</Value>
</Value>
<Value name="35">
<Value>Vehicle</Value>
</Value>
<Value name="36">
<Value>ZipCode</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.PeopleD</DataLocation>
<DefaultData>PeopleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.PeopleD</IdLocation>
<IndexLocation>^HL7Demo.Data.PeopleI</IndexLocation>
<StreamLocation>^HL7Demo.Data.PeopleS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

