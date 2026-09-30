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
}