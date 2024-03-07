/// <summary>
/// Codeunit Seminar Web Service Ext. (ID 50007).
/// </summary>
codeunit 50007 "Seminar Web Service Ext."
{
    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'You cannot register for this seminar. Maximum number of participants has already been registered.';

    procedure RegisterParticipant(var SemRegHeader: Record "Seminar Registration Header"; CustNo: Code[20]; ContNo: Code[20])

    var
        SemRegLine: Record "Seminar Registration Line";
        LineNo: Integer;

    begin
        LineNo := 10000;
        SemRegLine.LOCKTABLE;
        SemRegLine.SETRANGE("Document No.", SemRegHeader."No.");
        IF SemRegLine.FINDLAST THEN
            LineNo := LineNo + SemRegLine."Line No.";
        SemRegHeader.CALCFIELDS("Registered Participants");
        IF SemRegHeader."Registered Participants" >= SemRegHeader."Maximum Participants" THEN ERROR(Text001);
        SemRegLine.RESET;
        SemRegLine.INIT;
        SemRegLine.VALIDATE("Document No.", SemRegHeader."No.");
        SemRegLine."Line No." := LineNo;
        SemRegLine.VALIDATE("Bill-to Customer No.", CustNo);
        SemRegLine.VALIDATE("Participant Contact No.", ContNo);
        SemRegLine."Registration Date" := TODAY;
        SemRegLine.INSERT(TRUE);
    end;

}