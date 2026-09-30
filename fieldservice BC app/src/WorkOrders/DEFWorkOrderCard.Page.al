namespace DEF.FieldService.WorkOrders;

page 50103 "DEF Work Order Card"
{
    Caption = 'Field Service Work Order';
    PageType = Card;
    SourceTable = "DEF Work Order";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current processing status of this work order.';
                }
                field("Work Date"; Rec."Work Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date planned for the service work.';
                }
            }
            group(Customer)
            {
                Caption = 'Customer';

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer responsible for this work order.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the customer name associated with this work order.';
                }
            }
            group(ServiceLocation)
            {
                Caption = 'Service Location';

                field("Service Address"; Rec."Service Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the street address where the service work is performed.';
                }
                field("Service City"; Rec."Service City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city where the service work is performed.';
                }
                field("Service Post Code"; Rec."Service Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code for the service location.';
                }
            }
        }
    }
}