namespace DEF.FieldService.WorkOrders;

page 50121 "DEF FS Office Overview"
{
    Caption = 'Office Work Orders';
    PageType = List;
    SourceTable = "DEF FS Work Order Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "DEF FS Work Order Card";
    Editable = false;

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
                field("Assigned Resource No."; Rec."Assigned Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the technician who does the job.';
                }
                field("Planned Date"; Rec."Planned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the day the job is planned for.';
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
                Caption = 'Material to Purchase';
                Editable = false;
                SubPageLink = "Document No." = field("No.");
                SubPageView = where("Needs Purchasing" = const(true));
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenCard)
            {
                ApplicationArea = All;
                Caption = 'Open Work Order';
                Image = Document;
                RunObject = page "DEF FS Work Order Card";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Opens the selected work order.';
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(OpenCardPromoted; OpenCard)
                {
                }
            }
        }
    }
}
