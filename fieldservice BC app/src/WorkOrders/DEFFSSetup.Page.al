namespace DEF.FieldService.WorkOrders;

page 50123 "DEF FS Setup"
{
    Caption = 'Field Service Setup';
    PageType = Card;
    SourceTable = "DEF FS Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Work Order Nos."; Rec."Work Order Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series that is used to number new work orders.';
                }
            }
            group(DemoData)
            {
                Caption = 'Demo Data';

                field("Demo Item Template Code"; Rec."Demo Item Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item template that is applied to items created by the demo data tool, for example to set the unit of measure and posting groups.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenDemoSetup)
            {
                ApplicationArea = All;
                Caption = 'Demo Setup';
                Image = Setup;
                RunObject = page "DEF FS Demo Setup";
                ToolTip = 'Opens the rows used to create demo work orders.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}
