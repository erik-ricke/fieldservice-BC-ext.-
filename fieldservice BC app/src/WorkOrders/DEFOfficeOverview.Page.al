namespace DEF.FieldService.WorkOrders;

page 50121 "DEF FS Office Overview"
{
    Caption = 'Office Work Orders';
    PageType = List;
    SourceTable = "DEF FS Work Order Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "DEF FS Mobile Order Card";
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work order number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short description of the work order.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer for this work order.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service address.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work order priority.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the work order.';
                }
            }

            part(PurchaseLines; "DEF FS Line Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                SubPageView = WHERE("Needs Purchasing" = CONST(true));
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenCard)
            {
                Caption = 'Open Work Order';
                ApplicationArea = All;
                Image = Document;
                RunObject = page "DEF FS Mobile Order Card";
                RunPageLink = "No." = FIELD("No.");
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
        }
    }
}
