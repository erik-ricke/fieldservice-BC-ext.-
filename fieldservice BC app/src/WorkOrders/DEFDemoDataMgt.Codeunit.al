namespace DEF.FieldService.WorkOrders;

codeunit 50115 "DEF FS Demo Data Mgt"
{
    procedure CreateFromSetup()
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        if not DemoSetup.FindSet() then
            exit;

        repeat
            CreateOrder(DemoSetup);
            CreateLine(DemoSetup);
        until DemoSetup.Next() = 0;
    end;

    local procedure CreateOrder(DemoSetup: Record "DEF FS Demo Setup")
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        if WorkOrderHeader.Get(DemoSetup."Work Order No.") then
            exit;

        WorkOrderHeader.Init();
        WorkOrderHeader."No." := DemoSetup."Work Order No.";
        WorkOrderHeader.Description := DemoSetup.Description;
        WorkOrderHeader."Customer Name" := DemoSetup."Customer Name";
        WorkOrderHeader.Address := DemoSetup.Address;
        WorkOrderHeader.Priority := DemoSetup.Priority;
        WorkOrderHeader.Status := DemoSetup.Status;
        WorkOrderHeader.Insert(false);
    end;

    local procedure CreateLine(DemoSetup: Record "DEF FS Demo Setup")
    var
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        if WorkOrderLine.Get(DemoSetup."Work Order No.", DemoSetup."Line No.") then
            exit;

        WorkOrderLine.Init();
        WorkOrderLine."Document No." := DemoSetup."Work Order No.";
        WorkOrderLine."Line No." := DemoSetup."Line No.";
        WorkOrderLine.Type := DemoSetup."Line Type";
        WorkOrderLine."No." := DemoSetup."Item or Resource No.";
        WorkOrderLine.Description := DemoSetup."Line Description";
        WorkOrderLine.Quantity := DemoSetup.Quantity;
        WorkOrderLine."Needs Purchasing" := DemoSetup."Needs Purchasing";
        WorkOrderLine.Insert(false);
    end;
}