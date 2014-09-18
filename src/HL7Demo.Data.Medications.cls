Class HL7Demo.Data.Medications Extends %Persistent [ ProcedureBlock ]
{

Property BindingDBID As %String(MAXLEN = 500);

Property CASNumber As %String(MAXLEN = 500);

Property ChEBIID As %String(MAXLEN = 500);

Property ChemSpiderID As %String(MAXLEN = 500);

Property DPDID As %String(MAXLEN = 500);

Property DrugBankID As %String(MAXLEN = 500);

Property DrugType As %String(MAXLEN = 500);

Property Drugscomlink As %String(MAXLEN = 500);

Property GenBankID As %String(MAXLEN = 500);

Property HETID As %String(MAXLEN = 500);

Property KEGGCompoundID As %String(MAXLEN = 500);

Property KEGGDrugID As %String(MAXLEN = 500);

Property NDCID As %String(MAXLEN = 500);

Property Name As %String(MAXLEN = 500);

Property PdrhealthLink As %String(MAXLEN = 500);

Property PharmGKBID As %String(MAXLEN = 500);

Property PubChemCompoundID As %String(MAXLEN = 500);

Property PubChemSubstanceID As %String(MAXLEN = 500);

Property RxListLink As %String(MAXLEN = 500);

Property TTDID As %String(MAXLEN = 500);

Property UniProtID As %String(MAXLEN = 500);

Property UniProtTitle As %String(MAXLEN = 500);

Property WikipediaLink As %String(MAXLEN = 500);

<Storage name="Default">
<Data name="MedicationsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BindingDBID</Value>
</Value>
<Value name="3">
<Value>CASNumber</Value>
</Value>
<Value name="4">
<Value>ChEBIID</Value>
</Value>
<Value name="5">
<Value>ChemSpiderID</Value>
</Value>
<Value name="6">
<Value>DPDID</Value>
</Value>
<Value name="7">
<Value>DrugBankID</Value>
</Value>
<Value name="8">
<Value>DrugType</Value>
</Value>
<Value name="9">
<Value>Drugscomlink</Value>
</Value>
<Value name="10">
<Value>GenBankID</Value>
</Value>
<Value name="11">
<Value>HETID</Value>
</Value>
<Value name="12">
<Value>KEGGCompoundID</Value>
</Value>
<Value name="13">
<Value>KEGGDrugID</Value>
</Value>
<Value name="14">
<Value>NDCID</Value>
</Value>
<Value name="15">
<Value>Name</Value>
</Value>
<Value name="16">
<Value>PdrhealthLink</Value>
</Value>
<Value name="17">
<Value>PharmGKBID</Value>
</Value>
<Value name="18">
<Value>PubChemCompoundID</Value>
</Value>
<Value name="19">
<Value>PubChemSubstanceID</Value>
</Value>
<Value name="20">
<Value>RxListLink</Value>
</Value>
<Value name="21">
<Value>TTDID</Value>
</Value>
<Value name="22">
<Value>UniProtID</Value>
</Value>
<Value name="23">
<Value>UniProtTitle</Value>
</Value>
<Value name="24">
<Value>WikipediaLink</Value>
</Value>
</Data>
<DataLocation>^HL7Demo.Data.MedicationsD</DataLocation>
<DefaultData>MedicationsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^HL7Demo.Data.MedicationsD</IdLocation>
<IndexLocation>^HL7Demo.Data.MedicationsI</IndexLocation>
<StreamLocation>^HL7Demo.Data.MedicationsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}

