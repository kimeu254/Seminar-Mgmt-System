/// <summary>
/// Table Milk Collection Lines (ID 50018).
/// </summary>
table 50018 "Milk Collection Lines"
{
    Caption = 'Milk Collection Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Cattle No."; Code[20])
        {
            Caption = 'Cattle No.';
            TableRelation = Item where("Farm Item Type" = const(Cattle));
            //NotBlank = true;

            trigger OnValidate()
            var
                Cattle: Record Item;
            begin
                if "Cattle No." <> '' then begin
                    Cattle.Get("Cattle No.");
                    "Cattle Description" := Cattle."No.";
                end else begin
                    "Cattle Description" := '';
                end;
            end;
        }
        field(4; "Cattle Description"; Text[100])
        {
            Caption = 'Cattle Description';
            Editable = false;
        }
        field(5; "Amount Collected (Ltrs)"; Decimal)
        {
            Caption = 'Amount Collected (Ltrs)';
        }
        field(6; "Fate Amount (Ltrs)"; Decimal)
        {
            Caption = 'Fate Amount (Ltrs)';
        }
        field(7; "Total Amount (Ltrs)"; Decimal)
        {
            Caption = 'Total Amount (Ltrs)';
            Editable = false;

            trigger OnValidate()
            begin
                "Total Amount (Ltrs)" := "Amount Collected (Ltrs)" - "Fate Amount (Ltrs)";
            end;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        MilkCollectionLines.Reset();
        MilkCollectionLines.SetRange("Document No.", Rec."Document No.");
        if MilkCollectionLines.FindLast() then begin
            "Line No." := MilkCollectionLines."Line No." + 1;
        end;
    end;

    var
        MilkCollectionLines: Record "Milk Collection Lines";
}
