/// <summary>
/// Table Seminar Registration Header (ID 50003).
/// </summary>
table 50003 "Seminar Registration Header"
{
    Caption = 'Seminar Registration Header';
    DataClassification = ToBeClassified;
    LookupPageId = "Seminar Registration List";
    DrillDownPageId = "Seminar Registration List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            trigger OnValidate()
            begin
                if "No." = xRec."No." then
                    exit;

                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                "No. Series" := '';
            end;
        }
        field(2; "Starting Date"; DateTime)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if "Starting Date" <> xRec."Starting Date" then begin
                    TestField(Status, Status::Planning);
                    "End Date" := "Starting Date" + (Duration * 60 * 60 * 1000);
                end;
            end;
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = Seminar where(Blocked = const(false));

            trigger OnValidate()
            begin
                IF "Seminar No." = xRec."Seminar No." THEN
                    exit;

                Seminar.GET("Seminar No.");
                Seminar.TESTFIELD(Blocked, FALSE);
                Seminar.TESTFIELD("Gen. Prod.  Posting Group");
                Seminar.TESTFIELD("VAT Prod.  Posting Group");
                "Seminar Name" := Seminar.Name;
                Duration := Seminar."Seminar Duration";
                "Seminar Price" := Seminar."Seminar Price";
                "Gen. Prod.  Posting Group" := Seminar."Gen. Prod.  Posting Group";
                "VAT Prod.  Posting Group" := Seminar."VAT Prod.  Posting Group";
                "Minimum Participants" := Seminar."Minimum Participants";
                "Maximum Participants" := Seminar."Maximum Participants";

                CreateDim(
                           DATABASE::Seminar, "Seminar No.",
                           DATABASE::Resource, "Instructor Resource No.",
                           DATABASE::Resource, "Room Resource No.");
            end;
        }
        field(4; "Seminar Name"; Text[100])
        {
            Caption = 'Seminar Name';
        }
        field(5; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            TableRelation = Resource where(Type = const(Person));

            trigger OnValidate()
            var
                Instructor: Record Resource;

            begin
                if "Instructor Resource No." = xRec."Instructor Resource No." then
                    exit;

                IF "Instructor Resource No." = '' THEN BEGIN
                    "Instructor Name" := '';
                END ELSE BEGIN
                    Instructor.GET("Instructor Resource No.");
                    "Instructor Name" := Instructor.Name;
                END;

                CreateDim(
                           DATABASE::Seminar, "Seminar No.",
                           DATABASE::Resource, "Instructor Resource No.",
                           DATABASE::Resource, "Room Resource No.");
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
        }
        field(7; Status; Enum "Seminar Registration Status")
        {
            Caption = 'Status';
        }
        field(8; "Duration"; Decimal)
        {
            Caption = 'Duration';
            trigger OnValidate()
            begin
                if Rec.Duration = xRec.Duration then
                    exit;

                if Rec.Duration <> xRec.Duration then
                    "End Date" := "Starting Date" + (Duration * 60 * 60 * 1000);
            end;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where(Type = const(Machine));

            trigger OnValidate()
            var
                SeminarRoom: Record Resource;
                //RoomCapErr: Label 'The selected room cannot accomodate this seminar';
                ChangeSeminarRoomQst: Label 'This Seminar is for %1 participants. \Room %2 has a maximum of %3 participants.';
            begin
                if "Room Resource No." = xRec."Room Resource No." then
                    exit;

                IF "Room Resource No." = '' THEN BEGIN
                    "Room Name" := '';
                    "Room Address" := '';
                    "Room Address 2" := '';
                    "Room Post Code" := '';
                    "Room City" := '';
                    "Room County" := '';
                    "Room Country/Reg. Code" := '';
                END ELSE BEGIN
                    SeminarRoom.GET("Room Resource No.");

                    if SeminarRoom."Maximum Participants" < "Maximum Participants" then
                        error(ChangeSeminarRoomQst,
                                "Maximum Participants",
                                SeminarRoom.Name,
                                SeminarRoom."Maximum Participants"
                            );

                    "Room Name" := SeminarRoom.Name;
                    "Room Address" := SeminarRoom.Address;
                    "Room Address 2" := SeminarRoom."Address 2";
                    "Room Post Code" := SeminarRoom."Post Code";
                    "Room City" := SeminarRoom.City;
                    "Room County" := SeminarRoom.County;
                    "Room Country/Reg. Code" := SeminarRoom."Country/Region Code";

                    // IF CurrFieldNo = 0 THEN
                    //     exit;

                    // IF (SeminarRoom."Maximum Participants" <> 0) AND
                    //    (SeminarRoom."Maximum Participants" < "Maximum Participants")
                    // THEN BEGIN
                    //     IF CONFIRM(ChangeSeminarRoomQst, TRUE,
                    //          "Maximum Participants",
                    //          SeminarRoom."Maximum Participants",
                    //          FIELDCAPTION("Maximum Participants"),
                    //          "Maximum Participants",
                    //          SeminarRoom."Maximum Participants")
                    //     THEN
                    //         "Maximum Participants" := SeminarRoom."Maximum Participants";
                    // END;
                END;

                CreateDim(
                           DATABASE::Seminar, "Seminar No.",
                           DATABASE::Resource, "Instructor Resource No.",
                           DATABASE::Resource, "Room Resource No.");
            end;
        }
        field(12; "Room Name"; Text[100])
        {
            Caption = 'Room Name';
        }
        field(13; "Room Address"; Text[50])
        {
            Caption = 'Room Address';
        }
        field(14; "Room Address 2"; Text[50])
        {
            Caption = 'Room Address 2';
        }
        field(15; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Room City",
                    "Room Post Code",
                    "Room County",
                    "Room Country/Reg. Code",
                    (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(16; "Room City"; Text[50])
        {
            Caption = 'Room City';
        }
        field(17; "Room Country/Reg. Code"; Code[10])
        {
            Caption = 'Room Country/Reg. Code';
            TableRelation = "Country/Region";
        }
        field(18; "Room County"; Text[30])
        {
            Caption = 'Room County';
        }
        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
        }
        field(20; "Gen. Prod.  Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod.  Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(21; "VAT Prod.  Posting Group"; Code[20])
        {
            Caption = 'VAT Prod.  Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(22; Comment; Boolean)
        {
            Caption = 'Comment';
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(25; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(26; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(27; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "Posting No. Series" = '' then
                    exit;
                TestField("Posting No.", '');

                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                NoSeriesMgt.TestSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");
            end;

            trigger OnLookup()
            begin
                SeminarRegHeader := Rec;
                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                if NoSeriesMgt.LookupSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series") then
                    Validate("Posting No. Series");

                Rec := SeminarRegHeader;
            end;
        }
        field(28; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }

        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(31; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(32; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(33; "Registered Participants"; Integer)
        {
            Caption = 'Registered Participants';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = COUNT("Seminar Registration Line" WHERE("Document No." = field("No.")));
        }
        field(34; "Approval Status"; Enum "Custom Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;
        }
        field(35; "End Date"; DateTime)
        {
            Caption = 'End Date';
            Editable = false;
        }
        field(36; "Total Price (To Invoice)"; Decimal)
        {
            Caption = 'Total Price';
            Editable = false;
            CalcFormula = sum("Seminar Registration Line".Amount where("Document No." = field("No."),
                                                                            "To Invoice" = const(true)));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Index2; "Room Resource No.")
        {
            SumIndexFields = Duration;
        }
    }

    var
        SeminarSetup: Record "Seminar Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PostCode: Record "Post Code";
        Seminar: Record Seminar;
        SeminarRegHeader: Record "Seminar Registration Header";
        SeminarCommentLine: Record "Seminar Comment Line";
        //ChangeSeminarRoomQst: Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        SeminarRegLine: Record "Seminar Registration Line";
        SeminarCharge: Record "Seminar Charge";
        ErrCannotDeleteLine: Label 'Cannot delete the Seminar Registration, there exists at least one %1 where %2=%3.';
        ErrCannotDeleteCharge: Label 'Cannot delete the Seminar Registration, there exists at least one %1.';
        DimMgt: Codeunit DimensionManagement;
        HideValidationDialog: Boolean;
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        InitRecord;

        if GetFilter("Seminar No.") = '' then
            exit;

        IF GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") THEN
            Validate("Seminar No.", GetRangeMin("Seminar No."));
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::Cancelled);

        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", "No.");
        SeminarRegLine.SETRANGE(Registered, TRUE);
        IF SeminarRegLine.FIND('-') THEN
            ERROR(
              ErrCannotDeleteLine,
              SeminarRegLine.TABLECAPTION,
              SeminarRegLine.FIELDCAPTION(Registered),
              TRUE);
        SeminarRegLine.SETRANGE(Registered);
        SeminarRegLine.DELETEALL(TRUE);

        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", "No.");
        IF NOT SeminarCharge.ISEMPTY THEN
            ERROR(ErrCannotDeleteCharge, SeminarCharge.TABLECAPTION);

        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange(
            "Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.DeleteAll();
    end;

    procedure InitRecord()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();

        "Document Date" := WorkDate();

        SeminarSetup.Get();
        SeminarSetup.TestField("Posted Seminar Reg. Nos.");
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record "Seminar Registration Header"): Boolean
    begin
        SeminarRegHeader := Rec;
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        if not NoSeriesMgt.SelectSeries(
            SeminarSetup."Seminar Registration Nos.",
            OldSeminarRegHeader."No. Series", "No. Series") then
            exit(false);

        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        NoSeriesMgt.SetSeries("No.");
        Rec := SeminarRegHeader;
        exit(TRUE);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify();

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if SeminarRegLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

#if not CLEAN20
    [Obsolete('Replaced by CreateDim(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])', '20.0')]
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
        IsHandled: Boolean;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        IsHandled := false;
        OnBeforeCreateDim(Rec, IsHandled, DefaultDimSource);
        if IsHandled then
            exit;

        SourceCodeSetup.Get();
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        OnAfterCreateDimTableIDs(Rec, CurrFieldNo, TableID, No);
        CreateDefaultDimSourcesFromDimArray(DefaultDimSource, TableID, No);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, SourceCodeSetup.Seminar, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        OnCreateDimOnBeforeUpdateLines(Rec, xRec, CurrFieldNo, OldDimSetID, DefaultDimSource);

        if (OldDimSetID <> "Dimension Set ID") and SeminarRegLinesExist() then begin
            Modify();
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;
#endif

    procedure CreateDim(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])
    var
        SourceCodeSetup: Record "Source Code Setup";
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateDim(Rec, IsHandled, DefaultDimSource);
        if IsHandled then
            exit;

        SourceCodeSetup.Get();
#if not CLEAN20
        RunEventOnAfterCreateDimTableIDs(DefaultDimSource);
#endif

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, SourceCodeSetup.Seminar, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        OnCreateDimOnBeforeUpdateLines(Rec, xRec, CurrFieldNo, OldDimSetID, DefaultDimSource);

        if (OldDimSetID <> "Dimension Set ID") and SeminarRegLinesExist() then begin
            OnCreateDimOnBeforeModify(Rec, xRec, CurrFieldNo, OldDimSetID);
            Modify();
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowDocDim(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            Rec, "Dimension Set ID", StrSubstNo('%1 %2', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        OnShowDocDimOnBeforeUpdateSeminarRegLines(Rec, xRec);
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if SeminarRegLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure SeminarRegLinesExist(): Boolean
    begin
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        exit(not SeminarRegLine.IsEmpty());
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        xSeminarRegLine: Record "Seminar Registration Line";
        NewDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateAllLineDim(Rec, NewParentDimSetID, OldParentDimSetID, IsHandled, xRec);
        if IsHandled then
            exit;

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not GetHideValidationDialog() and GuiAllowed then
            if not ConfirmUpdateAllLineDim(NewParentDimSetID, OldParentDimSetID) then
                exit;

        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        SeminarRegLine.LockTable();
        if SeminarRegLine.Find('-') then
            repeat
                OnUpdateAllLineDimOnBeforeGetSeminarRegLineNewDimsetID(SeminarRegLine, NewParentDimSetID, OldParentDimSetID);
                NewDimSetID := DimMgt.GetDeltaDimSetID(SeminarRegLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                OnUpdateAllLineDimOnAfterGetSeminarRegLineNewDimsetID(Rec, xRec, SeminarRegLine, NewDimSetID, NewParentDimSetID, OldParentDimSetID);
                if SeminarRegLine."Dimension Set ID" <> NewDimSetID then begin
                    xSeminarRegLine := SeminarRegLine;
                    SeminarRegLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      SeminarRegLine."Dimension Set ID", SeminarRegLine."Shortcut Dimension 1 Code", SeminarRegLine."Shortcut Dimension 2 Code");

                    OnUpdateAllLineDimOnBeforeSeminarRegLineModify(SeminarRegLine, xSeminarRegLine);
                    SeminarRegLine.Modify();
                    OnUpdateAllLineDimOnAfterSeminarRegLineModify(SeminarRegLine);
                end;
            until SeminarRegLine.Next() = 0;
    end;

    procedure GetHideValidationDialog(): Boolean
    begin
        exit(HideValidationDialog);
    end;

    local procedure CreateDefaultDimSourcesFromDimArray(var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; TableID: array[10] of Integer; No: array[10] of Code[20])
    var
        DimArrayConversionHelper: Codeunit "Dim. Array Conversion Helper";
    begin
        DimArrayConversionHelper.CreateDefaultDimSourcesFromDimArray(Database::"Seminar Registration Header", DefaultDimSource, TableID, No);
    end;

    local procedure ConfirmUpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer) Confirmed: Boolean;
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeConfirmUpdateAllLineDim(Rec, xRec, NewParentDimSetID, OldParentDimSetID, Confirmed, IsHandled);
        if not IsHandled then
            Confirmed := Confirm(Text064);
    end;

    local procedure RunEventOnAfterCreateDimTableIDs(var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])
    var
        DimArrayConversionHelper: Codeunit "Dim. Array Conversion Helper";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRunEventOnAfterCreateDimTableIDs(Rec, DefaultDimSource, IsHandled);
        if IsHandled then
            exit;

        // if not DimArrayConversionHelper.IsSubscriberExist(Database::"Seminar Registration Header") then
        //     exit;

        CreateDimTableIDs(DefaultDimSource, TableID, No);
        OnAfterCreateDimTableIDs(Rec, CurrFieldNo, TableID, No);
        CreateDefaultDimSourcesFromDimArray(DefaultDimSource, TableID, No);
    end;

    local procedure CreateDimTableIDs(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; var TableID: array[10] of Integer; var No: array[10] of Code[20])
    var
        DimArrayConversionHelper: Codeunit "Dim. Array Conversion Helper";
    begin
        DimArrayConversionHelper.CreateDimTableIDs(Database::"Sales Header", DefaultDimSource, TableID, No);
    end;



    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var SeminarRegHeader: Record "Seminar Registration Header"; xSeminarRegHeader: Record "Seminar Registration Header"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var SeminarRegHeader: Record "Seminar Registration Header"; xSeminarRegHeader: Record "Seminar Registration Header"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateDim(var SeminarRegHeader: Record "Seminar Registration Header"; var IsHandled: Boolean; var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateDimOnBeforeUpdateLines(var SeminarRegHeader: Record "Seminar Registration Header"; xSeminarRegHeader: Record "Seminar Registration Header"; CurrentFieldNo: Integer; OldDimSetID: Integer; DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateDimOnBeforeModify(var SeminarRegHeader: Record "Seminar Registration Header"; xSeminarRegHeader: Record "Seminar Registration Header"; FieldNo: Integer; OldDimSetID: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateAllLineDim(var SeminarRegHeader: Record "Seminar Registration Header"; NewParentDimSetID: Integer; OldParentDimSetID: Integer; var IsHandled: Boolean; xSeminarRegHeader: Record "Seminar Registration Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateAllLineDimOnBeforeGetSeminarRegLineNewDimSetID(var SeminarRegLine: Record "Seminar Registration Line"; NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateAllLineDimOnAfterGetSeminarRegLineNewDimsetID(SeminarRegHeader: Record "Seminar Registration Header"; xSeminarRegHeader: Record "Seminar Registration Header"; SeminarRegLine: Record "Seminar Registration Line"; var NewDimSetID: Integer; NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateAllLineDimOnBeforeSeminarRegLineModify(var SeminarRegLine: Record "Seminar Registration Line"; xSeminarRegLine: Record "Seminar Registration Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateAllLineDimOnAfterSeminarRegLineModify(var SeminarRegLine: Record "Seminar Registration Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmUpdateAllLineDim(var SeminarRegHeader: Record "Seminar Registration Header"; var xSeminarRegHeader: Record "Seminar Registration Header"; NewParentDimSetID: Integer; OldParentDimSetID: Integer; var Confirmed: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowDocDim(var SeminarRegHeader: Record "Seminar Registration Header"; xSeminarRegHeader: Record "Seminar Registration Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnShowDocDimOnBeforeUpdateSeminarRegLines(var SeminarRegHeader: Record "Seminar Registration Header"; xSeminarRegHeader: Record "Seminar Registration Header")
    begin
    end;

#if not CLEAN20
    [Obsolete('Replaced by OnAfterInitDefaultDimensionSources() event', '20.0')]
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDimTableIDs(var SeminarRegHeader: Record "Seminar Registration Header"; CallingFieldNo: Integer; var TableID: array[10] of Integer; var No: array[10] of Code[20])
    begin
    end;

    [Obsolete('Temporary event for compatibility', '20.0')]
    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunEventOnAfterCreateDimTableIDs(var SeminarRegHeader: Record "Seminar Registration Header"; var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; var IsHandled: Boolean)
    begin
    end;

#endif
}