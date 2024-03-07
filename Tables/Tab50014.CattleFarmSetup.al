/// <summary>
/// Table Cattle Farm Setup (ID 50014).
/// </summary>
table 50014 "Cattle Farm Setup"
{
    Caption = 'Cattle Farm Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Stall Nos."; Code[20])
        {
            Caption = 'Stall Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Cattle Pregnancy Nos."; Code[20])
        {
            Caption = 'Cattle Preg. Nos.';
            TableRelation = "No. Series";
        }
        field(4; "Milk Collection Nos."; Code[20])
        {
            Caption = 'Milk Collection Nos.';
            TableRelation = "No. Series";
        }
        field(5; "Cattle Checkup Nos."; Code[20])
        {
            Caption = 'Cattle Checkup Nos.';
            TableRelation = "No. Series";
        }
        field(6; "Medical History Nos."; Code[20])
        {
            Caption = 'Medical History Nos.';
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
