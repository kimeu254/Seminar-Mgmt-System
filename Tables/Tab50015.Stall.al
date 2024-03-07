/// <summary>
/// Table Stall (ID 50015).
/// </summary>
table 50015 Stall
{
    Caption = 'Stall';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Capacity; Integer)
        {
            Caption = 'Capacity';
        }
        field(4; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(6; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
        field(7; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(8; "Occupied (Number of Cattle)"; Integer)
        {
            Caption = 'Occupied (Number of Cattle)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = COUNT(Item WHERE("Stall No." = field("No.")));
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
            CattleFarmSetup.Get();
            CattleFarmSetup.TestField("Stall Nos.");
            NoSeriesMgt.InitSeries(CattleFarmSetup."Stall Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        SetLastModifiedDateTime();
    end;

    trigger OnModify()
    begin
        SetLastModifiedDateTime();
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        SetLastModifiedDateTime();
    end;

    var
        CattleFarmSetup: Record "Cattle Farm Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldStall">Record Stall.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldStall: Record Stall): Boolean
    var
        Stall: Record Stall;
    begin
        Stall := Rec;
        CattleFarmSetup.Get();
        CattleFarmSetup.TestField("Stall Nos.");
        if NoSeriesMgt.SelectSeries(CattleFarmSetup."Stall Nos.", OldStall."No. Series", Stall."No. Series") then begin
            NoSeriesMgt.SetSeries(Stall."No.");
            Rec := Stall;
            OnAssistEditOnBeforeExit(Stall);
            exit(true);
        end;
    end;

    protected procedure SetLastModifiedDateTime()
    begin
        "Last Modified Date Time" := CurrentDateTime();
        "Last Date Modified" := Today();
        OnAfterSetLastModifiedDateTime(Rec);
    end;

    local procedure TestNoSeries()
    var
        Stall: Record Stall;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not Stall.Get(Rec."No.") then begin
                CattleFarmSetup.Get();
                NoSeriesMgt.TestManual(CattleFarmSetup."Stall Nos.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAssistEditOnBeforeExit(var Stall: Record Stall)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var Stall: Record Stall; xStall: Record Stall; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetLastModifiedDateTime(var Stall: Record Stall)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Stall: Record Stall; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var Stall: Record Stall; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Stall: Record Stall; xStall: Record Stall; var IsHandled: Boolean)
    begin
    end;
}
