/// <summary>
/// Table Breed (ID 50016).
/// </summary>
table 50016 Breed
{
    Caption = 'Breed';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Breed List";
    LookupPageId = "Breed List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
