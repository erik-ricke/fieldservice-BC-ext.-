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
        area(Sections)
        {
            group(WorkOrders)
            {
                Caption = 'Work Orders';

                action(WorkOrderEntry)
                {
                    Caption = 'Work Orders';
                    ApplicationArea = All;
                    RunObject = page "DEF FS Work Order Entry";
                }

                action(OfficeOverview)
                {
                    Caption = 'Office Overview';
                    ApplicationArea = All;
                    RunObject = page "DEF FS Office Overview";
                }
            }
        }
    }
}