namespace DEF.FieldService.WorkOrders;

page 50106 "DEF FS Line Subform"
{
    Caption = 'Work Order Lines';
    PageType = ListPart;
    SourceTable = "DEF FS Work Order Line";
    ApplicationArea = All;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this line uses an item or a resource.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item or resource number for this line.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work or material description for this line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity required for this line.';
                }
                field("Item Note"; Rec."Item Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any note for this item line.';
                }
                field("Needs Purchasing"; Rec."Needs Purchasing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this item needs to be purchased.';
                }
            }
        }
    }
}
