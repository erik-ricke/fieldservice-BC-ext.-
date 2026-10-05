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
                field("Due Today"; Rec."Due Today")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of active work orders that are planned for today.';
                }
                field(Overdue; Rec.Overdue)
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = Rec.Overdue > 0;
                    ToolTip = 'Specifies the number of active work orders whose planned date is in the past.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        TechnicianMgt: Codeunit "DEF FS Technician Mgt";
    begin
        Rec.GetOrCreate();
        Rec.SetCueFilters(TechnicianMgt.GetResourceNoForCurrentUser(), Today());
    end;
}
