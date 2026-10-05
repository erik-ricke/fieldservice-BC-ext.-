namespace DEF.FieldService.WorkOrders;

page 50108 "DEF FS Mobile Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "DEF FS Mobile Cue";
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(OpenOrders)
            {
                Caption = 'Work Orders';
                CueGroupLayout = Wide;

                field("Open Orders"; Rec."Open Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of work orders that are open, traveling, in progress or paused.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetOrCreate();
    end;
}
