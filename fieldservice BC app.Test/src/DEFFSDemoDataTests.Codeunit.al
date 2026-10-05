namespace DEF.FieldService.Test;

using DEF.FieldService.WorkOrders;
using Microsoft.Inventory.Item;

codeunit 50192 "DEF FS Demo Data Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        TestLibrary: Codeunit "DEF FS Test Library";
        DemoDataMgt: Codeunit "DEF FS Demo Data Mgt";

    [Test]
    procedure DeleteDemoData_RealAndDemoOrders_KeepsRealOrders()
    var
        DemoWorkOrder: Record "DEF FS Work Order Header";
        RealWorkOrder: Record "DEF FS Work Order Header";
    begin
        RealWorkOrder := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        TestLibrary.CreateWorkOrderLine(RealWorkOrder."No.", 10000);
        DemoWorkOrder := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, true);

        DemoDataMgt.DeleteDemoData();

        TestLibrary.IsTrue(WorkOrderExists(RealWorkOrder."No."), 'Real work order must be kept');
        TestLibrary.IsFalse(WorkOrderExists(DemoWorkOrder."No."), 'Demo work order must be deleted');
    end;

    [Test]
    procedure CreateDemoData_MissingItem_CreatesAndLaterRemovesItem()
    var
        DemoRecord: Record "DEF FS Demo Record";
        Item: Record Item;
        WorkOrderHeader: Record "DEF FS Work Order Header";
        WorkOrderNo: Code[20];
        ItemNo: Code[20];
    begin
        TestLibrary.UseNewWorkOrderNoSeries('TWO-0001');
        WorkOrderNo := TestLibrary.UniqueCode();
        ItemNo := TestLibrary.UniqueCode();
        ReplaceDemoSetup(WorkOrderNo, "DEF FS Line Type"::Item, ItemNo);

        TestLibrary.AreEqual(1, DemoDataMgt.CreateDemoData(), 'Created work orders');

        WorkOrderHeader.Get(WorkOrderNo);
        TestLibrary.IsTrue(WorkOrderHeader."Demo Data", 'Work order is flagged as demo data');
        TestLibrary.IsTrue(Item.Get(ItemNo), 'Missing item is created');
        TestLibrary.IsTrue(DemoRecord.Get(Database::Item, ItemNo), 'Created item is remembered');

        DemoDataMgt.DeleteDemoData();

        TestLibrary.IsFalse(Item.Get(ItemNo), 'Demo item is deleted');
        TestLibrary.IsFalse(DemoRecord.Get(Database::Item, ItemNo), 'Demo record log is cleaned up');
    end;

    [Test]
    procedure DeleteDemoData_PreexistingItem_KeepsItem()
    var
        Item: Record Item;
        ItemNo: Code[20];
    begin
        TestLibrary.UseNewWorkOrderNoSeries('TWO-0001');
        ItemNo := TestLibrary.UniqueCode();
        Item.Init();
        Item."No." := ItemNo;
        Item.Insert(false);
        ReplaceDemoSetup(TestLibrary.UniqueCode(), "DEF FS Line Type"::Item, ItemNo);

        DemoDataMgt.CreateDemoData();
        DemoDataMgt.DeleteDemoData();

        TestLibrary.IsTrue(Item.Get(ItemNo), 'An item that existed before must be kept');
    end;

    [Test]
    procedure CreateDemoData_RealOrderWithSameNo_LeavesOrderUnchanged()
    var
        RealWorkOrder: Record "DEF FS Work Order Header";
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        RealWorkOrder := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        ReplaceDemoSetup(RealWorkOrder."No.", "DEF FS Line Type"::Item, TestLibrary.UniqueCode());

        TestLibrary.AreEqual(0, DemoDataMgt.CreateDemoData(), 'Created work orders');

        RealWorkOrder.Get(RealWorkOrder."No.");
        TestLibrary.IsFalse(RealWorkOrder."Demo Data", 'Real work order must not become demo data');
        WorkOrderLine.SetRange("Document No.", RealWorkOrder."No.");
        TestLibrary.IsTrue(WorkOrderLine.IsEmpty(), 'No demo lines are added to a real work order');
    end;

    [Test]
    procedure LoadDefaultSetupRows_CalledTwice_AddsRowsOnce()
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        DemoSetup.DeleteAll();

        TestLibrary.IsTrue(DemoDataMgt.LoadDefaultSetupRows() > 0, 'Default rows are loaded');
        TestLibrary.AreEqual(0, DemoDataMgt.LoadDefaultSetupRows(), 'Existing rows are not loaded twice');
    end;

    local procedure WorkOrderExists(WorkOrderNo: Code[20]): Boolean
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader.SetRange("No.", WorkOrderNo);
        exit(not WorkOrderHeader.IsEmpty());
    end;

    local procedure ReplaceDemoSetup(WorkOrderNo: Code[20]; LineType: Enum "DEF FS Line Type"; No: Code[20])
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        DemoSetup.DeleteAll();
        DemoSetup.Init();
        DemoSetup."Work Order No." := WorkOrderNo;
        DemoSetup."Line No." := 10000;
        DemoSetup.Description := 'Test order';
        DemoSetup."Line Type" := LineType;
        DemoSetup."Item or Resource No." := No;
        DemoSetup."Line Description" := 'Test line';
        DemoSetup.Quantity := 1;
        DemoSetup.Insert();
    end;
}
