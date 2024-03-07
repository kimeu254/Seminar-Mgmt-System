/// <summary>
/// Codeunit Seminar Jnl.-Check Line (ID 50002).
/// </summary>
codeunit 50002 "Seminar Jnl.-Check Line"
{
    TableNo = "Seminar Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        ErrDateCannotBeClosingDate: Label 'cannot be a closing date';
        DimMgt: Codeunit DimensionManagement;
        Text011: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text012: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        LogErrorMode: Boolean;

    procedure RunCheck(var SemJnlLine: Record "Seminar Journal Line")
    begin
        If SemJnlLine.EmptyLine() then
            exit;

        SemJnlLine.TestField("Posting Date");
        SemJnlLine.TestField("Instructor Resource No.");
        SemJnlLine.TestField("Seminar No.");

        CASE SemJnlLine."Charge Type" OF
            SemJnlLine."Charge Type"::Instructor:
                SemJnlLine.TestField("Instructor Resource No.");
            SemJnlLine."Charge Type"::Room:
                SemJnlLine.TestField("Room Resource No.");
            SemJnlLine."Charge Type"::Participant:
                SemJnlLine.TestField("Participant Contact No.");
        END;

        IF SemJnlLine.Chargeable THEN
            SemJnlLine.TestField("Bill-to Customer No.");

        CheckDates(SemJnlLine);
    end;

    local procedure CheckDates(SemJnlLine: Record "Seminar Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        SemJnlLine.TestField("Posting Date");
        if SemJnlLine."Posting Date" <> NormalDate(SemJnlLine."Posting Date") then
            SemJnlLine.FieldError("Posting Date", ErrDateCannotBeClosingDate);

        UserSetupManagement.CheckAllowedPostingDate(SemJnlLine."Posting Date");

        if SemJnlLine."Document Date" = 0D then
            exit;

        if SemJnlLine."Document Date" <> NormalDate(SemJnlLine."Document Date") then
            SemJnlLine.FieldError("Document Date", ErrDateCannotBeClosingDate);
    end;

    local procedure CheckDimensions(SemJnlLine: Record "Seminar Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        CheckDone: Boolean;
    begin
        OnBeforeCheckDimensions(SemJnlLine, CheckDone);
        if CheckDone then
            exit;

        with SemJnlLine do begin
            if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                ThrowGenJnlLineError(SemJnlLine, Text011, DimMgt.GetDimCombErr());

            TableID[1] := DATABASE::Seminar;
            No[1] := "Seminar No.";
            TableID[2] := DATABASE::Resource;
            No[2] := "Instructor Resource No.";
            TableID[3] := DATABASE::Resource;
            No[3] := "Room Resource No.";

            CheckDone := false;
            OnCheckDimensionsOnAfterAssignDimTableIDs(SemJnlLine, TableID, No, CheckDone);

            if not CheckDone then
                if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                    ThrowGenJnlLineError(SemJnlLine, Text012, DimMgt.GetDimValuePostingErr());
        end;
    end;

    procedure ThrowGenJnlLineError(SemJnlLine: Record "Seminar Journal Line"; ErrorTemplate: Text; ErrorText: Text)
    begin
        if LogErrorMode then
            exit;

        with SemJnlLine do
            if "Line No." <> 0 then
                Error(
                    ErrorInfo.Create(
                        StrSubstNo(
                            ErrorTemplate,
                            TableCaption, "Journal Template Name", "Journal Batch Name", "Line No.",
                            ErrorText),
                        true,
                        SemJnlLine));

        Error(
            ErrorInfo.Create(ErrorText, true, SemJnlLine));
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeCheckDimensions(var SemJnlLine: Record "Seminar Journal Line"; var CheckDone: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnCheckDimensionsOnAfterAssignDimTableIDs(var SemJnlLine: Record "Seminar Journal Line"; var TableID: array[10] of Integer; var No: array[10] of Code[20]; var CheckDone: Boolean)
    begin
    end;
}