namespace DEF.FieldService.WorkOrders;

using Microsoft.Projects.Resources.Resource;

/// <summary>
/// Knows which resource a user works as and limits work orders to the ones assigned to that technician.
/// </summary>
codeunit 50132 "DEF FS Technician Mgt"
{
    var
        UserAlreadyLinkedErr: Label 'User %1 is already linked to resource %2. A user can only work as one technician.', Comment = '%1 = user name, %2 = resource number';
        NotLinkedToResourceMsg: Label 'Your user is not linked to a resource, so all work orders are shown. Enter your user in the Field Service User ID field on your resource card to see only your own work orders.';

    /// <summary>
    /// Returns the resource that the user works as, or an empty code if the user is not linked to a resource.
    /// </summary>
    procedure GetResourceNoForUser(UserName: Code[50]): Code[20]
    var
        Resource: Record Resource;
    begin
        if UserName = '' then
            exit('');

        Resource.SetCurrentKey("DEF FS User ID");
        Resource.SetRange("DEF FS User ID", UserName);
        Resource.SetLoadFields("No.");
        if Resource.FindFirst() then
            exit(Resource."No.");
        exit('');
    end;

    procedure GetResourceNoForCurrentUser(): Code[20]
    begin
        exit(GetResourceNoForUser(CopyStr(UserId(), 1, 50)));
    end;

    /// <summary>
    /// Shows only the work orders assigned to the current user's resource. The filter is set in a hidden filter group,
    /// so the technician cannot remove it. Returns false and leaves the records unfiltered if the user is not linked to a resource.
    /// </summary>
    procedure FilterOnCurrentTechnician(var WorkOrderHeader: Record "DEF FS Work Order Header"): Boolean
    begin
        exit(FilterOnTechnician(WorkOrderHeader, GetResourceNoForCurrentUser()));
    end;

    procedure FilterOnTechnician(var WorkOrderHeader: Record "DEF FS Work Order Header"; ResourceNo: Code[20]): Boolean
    begin
        if ResourceNo = '' then
            exit(false);

        WorkOrderHeader.FilterGroup(2);
        WorkOrderHeader.SetRange("Assigned Resource No.", ResourceNo);
        WorkOrderHeader.FilterGroup(0);
        exit(true);
    end;

    /// <summary>
    /// Tells the user that all work orders are shown because their user is not linked to a resource.
    /// </summary>
    procedure SendNotLinkedNotification()
    var
        NotLinkedNotification: Notification;
    begin
        NotLinkedNotification.Message(NotLinkedToResourceMsg);
        NotLinkedNotification.Scope := NotificationScope::LocalScope;
        NotLinkedNotification.Send();
    end;

    procedure CheckUserNotLinkedToOtherResource(ResourceNo: Code[20]; UserName: Code[50])
    var
        Resource: Record Resource;
    begin
        if UserName = '' then
            exit;

        Resource.SetCurrentKey("DEF FS User ID");
        Resource.SetRange("DEF FS User ID", UserName);
        Resource.SetFilter("No.", '<>%1', ResourceNo);
        Resource.SetLoadFields("No.");
        if Resource.FindFirst() then
            Error(UserAlreadyLinkedErr, UserName, Resource."No.");
    end;
}
