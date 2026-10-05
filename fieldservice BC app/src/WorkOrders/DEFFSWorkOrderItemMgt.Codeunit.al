namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;

codeunit 50116 "DEF FS Work Order Item Mgt"
{
    var
        QuantityMustBePositiveErr: Label 'The quantity must be greater than 0.';
        WorkOrderClosedErr: Label 'You cannot add material to work order %1 because its status is %2.', Comment = '%1 = work order number, %2 = status';

    /// <summary>
    /// Asks the technician which item was used and adds it as a new line to the work order.
    /// </summary>
    procedure AddItemToWorkOrder(WorkOrderNo: Code[20])
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        ItemAddDialog: Page "DEF FS Item Add Dialog";
    begin
        WorkOrderHeader.Get(WorkOrderNo);
        CheckCanAddMaterial(WorkOrderHeader);

        if ItemAddDialog.RunModal() <> Action::OK then
            exit;

        if ItemAddDialog.GetItemNo() = '' then
            exit;

        InsertItemLine(WorkOrderHeader."No.", ItemAddDialog.GetItemNo(), ItemAddDialog.GetQuantity(), ItemAddDialog.GetNeedsPurchasing(), ItemAddDialog.GetItemNote());
    end;

    procedure InsertItemLine(WorkOrderNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal; NeedsPurchasing: Boolean; ItemNote: Text[250])
    var
        Item: Record Item;
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        if Quantity <= 0 then
            Error(QuantityMustBePositiveErr);
        Item.Get(ItemNo);

        WorkOrderLine.Init();
        WorkOrderLine."Document No." := WorkOrderNo;
        WorkOrderLine."Line No." := GetNextLineNo(WorkOrderNo);
        WorkOrderLine.Validate(Type, WorkOrderLine.Type::Item);
        WorkOrderLine.Validate("No.", Item."No.");
        WorkOrderLine.Validate(Quantity, Quantity);
        WorkOrderLine."Needs Purchasing" := NeedsPurchasing;
        WorkOrderLine."Item Note" := ItemNote;
        WorkOrderLine.Insert(true);
    end;

    procedure CheckCanAddMaterial(WorkOrderHeader: Record "DEF FS Work Order Header")
    begin
        if WorkOrderHeader.Status in [WorkOrderHeader.Status::Done, WorkOrderHeader.Status::Failed] then
            Error(WorkOrderClosedErr, WorkOrderHeader."No.", WorkOrderHeader.Status);
    end;

    local procedure GetNextLineNo(WorkOrderNo: Code[20]): Integer
    var
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        WorkOrderLine.SetRange("Document No.", WorkOrderNo);
        if WorkOrderLine.FindLast() then
            exit(WorkOrderLine."Line No." + 10000);
        exit(10000);
    end;
}
