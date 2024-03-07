/// <summary>
/// Codeunit Seminar Registration-Printed (ID 50006).
/// </summary>
codeunit 50006 "Seminar Registration-Printed"
{
    TableNo = "Seminar Registration Header";
    Permissions = TableData "Seminar Registration Header" = rm;

    trigger OnRun()
    begin
        OnBeforeOnRun(Rec, SuppressCommit);
        Rec.Find();
        Rec."No. Printed" := Rec."No. Printed" + 1;
        OnBeforeModify(Rec);
        Rec.Modify();
        if not SuppressCommit then
            Commit();
        OnAfterOnRun(Rec);
    end;

    var
        SuppressCommit: Boolean;

    procedure SetSuppressCommit(NewSuppressCommit: Boolean)
    begin
        SuppressCommit := NewSuppressCommit;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRun(var SeminarRegHeader: Record "Seminar Registration Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModify(var SeminarRegHeader: Record "Seminar Registration Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRun(var SeminarRegHeader: Record "Seminar Registration Header"; var SuppressCommit: Boolean)
    begin
    end;

}