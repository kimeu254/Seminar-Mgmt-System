/// <summary>
/// Table Seminar Comment Line (ID 50002).
/// </summary>
table 50002 "Seminar Comment Line"
{
    Caption = 'Seminar Comment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Seminar Comment Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
    }
    keys
    {
        key(PK; "Document Type", "No.", "Line No.", "Document Line No.")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// SetUpNewLine.
    /// </summary>
    procedure SetUpNewLine()
    var
        SeminarCommentLine: Record "Seminar Comment Line";
    begin
        SeminarCommentLine.SetRange("Document Type", "Document Type");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.SetRange("Document Line No.", "Document Line No.");
        SeminarCommentLine.SetRange(Date, WorkDate());
        if not SeminarCommentLine.FindFirst() then
            Date := WorkDate();

        OnAfterSetUpNewLine(Rec, SeminarCommentLine);
    end;

    /// <summary>
    /// CopyComments.
    /// </summary>
    /// <param name="FromDocumentType">Integer.</param>
    /// <param name="ToDocumentType">Integer.</param>
    /// <param name="FromNumber">Code[20].</param>
    /// <param name="ToNumber">Code[20].</param>
    procedure CopyComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SeminarCommentLine: Record "Seminar Comment Line";
        SeminarCommentLine2: Record "Seminar Comment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyComments(SeminarCommentLine, ToDocumentType, IsHandled, FromDocumentType, FromNumber, ToNumber);
        if IsHandled then
            exit;

        SeminarCommentLine.SetRange("Document Type", FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet() then
            repeat
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Document Type" := "Seminar Comment Document Type".FromInteger(ToDocumentType);
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.Insert();
            until SeminarCommentLine.Next() = 0;
    end;

    /// <summary>
    /// CopyLineComments.
    /// </summary>
    /// <param name="FromDocumentType">Integer.</param>
    /// <param name="ToDocumentType">Integer.</param>
    /// <param name="FromNumber">Code[20].</param>
    /// <param name="ToNumber">Code[20].</param>
    /// <param name="FromDocumentLineNo">Integer.</param>
    /// <param name="ToDocumentLineNo">Integer.</param>
    procedure CopyLineComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]; FromDocumentLineNo: Integer; ToDocumentLineNo: Integer)
    var
        SeminarCommentLineSource: Record "Seminar Comment Line";
        SeminarCommentLineTarget: Record "Seminar Comment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyLineComments(
          SeminarCommentLineTarget, IsHandled, FromDocumentType, ToDocumentType, FromNumber, ToNumber, FromDocumentLineNo, ToDocumentLineNo);
        if IsHandled then
            exit;

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        SeminarCommentLineSource.SetRange("Document Line No.", FromDocumentLineNo);
        if SeminarCommentLineSource.FindSet() then
            repeat
                SeminarCommentLineTarget := SeminarCommentLineSource;
                SeminarCommentLineTarget."Document Type" := "Seminar Comment Document Type".FromInteger(ToDocumentType);
                SeminarCommentLineTarget."No." := ToNumber;
                SeminarCommentLineTarget."Document Line No." := ToDocumentLineNo;
                SeminarCommentLineTarget.Insert();
            until SeminarCommentLineSource.Next() = 0;
    end;

    /// <summary>
    /// CopyLineCommentsFromSeminarRegLines.
    /// </summary>
    /// <param name="FromDocumentType">Integer.</param>
    /// <param name="ToDocumentType">Integer.</param>
    /// <param name="FromNumber">Code[20].</param>
    /// <param name="ToNumber">Code[20].</param>
    /// <param name="TempSeminarRegLineSource">Temporary VAR Record "Seminar Registration Line".</param>
    procedure CopyLineCommentsFromSeminarRegLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]; var TempSeminarRegLineSource: Record "Seminar Registration Line" temporary)
    var
        SeminarCommentLineSource: Record "Seminar Comment Line";
        SeminarCommentLineTarget: Record "Seminar Comment Line";
        IsHandled: Boolean;
        NextLineNo: Integer;
    begin
        IsHandled := false;
        OnBeforeCopyLineCommentsFromSeminarRegLines(
          SeminarCommentLineTarget, IsHandled, FromDocumentType, ToDocumentType, FromNumber, ToNumber, TempSeminarRegLineSource);
        if IsHandled then
            exit;

        SeminarCommentLineTarget.SetRange("Document Type", ToDocumentType);
        SeminarCommentLineTarget.SetRange("No.", ToNumber);
        SeminarCommentLineTarget.SetRange("Document Line No.", 0);
        if SeminarCommentLineTarget.FindLast() then;
        NextLineNo := SeminarCommentLineTarget."Line No." + 10000;
        SeminarCommentLineTarget.Reset();

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        if TempSeminarRegLineSource.FindSet() then
            repeat
                SeminarCommentLineSource.SetRange("Document Line No.", TempSeminarRegLineSource."Line No.");
                if SeminarCommentLineSource.FindSet() then
                    repeat
                        SeminarCommentLineTarget := SeminarCommentLineSource;
                        SeminarCommentLineTarget."Document Type" := "Seminar Comment Document Type".FromInteger(ToDocumentType);
                        SeminarCommentLineTarget."No." := ToNumber;
                        SeminarCommentLineTarget."Document Line No." := 0;
                        SeminarCommentLineTarget."Line No." := NextLineNo;
                        SeminarCommentLineTarget.Insert();
                        NextLineNo += 10000;
                    until SeminarCommentLineSource.Next() = 0;
            until TempSeminarRegLineSource.Next() = 0;
    end;

    /// <summary>
    /// CopyHeaderComments.
    /// </summary>
    /// <param name="FromDocumentType">Integer.</param>
    /// <param name="ToDocumentType">Integer.</param>
    /// <param name="FromNumber">Code[20].</param>
    /// <param name="ToNumber">Code[20].</param>
    procedure CopyHeaderComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SeminarCommentLineSource: Record "Seminar Comment Line";
        SeminarCommentLineTarget: Record "Seminar Comment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyHeaderComments(SeminarCommentLineTarget, IsHandled, FromDocumentType, ToDocumentType, FromNumber, ToNumber);
        if IsHandled then
            exit;

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        SeminarCommentLineSource.SetRange("Document Line No.", 0);
        if SeminarCommentLineSource.FindSet() then
            repeat
                SeminarCommentLineTarget := SeminarCommentLineSource;
                SeminarCommentLineTarget."Document Type" := "Seminar Comment Document Type".FromInteger(ToDocumentType);
                SeminarCommentLineTarget."No." := ToNumber;
                SeminarCommentLineTarget.Insert();
            until SeminarCommentLineSource.Next() = 0;
    end;

    /// <summary>
    /// DeleteComments.
    /// </summary>
    /// <param name="DocType">Option.</param>
    /// <param name="DocNo">Code[20].</param>
    procedure DeleteComments(DocType: Option; DocNo: Code[20])
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        if not IsEmpty() then
            DeleteAll();
    end;

    procedure ShowComments(DocType: Option; DocNo: Code[20]; DocLineNo: Integer)
    var
        SeminarCommentSheet: Page "Seminar Comment Sheet";
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        SetRange("Document Line No.", DocLineNo);
        Clear(SeminarCommentSheet);
        SeminarCommentSheet.SetTableView(Rec);
        SeminarCommentSheet.RunModal();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetUpNewLine(var SeminarCommentLineRec: Record "Seminar Comment Line"; var SeminarCommentLineFilter: Record "Seminar Comment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyComments(var SeminarCommentLine: Record "Seminar Comment Line"; ToDocumentType: Integer; var IsHandled: Boolean; FromDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyLineComments(var SeminarCommentLine: Record "Seminar Comment Line"; var IsHandled: Boolean; FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]; FromDocumentLineNo: Integer; ToDocumentLine: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyLineCommentsFromSeminarRegLines(var SeminarCommentLine: Record "Seminar Comment Line"; var IsHandled: Boolean; FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]; var TempSeminarRegLineSource: Record "Seminar Registration Line" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyHeaderComments(var SeminarCommentLine: Record "Seminar Comment Line"; var IsHandled: Boolean; FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
    end;
}
