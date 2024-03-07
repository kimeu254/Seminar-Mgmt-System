/// <summary>
/// Table Milk Collection (ID 50017).
/// </summary>
table 50017 "Milk Collection"
{
    Caption = 'Milk Collection';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    FarmSetup.Get();
                    NoSeriesMgt.TestManual(FarmSetup."Milk Collection Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Person));

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if "Resource No." <> '' then begin
                    Resource.Get("Resource No.");
                    "Resource Name" := Resource.Name;
                end else begin
                    "Resource Name" := '';
                end;
            end;
        }
        field(4; "Resource Name"; Text[100])
        {
            Caption = 'Resource Name';
            Editable = false;
        }
        field(5; "Total Amount (Ltrs)"; Decimal)
        {
            Caption = 'Total Amount (Ltrs)';
            Editable = false;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(7; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
        }
        field(8; "Comment"; Boolean)
        {
            Caption = 'Comment';
        }
        field(9; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnDelete(Rec, IsHandled);
        if IsHandled then
            exit;

        MilkCollectionLines.Reset();
        MilkCollectionLines.SetRange("Document No.", "No.");
        MilkCollectionLines.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsert(Rec, IsHandled);
        if IsHandled then
            exit;

        if "No." = '' then begin
            FarmSetup.Get();
            FarmSetup.TestField("Milk Collection Nos.");
            NoSeriesMgt.InitSeries(FarmSetup."Milk Collection Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        SetLastModifiedDateTime();
    end;

    trigger OnModify()
    begin
        SetLastModifiedDateTime();
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FarmSetup: Record "Cattle Farm Setup";
        MilkCollectionLines: Record "Milk Collection Lines";

    protected procedure SetLastModifiedDateTime()
    begin
        "Last Modified Date Time" := CurrentDateTime();
        "Last Date Modified" := Today();
        OnAfterSetLastModifiedDateTime(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetLastModifiedDateTime(var MilkCollection: Record "Milk Collection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var MilkCollection: Record "Milk Collection"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var MilkCollection: Record "Milk Collection"; var IsHandled: Boolean)
    begin
    end;
}
