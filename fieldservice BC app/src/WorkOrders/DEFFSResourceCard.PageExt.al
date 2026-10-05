namespace DEF.FieldService.WorkOrders;

using Microsoft.Projects.Resources.Resource;

pageextension 50131 "DEF FS Resource Card" extends "Resource Card"
{
    layout
    {
        addlast(General)
        {
            field("DEF FS User ID"; Rec."DEF FS User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the user who works as this field service technician. The user sees only the work orders that are assigned to this resource.';
            }
        }
    }
}
