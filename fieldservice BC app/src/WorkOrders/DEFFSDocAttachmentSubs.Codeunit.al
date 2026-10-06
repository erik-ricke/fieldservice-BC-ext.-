namespace DEF.FieldService.WorkOrders;

using Microsoft.Foundation.Attachment;

/// <summary>
/// Makes the standard document attachments (factbox, upload, preview) work for field service work orders.
/// </summary>
codeunit 50137 "DEF FS Doc. Attachment Subs"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterTableHasNumberFieldPrimaryKey, '', false, false)]
    local procedure HandleOnAfterTableHasNumberFieldPrimaryKey(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    begin
        if TableNo <> Database::"DEF FS Work Order Header" then
            exit;

        Result := true;
        FieldNo := GetWorkOrderNoFieldNo();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnAfterInitFieldsFromRecRef, '', false, false)]
    local procedure HandleOnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
        if RecRef.Number <> Database::"DEF FS Work Order Header" then
            exit;

        DocumentAttachment."No." := RecRef.Field(GetWorkOrderNoFieldNo()).Value();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterGetRefTable, '', false, false)]
    local procedure HandleOnAfterGetRefTable(var RecRef: RecordRef; DocumentAttachment: Record "Document Attachment")
    begin
        OpenWorkOrderRecRef(RecRef, DocumentAttachment);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Doc. Attachment List Factbox", OnAfterGetRecRefFail, '', false, false)]
    local procedure HandleOnAfterGetRecRefFail(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
        OpenWorkOrderRecRef(RecRef, DocumentAttachment);
    end;

    local procedure OpenWorkOrderRecRef(var RecRef: RecordRef; DocumentAttachment: Record "Document Attachment")
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        if DocumentAttachment."Table ID" <> Database::"DEF FS Work Order Header" then
            exit;

        if WorkOrderHeader.Get(DocumentAttachment."No.") then
            RecRef.GetTable(WorkOrderHeader);
    end;

    local procedure GetWorkOrderNoFieldNo(): Integer
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        exit(WorkOrderHeader.FieldNo("No."));
    end;
}
