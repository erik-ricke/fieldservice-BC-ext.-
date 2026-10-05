namespace DEF.FieldService.Test;

using DEF.FieldService.WorkOrders;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;

codeunit 50191 "DEF FS Work Order Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        TestLibrary: Codeunit "DEF FS Test Library";

    [Test]
    procedure Insert_BlankNo_UsesNoSeriesPast999()
    var
        FirstWorkOrder: Record "DEF FS Work Order Header";
        SecondWorkOrder: Record "DEF FS Work Order Header";
    begin
        // Numbers past 999 used to be formatted with a thousands separator ("WO-1.000").
        TestLibrary.UseNewWorkOrderNoSeries('TWO-0999');

        FirstWorkOrder.Init();
        FirstWorkOrder.Insert(true);
        SecondWorkOrder.Init();
        SecondWorkOrder.Insert(true);

        TestLibrary.AreEqual('TWO-0999', FirstWorkOrder."No.", 'First number');
        TestLibrary.AreEqual('TWO-1000', SecondWorkOrder."No.", 'Second number');
        TestLibrary.AreEqual(FirstWorkOrder."No. Series", SecondWorkOrder."No. Series", 'No. Series is stored');
    end;

    [Test]
    procedure Delete_OrderWithLines_DeletesLines()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        TestLibrary.CreateWorkOrderLine(WorkOrderHeader."No.", 10000);
        TestLibrary.CreateWorkOrderLine(WorkOrderHeader."No.", 20000);

        WorkOrderHeader.Delete(true);

        WorkOrderLine.SetRange("Document No.", WorkOrderHeader."No.");
        TestLibrary.IsTrue(WorkOrderLine.IsEmpty(), 'Lines must be deleted with their work order');
    end;

    [Test]
    procedure Delete_OrderWithStatusLog_DeletesLogEntries()
    var
        StatusLogEntry: Record "DEF FS Status Log Entry";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        TestLibrary.InsertStatusLogEntry(WorkOrderHeader."No.", "DEF FS Order Status"::Traveling, CurrentDateTime());

        WorkOrderHeader.Delete(true);

        StatusLogEntry.SetRange("Work Order No.", WorkOrderHeader."No.");
        TestLibrary.IsTrue(StatusLogEntry.IsEmpty(), 'Log entries must be deleted with their work order');
    end;

    [Test]
    procedure ValidateCustomerNo_ExistingCustomer_FillsNameAndAddress()
    var
        Customer: Record Customer;
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        Customer.Init();
        Customer."No." := TestLibrary.UniqueCode();
        Customer.Name := 'Test Kunde GmbH';
        Customer.Address := 'Teststraße 1';
        Customer."Post Code" := '49074';
        Customer.City := 'Osnabrück';
        Customer.Insert(false);

        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        WorkOrderHeader.Validate("Customer No.", Customer."No.");

        TestLibrary.AreEqual('Test Kunde GmbH', WorkOrderHeader."Customer Name", 'Customer name');
        TestLibrary.AreEqual('Teststraße 1, 49074 Osnabrück', WorkOrderHeader.Address, 'Address');
    end;

    [Test]
    procedure OpenOrdersCue_MixedStatuses_CountsActiveOnly()
    var
        MobileCue: Record "DEF FS Mobile Cue";
        CountBefore: Integer;
    begin
        MobileCue.GetOrCreate();
        MobileCue.CalcFields("Open Orders");
        CountBefore := MobileCue."Open Orders";

        TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        TestLibrary.CreateWorkOrder("DEF FS Order Status"::Traveling, false);
        TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);
        TestLibrary.CreateWorkOrder("DEF FS Order Status"::Paused, false);
        TestLibrary.CreateWorkOrder("DEF FS Order Status"::Done, false);
        TestLibrary.CreateWorkOrder("DEF FS Order Status"::Failed, false);

        MobileCue.CalcFields("Open Orders");
        TestLibrary.AreEqual(CountBefore + 4, MobileCue."Open Orders", 'Active orders');
    end;

    [Test]
    procedure InsertItemLine_ValidItem_CreatesNumberedLines()
    var
        Item: Record Item;
        WorkOrderHeader: Record "DEF FS Work Order Header";
        WorkOrderLine: Record "DEF FS Work Order Line";
        WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
    begin
        Item.Init();
        Item."No." := TestLibrary.UniqueCode();
        Item.Description := 'Test filter';
        Item.Insert(false);
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);

        WorkOrderItemMgt.InsertItemLine(WorkOrderHeader."No.", Item."No.", 2, true, 'Basement');
        WorkOrderItemMgt.InsertItemLine(WorkOrderHeader."No.", Item."No.", 1, false, '');

        WorkOrderLine.SetRange("Document No.", WorkOrderHeader."No.");
        TestLibrary.AreEqual(2, WorkOrderLine.Count(), 'Number of lines');
        WorkOrderLine.FindFirst();
        TestLibrary.AreEqual(10000, WorkOrderLine."Line No.", 'First line no.');
        TestLibrary.AreEqual('Test filter', WorkOrderLine.Description, 'Description comes from the item');
        TestLibrary.AreEqual(2, WorkOrderLine.Quantity, 'Quantity');
        TestLibrary.IsTrue(WorkOrderLine."Needs Purchasing", 'Needs purchasing');
        WorkOrderLine.FindLast();
        TestLibrary.AreEqual(20000, WorkOrderLine."Line No.", 'Second line no.');
    end;

    [Test]
    procedure InsertItemLine_ZeroQuantity_ThrowsError()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);

        asserterror WorkOrderItemMgt.InsertItemLine(WorkOrderHeader."No.", 'ANY', 0, false, '');

        TestLibrary.ExpectedError('greater than 0');
    end;

    [Test]
    procedure CheckCanAddMaterial_DoneOrder_ThrowsError()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Done, false);

        asserterror WorkOrderItemMgt.CheckCanAddMaterial(WorkOrderHeader);

        TestLibrary.ExpectedError('cannot add material');
    end;
}
