namespace DEF.FieldService.WorkOrders;

page 50102 "DEF Work Order List"
{
    Caption = 'Field Service Work Orders';
    PageType = List;
    SourceTable = "DEF Work Order";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "DEF Work Order Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work order number used to identify this service visit.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short summary of the requested field service work.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer responsible for this work order.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name associated with this work order.';
                }
                field("Work Date"; Rec."Work Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date planned for the service work.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current processing status of this work order.';
                }
            }
        }
    }
}