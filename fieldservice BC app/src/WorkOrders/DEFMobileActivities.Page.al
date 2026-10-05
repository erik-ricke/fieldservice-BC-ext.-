namespace DEF.FieldService.WorkOrders;

page 50108 "DEF FS Mobile Activities"
{
    Caption = 'Open Orders';
    PageType = CardPart;
    SourceTable = "DEF FS Mobile Cue";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            cuegroup(OpenOrders)
            {
                CueGroupLayout = Wide;

                field("Open Orders"; Rec."Open Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the number of open field service orders.';

                    trigger OnDrillDown()
                    var
                        WorkOrderHeader: Record "DEF FS Work Order Header";
                    begin
                        WorkOrderHeader.SetFilter(Status, '%1|%2|%3|%4', "DEF FS Order Status"::Open, "DEF FS Order Status"::Traveling, "DEF FS Order Status"::Paused, "DEF FS Order Status"::"In Progress");
                        Page.Run(Page::"DEF FS Mobile Order List", WorkOrderHeader);
                    end;
                }
            }
        }
    }
}