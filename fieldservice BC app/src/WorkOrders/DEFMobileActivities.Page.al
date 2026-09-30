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
                        WorkOrderHeader.SetRange(Status, "DEF FS Order Status"::Open);
                        Page.Run(Page::"DEF FS Mobile Order List", WorkOrderHeader);
                    end;
                }
            }
        }
    }
}