/// <summary>
/// Codeunit Seminar Reg.-Show Ledger (ID 50004).
/// </summary>
codeunit 50004 "Seminar Reg.-Show Ledger"
{
    TableNo = "Seminar Register";

    trigger OnRun()
    begin
        SeminarLedgerEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        PAGE.Run(PAGE::"Seminar Ledger Entries", SeminarLedgerEntry);
    end;

    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry";
}
