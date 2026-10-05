namespace DEF.FieldService.Test;

using DEF.FieldService.WorkOrders;
using Microsoft.Projects.Resources.Resource;

codeunit 50194 "DEF FS Technician Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        TestLibrary: Codeunit "DEF FS Test Library";
        TechnicianMgt: Codeunit "DEF FS Technician Mgt";

    [Test]
    procedure GetResourceNoForUser_LinkedUser_ReturnsResource()
    var
        ResourceNo: Code[20];
        UserName: Code[50];
    begin
        UserName := TestLibrary.UniqueCode();
        ResourceNo := TestLibrary.CreateTechnician(UserName);

        TestLibrary.AreEqual(ResourceNo, TechnicianMgt.GetResourceNoForUser(UserName), 'Resource of the user');
    end;

    [Test]
    procedure GetResourceNoForUser_UnknownUser_ReturnsEmpty()
    begin
        TestLibrary.AreEqual('', TechnicianMgt.GetResourceNoForUser(TestLibrary.UniqueCode()), 'Unknown user');
        TestLibrary.AreEqual('', TechnicianMgt.GetResourceNoForUser(''), 'Empty user');
    end;

    [Test]
    procedure ValidateUserID_UserLinkedToOtherResource_ThrowsError()
    var
        Resource: Record Resource;
        UserName: Code[50];
    begin
        UserName := TestLibrary.UniqueCode();
        TestLibrary.CreateTechnician(UserName);
        Resource.Get(TestLibrary.CreateTechnician(''));

        asserterror Resource.Validate("DEF FS User ID", UserName);

        TestLibrary.ExpectedError('is already linked to resource');
    end;

    [Test]
    procedure FilterOnTechnician_WithResource_ShowsOnlyAssignedOrders()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        OwnWorkOrder: Record "DEF FS Work Order Header";
        ResourceNo: Code[20];
    begin
        ResourceNo := TestLibrary.CreateTechnician(TestLibrary.UniqueCode());
        OwnWorkOrder := TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::Open, 0D);
        TestLibrary.CreateAssignedWorkOrder(TestLibrary.CreateTechnician(TestLibrary.UniqueCode()), "DEF FS Order Status"::Open, 0D);
        TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);

        TestLibrary.IsTrue(TechnicianMgt.FilterOnTechnician(WorkOrderHeader, ResourceNo), 'Filter must be applied');

        TestLibrary.AreEqual(1, WorkOrderHeader.Count(), 'Only the own work order is visible');
        WorkOrderHeader.FindFirst();
        TestLibrary.AreEqual(OwnWorkOrder."No.", WorkOrderHeader."No.", 'Own work order');
    end;

    [Test]
    procedure FilterOnTechnician_NoResource_ReturnsFalseWithoutFilter()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        TestLibrary.IsFalse(TechnicianMgt.FilterOnTechnician(WorkOrderHeader, ''), 'No filter without a resource');

        WorkOrderHeader.FilterGroup(2);
        TestLibrary.AreEqual('', WorkOrderHeader.GetFilter("Assigned Resource No."), 'Technician filter');
    end;

    [Test]
    procedure ValidateAssignedResource_DoneOrder_ThrowsError()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Done, false);

        asserterror WorkOrderHeader.Validate("Assigned Resource No.", TestLibrary.CreateTechnician(TestLibrary.UniqueCode()));

        TestLibrary.ExpectedError('because the job is done');
    end;

    [Test]
    procedure MobileCue_TechnicianFilter_CountsDueTodayAndOverdue()
    var
        MobileCue: Record "DEF FS Mobile Cue";
        ReferenceDate: Date;
        ResourceNo: Code[20];
    begin
        ReferenceDate := DMY2Date(15, 6, 2026);
        ResourceNo := TestLibrary.CreateTechnician(TestLibrary.UniqueCode());
        TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::Open, ReferenceDate);
        TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::"In Progress", ReferenceDate);
        TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::Done, ReferenceDate);
        TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::Paused, ReferenceDate - 3);
        TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::Failed, ReferenceDate - 3);
        TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::Open, ReferenceDate + 1);
        TestLibrary.CreateAssignedWorkOrder(ResourceNo, "DEF FS Order Status"::Open, 0D);
        TestLibrary.CreateAssignedWorkOrder(TestLibrary.CreateTechnician(TestLibrary.UniqueCode()), "DEF FS Order Status"::Open, ReferenceDate);

        MobileCue.GetOrCreate();
        MobileCue.SetCueFilters(ResourceNo, ReferenceDate);
        MobileCue.CalcFields("Open Orders", "Due Today", Overdue);

        TestLibrary.AreEqual(5, MobileCue."Open Orders", 'Active orders of the technician');
        TestLibrary.AreEqual(2, MobileCue."Due Today", 'Due today');
        TestLibrary.AreEqual(1, MobileCue.Overdue, 'Overdue');
    end;
}
