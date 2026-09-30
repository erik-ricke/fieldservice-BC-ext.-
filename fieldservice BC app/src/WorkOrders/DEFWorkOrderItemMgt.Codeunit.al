namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;

codeunit 50116 "DEF FS Work Order Item Mgt"
{
    procedure AddItemToWorkOrder(WorkOrderNo: Code[20])
    var
        ItemLookup: Page "DEF FS Add Item Lookup";
        Item: Record Item;
        WorkOrderLine: Record "DEF FS Work Order Line";
        NextLineNo: Integer;
    begin
        ItemLookup.LookupMode(true);
        if ItemLookup.RunModal() <> Action::LookupOK then
            exit;

        ItemLookup.GetRecord(Item);

        WorkOrderLine.SetRange("Document No.", WorkOrderNo);
        if WorkOrderLine.FindLast() then
            NextLineNo := WorkOrderLine."Line No." + 10000
        else
            NextLineNo := 10000;

        WorkOrderLine.Init();
        WorkOrderLine."Document No." := WorkOrderNo;
        WorkOrderLine."Line No." := NextLineNo;
        WorkOrderLine.Type := "DEF FS Line Type"::Item;
        WorkOrderLine."No." := Item."No.";
        WorkOrderLine.Description := Item.Description;
        WorkOrderLine.Quantity := 1;
        WorkOrderLine.Insert(true);
    end;
}