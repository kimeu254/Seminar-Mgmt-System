/// <summary>
/// TableExtension Item Table Ext (ID 50005) extends Record Item.
/// </summary>
tableextension 50005 "Item Table Ext" extends Item
{
    fields
    {
        field(50000; "Farm Item Type"; Enum "Farm Item Type")
        {
            Caption = 'Farm Item Type';
            DataClassification = ToBeClassified;
        }
        field(50002; "Breed Code"; Code[20])
        {
            Caption = 'Breed No.';
            TableRelation = Breed;

            trigger OnValidate()
            var
                Breed: Record Breed;
            begin
                if "Breed Code" = '' then begin
                    "Breed Description" := '';
                end else begin
                    Breed.Get("Breed Code");
                    "Breed Description" := Breed.Description;
                end;
            end;
        }
        field(50003; "Breed Description"; Text[50])
        {
            Caption = 'Breed Description';
            Editable = false;
        }
        field(50004; "Stall No."; Code[20])
        {
            Caption = 'Stall No.';
            TableRelation = Stall;

            trigger OnValidate()
            var
                CattleStall: Record Stall;
                ErrExceedCapacity: Label 'Stall Full Please Allocate Cattle %1 Another Stall.';
            begin
                if "Stall No." = '' then begin
                    "Stall Name" := '';
                end else begin
                    CattleStall.Get("Stall No.");
                    "Stall Name" := CattleStall.Name;
                    CattleStall.CalcFields("Occupied (Number of Cattle)");

                    IF (CattleStall."Occupied (Number of Cattle)" >= CattleStall.Capacity) THEN
                        Error(ErrExceedCapacity, "No.");
                    exit;
                end;
            end;
        }
        field(50005; "Stall Name"; Text[50])
        {
            Caption = 'Stall Name';
            Editable = false;
        }
        field(50006; "Adult / Calf"; Option)
        {
            Caption = 'Adult / Calf';
            OptionMembers = Adult,Calf;
        }
        field(50007; "Weight (Kgs)"; Decimal)
        {
            Caption = 'Weight (Kgs)';
        }
        field(50008; "Age (Months)"; Integer)
        {
            Caption = 'Age';
        }
        field(50009; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(50010; "Farm Entry Date"; Date)
        {
            Caption = 'Farm Entry Date';
        }
        field(50011; "Parent No."; Code[20])
        {
            Caption = 'Parent No.';
            TableRelation = Item where("Farm Item Type" = const(Cattle));

            trigger OnValidate()
            var
                Cattle: Record Item;
                ErrSameParentNo: Label 'Cannot assign same Cattle as Parent.';
            begin
                if "Parent No." = '' then begin
                    "Parent Age" := 0;
                    "Parent Description" := '';
                end else begin
                    if "Parent No." = "No." then Error(ErrSameParentNo);
                    Cattle.Get("Parent No.");
                    "Parent Description" := Cattle.Description;
                    "Parent Age" := Cattle."Age (Months)";
                end;
            end;
        }
        field(50012; "Parent Description"; Text[100])
        {
            Caption = 'Parent Description';
            Editable = false;
        }
        field(50013; "Parent Age"; Integer)
        {
            Caption = 'Parent Age (Months)';
            Editable = false;
        }
        field(50014; "Height (Centimeters)"; Decimal)
        {
            Caption = 'Height (Centimeters)';
        }
        field(50015; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Inactive;
        }
        field(50016; Gender; Option)
        {
            Caption = 'Gender';
            OptionMembers = Male,Female;
        }
    }

    /// <summary>
    /// IsCattle.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsCattle(): Boolean
    begin
        exit("Farm Item Type" = "Farm Item Type"::Cattle);
    end;

    /// <summary>
    /// IsAdultType.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsAdultType(): Boolean
    begin
        exit("Adult / Calf" = "Adult / Calf"::Adult);
    end;

    /// <summary>
    /// IsCalfType.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsCalfType(): Boolean
    begin
        exit(not IsAdultType());
    end;
}
