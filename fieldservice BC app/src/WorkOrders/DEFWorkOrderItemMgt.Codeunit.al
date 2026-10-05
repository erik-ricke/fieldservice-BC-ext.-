namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;

codeunit 50116 "DEF FS Work Order Item Mgt"
{
    procedure AddItemToWorkOrder(WorkOrderNo: Code[20])
    var
        ItemDialog: Page "DEF FS Item Add Dialog";
        SelectedItem: Record Item;
        WorkOrderLine: Record "DEF FS Work Order Line";
        NextLineNo: Integer;
    begin
        if ItemDialog.RunModal() <> Action::OK then
            exit;

        if ItemDialog.GetItemNo() = '' then
            exit;

        if not SelectedItem.Get(ItemDialog.GetItemNo()) then
            Error('Das gewählte Item wurde nicht gefunden.');

        WorkOrderLine.SetRange("Document No.", WorkOrderNo);
        if WorkOrderLine.FindLast() then
            NextLineNo := WorkOrderLine."Line No." + 10000
        else
            NextLineNo := 10000;

        WorkOrderLine.Init();
        WorkOrderLine."Document No." := WorkOrderNo;
        WorkOrderLine."Line No." := NextLineNo;
        WorkOrderLine.Type := "DEF FS Line Type"::Item;
        WorkOrderLine."No." := SelectedItem."No.";
        WorkOrderLine.Description := SelectedItem.Description;
        WorkOrderLine.Quantity := ItemDialog.GetQuantity();
        WorkOrderLine."Needs Purchasing" := ItemDialog.GetNeedsPurchasing();
        WorkOrderLine."Item Note" := ItemDialog.GetItemNote();
        WorkOrderLine.Insert(true);
    end;
}