/// <summary>
/// TableExtension Default Dimension Extension (ID 50004) extends Record Default Dimension.
/// </summary>
tableextension 50004 "Default Dimension Extension" extends "Default Dimension"
{
    local procedure UpdateSeminarGlobalDimCode(GlobalDimCodeNo: Integer; SeminarNo: Code[20]; NewDimValue: Code[20])
    var
        Seminar: Record Seminar;
    begin
        if Seminar.Get(SeminarNo) then begin
            case GlobalDimCodeNo of
                1:
                    Seminar."Global Dimension 1 Code" := NewDimValue;
                2:
                    Seminar."Global Dimension 2 Code" := NewDimValue;
                else
                    OnUpdateSemGlobalDimCodeOnCaseElse(GlobalDimCodeNo, SeminarNo, NewDimValue);
            end;
            OnUpdateSemGlobalDimCodeOnBeforeCustModify(Seminar, NewDimValue, GlobalDimCodeNo);
            Seminar.Modify(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateSemGlobalDimCodeOnCaseElse(GlobalDimCodeNo: Integer; SeminarNo: Code[20]; NewDimValue: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateSemGlobalDimCodeOnBeforeCustModify(var Sem: Record Seminar; NewDimValue: Code[20]; GlobalDimCodeNo: Integer)
    begin
    end;
}