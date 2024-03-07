/// <summary>
/// Codeunit Custom Doc Attachments (ID 50009).
/// </summary>
codeunit 50009 "Custom Doc Attachments"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure SpecifyTheCustomTableOnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        SeminarRegHeader: Record "Seminar Registration Header";
    begin
        case
            DocumentAttachment."Table ID" of
            DATABASE::"Seminar Registration Header":
                begin
                    RecRef.Open(DATABASE::"Seminar Registration Header");
                    if SeminarRegHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(SeminarRegHeader);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure SpecifyTheFieldAssociatedOnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Seminar Registration Header":
                begin
                    FRef := RecRef.Field(1);
                    RecNo := FRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure UpdatePrimaryKeyOnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FRef: FieldRef;
        RecNo: Code[20];
    begin
        if RecRef.Number = DATABASE::"Seminar Registration Header" then begin
            FRef := RecRef.Field(1);
            RecNo := FRef.Value();
            DocumentAttachment.Validate("No.", RecNo);
        end;
    end;
}
