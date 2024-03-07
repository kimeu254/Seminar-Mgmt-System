/// <summary>
/// Table Seminar (ID 50001).
/// </summary>
table 50001 Seminar
{
    Caption = 'Seminar';
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
            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(4; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(5; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(6; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(7; Blocked; Boolean)
        {
            Caption = 'Blocked';
            trigger OnValidate()
            begin
                if not Blocked then
                    "Block Reason" := '';
            end;
        }
        field(8; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(9; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Seminar),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;
        }
        field(11; "Gen. Prod.  Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod.  Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Prod.  Posting Group" <> "Gen. Prod.  Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod.  Posting Group") then
                        Validate("VAT Prod.  Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(12; "VAT Prod.  Posting Group"; Code[10])
        {
            Caption = 'VAT Prod.  Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(13; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(14; "Block Reason"; Text[250])
        {
            Caption = 'Block Reason';

            trigger OnValidate()
            begin
                if ("Block Reason" <> '') and ("Block Reason" <> xRec."Block Reason") then
                    TestField(Blocked, true);
            end;
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(17; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(18; "Charge Type Filter"; Option)
        {
            Caption = 'Charge Type Filter';
            OptionMembers = Instructor,Room,Participant,Charge;
            FieldClass = FlowFilter;
        }
        field(19; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            Editable = false;
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = Sum("Seminar Ledger Entry"."Total Price" WHERE("Seminar No." = field("No."),
                                                                         "Posting Date" = field("Date Filter"),
                                                                         "Charge Type" = field("Charge Type Filter")));
        }
        field(20; "Total Price (Not Chargeable)"; Decimal)
        {
            Caption = 'Total Price (Not Chargeable)';
            FieldClass = FlowField;
            Editable = false;
            AutoFormatType = 1;
            CalcFormula = Sum("Seminar Ledger Entry"."Total Price" WHERE("Seminar No." = field("No."),
                                                                         "Posting Date" = field("Date Filter"),
                                                                         "Charge Type" = field("Charge Type Filter"),
                                                                         Chargeable = CONST(FALSE)));
        }
        field(21; "Total Price (Chargeable)"; Decimal)
        {
            Caption = 'Total Price (Chargeable)';
            FieldClass = FlowField;
            Editable = false;
            AutoFormatType = 1;
            CalcFormula = Sum("Seminar Ledger Entry"."Total Price" WHERE("Seminar No." = field("No."),
                                                                         "Posting Date" = field("Date Filter"),
                                                                         "Charge Type" = field("Charge Type Filter"),
                                                                         Chargeable = CONST(TRUE)));
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

        DeleteRelatedData;

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
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        DimMgt.UpdateDefaultDim(
          DATABASE::Seminar, "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");

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

        CommentLine.RenameCommentLine(CommentLine."Table Name"::Seminar, xRec."No.", "No.");
        DimMgt.RenameDefaultDim(DATABASE::Seminar, xRec."No.", "No.");

        SetLastModifiedDateTime();
    end;

    var
        SeminarSetup: Record "Seminar Setup";
        CommentLine: Record "Comment Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        DimMgt: Codeunit DimensionManagement;


    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldSeminar">Record Seminar.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldSeminar: Record Seminar): Boolean
    var
        Seminar: Record Seminar;
    begin
        Seminar := Rec;
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Nos.");
        if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", OldSeminar."No. Series", Seminar."No. Series") then begin
            NoSeriesMgt.SetSeries(Seminar."No.");
            Rec := Seminar;
            OnAssistEditOnBeforeExit(Seminar);
            exit(true);
        end;
    end;

    protected procedure SetLastModifiedDateTime()
    begin
        "Last Date Modified" := Today();
        OnAfterSetLastModifiedDateTime(Rec);
    end;

    local procedure TestNoSeries()
    var
        Seminar: Record Seminar;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not Seminar.Get(Rec."No.") then begin
                SeminarSetup.Get();
                NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos.");
                "No. Series" := '';
            end;
    end;

    local procedure DeleteRelatedData()
    begin
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", "No.");
        CommentLine.DeleteAll();

        DimMgt.DeleteDefaultDim(DATABASE::Seminar, "No.");

        OnAfterDeleteRelatedData(Rec);
    end;

    /// <summary>
    /// ValidateShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode, IsHandled);
        if IsHandled then
            exit;

        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        if not IsTemporary then begin
            DimMgt.SaveDefaultDim(DATABASE::Seminar, "No.", FieldNumber, ShortcutDimCode);
            Modify();
        end;

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAssistEditOnBeforeExit(var Seminar: Record Seminar)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var Seminar: Record Seminar; xSeminar: Record Seminar; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetLastModifiedDateTime(var Seminar: Record Seminar)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Seminar: Record Seminar; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var Seminar: Record Seminar; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Seminar: Record Seminar; xSeminar: Record Seminar; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteRelatedData(Seminar: Record Seminar)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var Seminar: Record Seminar; var xSeminar: Record Seminar; FieldNumber: Integer; var ShortcutDimCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var Seminar: Record Seminar; var xSeminar: Record Seminar; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;
}
