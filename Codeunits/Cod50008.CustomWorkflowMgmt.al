/// <summary>
/// Codeunit Custom Workflow Mgmt. (ID 50008).
/// </summary>
codeunit 50008 "Custom Workflow Mgmt."
{
    trigger OnRun()
    begin
    end;

    var
        WorkflowMgt: Codeunit "Workflow Management";

        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVAL';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of %1 is canceled.';

    procedure CheckApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowMgt.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure GetWorkflowCode(WorkflowCode: code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkflowCode, RecRef.Name), '=', ' '));
    end;

    // Add events to the library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.Open(Database::"Seminar Registration Header");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Seminar Registration Header",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Seminar Registration Header",
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);
    end;
    // subscribe

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Workflow Mgmt.", 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Workflow Mgmt.", 'OnCancelWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    // handle the document;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        SeminarRegHeader: Record "Seminar Registration Header";
    begin
        case RecRef.Number of
            Database::"Seminar Registration Header":
                begin
                    RecRef.SetTable(SeminarRegHeader);
                    SeminarRegHeader.Validate("Approval Status", SeminarRegHeader."Approval Status"::Open);
                    SeminarRegHeader.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        SeminarRegHeader: Record "Seminar Registration Header";
    begin
        case RecRef.Number of
            Database::"Seminar Registration Header":
                begin
                    RecRef.SetTable(SeminarRegHeader);
                    SeminarRegHeader.Validate("Approval Status", SeminarRegHeader."Approval Status"::"Pending Approval");
                    SeminarRegHeader.Modify(true);
                    Variant := SeminarRegHeader;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        SeminarRegHeader: Record "Seminar Registration Header";
    begin
        case RecRef.Number of
            DataBase::"Seminar Registration Header":
                begin
                    RecRef.SetTable(SeminarRegHeader);
                    ApprovalEntryArgument."Document No." := SeminarRegHeader."No.";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        SeminarRegHeader: Record "Seminar Registration Header";
    begin
        case RecRef.Number of
            DataBase::"Seminar Registration Header":
                begin
                    RecRef.SetTable(SeminarRegHeader);
                    SeminarRegHeader.Validate("Approval Status", SeminarRegHeader."Approval Status"::Released);
                    SeminarRegHeader.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        SeminarRegHeader: Record "Seminar Registration Header";
        v: Codeunit "Record Restriction Mgt.";
    begin
        case ApprovalEntry."Table ID" of
            DataBase::"Seminar Registration Header":
                begin
                    if SeminarRegHeader.Get(ApprovalEntry."Document No.") then begin
                        SeminarRegHeader.Validate("Approval Status", SeminarRegHeader."Approval Status"::Open);
                        SeminarRegHeader.Modify(true);
                    end;
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;
}