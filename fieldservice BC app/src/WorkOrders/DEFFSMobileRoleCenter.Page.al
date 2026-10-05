namespace DEF.FieldService.WorkOrders;

page 50109 "DEF FS Mobile Role Center"
{
    Caption = 'Field Service';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Activities; "DEF FS Mobile Activities")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(MyWorkOrders)
            {
                Caption = 'My Work Orders';
                ApplicationArea = All;
                RunObject = page "DEF FS Mobile Order List";
                ToolTip = 'Opens the work orders to travel to, start, pause and complete.';
            }
        }
        area(Sections)
        {
            group(WorkOrders)
            {
                Caption = 'Work Orders';

                action(MobileWorkOrders)
                {
                    Caption = 'My Work Orders';
                    ApplicationArea = All;
                    RunObject = page "DEF FS Mobile Order List";
                    ToolTip = 'Opens the work orders to travel to, start, pause and complete.';
                }
                action(WorkOrderEntry)
                {
                    Caption = 'All Work Orders';
                    ApplicationArea = All;
                    RunObject = page "DEF FS Work Order Entry";
                    ToolTip = 'Opens the list of all work orders to create and edit them.';
                }
                action(OfficeOverview)
                {
                    Caption = 'Office Overview';
                    ApplicationArea = All;
                    RunObject = page "DEF FS Office Overview";
                    ToolTip = 'Opens the office overview with the material that needs to be purchased.';
                }
            }
        }
    }
}
