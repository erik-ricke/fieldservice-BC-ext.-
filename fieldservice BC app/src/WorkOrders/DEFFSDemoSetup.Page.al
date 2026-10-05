namespace DEF.FieldService.WorkOrders;

page 50113 "DEF FS Demo Setup"
{
    Caption = 'Field Service Demo Setup';
    PageType = List;
    SourceTable = "DEF FS Demo Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Orders)
            {
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the demo work order.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the demo work order.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name of the demo work order.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service address of the demo work order.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of the demo work order.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status that the demo work order starts with.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number of the demo line. Use several line numbers to create several lines for one work order.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the demo line represents an item or a resource.';
                }
                field("Item or Resource No."; Rec."Item or Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item or resource number of the demo line. Missing items and resources are created as demo records.';
                }
                field("Line Description"; Rec."Line Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the demo line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the demo line.';
                }
                field("Needs Purchasing"; Rec."Needs Purchasing")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the demo line is marked as needing purchasing.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadDefaultRows)
            {
                ApplicationArea = All;
                Caption = 'Load Default Rows';
                Image = Import;
                ToolTip = 'Adds the default demo rows that ship with the app. Rows that already exist are kept.';

                trigger OnAction()
                var
                    DemoDataMgt: Codeunit "DEF FS Demo Data Mgt";
                begin
                    Message(DefaultRowsLoadedMsg, DemoDataMgt.LoadDefaultSetupRows());
                end;
            }
            action(CreateDemoOrders)
            {
                ApplicationArea = All;
                Caption = 'Create Demo Orders';
                Image = CreateDocument;
                ToolTip = 'Creates work orders from the demo setup rows. Missing items and resources are created and remembered as demo data.';

                trigger OnAction()
                var
                    DemoDataMgt: Codeunit "DEF FS Demo Data Mgt";
                begin
                    Message(DemoDataCreatedMsg, DemoDataMgt.CreateDemoData());
                end;
            }
            action(DeleteDemoData)
            {
                ApplicationArea = All;
                Caption = 'Delete Demo Data';
                Image = Delete;
                ToolTip = 'Deletes the demo work orders and the items and resources created for them. Real work orders and the setup rows are kept.';

                trigger OnAction()
                var
                    DemoDataMgt: Codeunit "DEF FS Demo Data Mgt";
                begin
                    if not Confirm(DeleteDemoDataQst, false) then
                        exit;

                    DemoDataMgt.DeleteDemoData();
                    Message(DemoDataDeletedMsg);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(LoadDefaultRowsPromoted; LoadDefaultRows)
                {
                }
                actionref(CreateDemoOrdersPromoted; CreateDemoOrders)
                {
                }
                actionref(DeleteDemoDataPromoted; DeleteDemoData)
                {
                }
            }
        }
    }

    var
        DefaultRowsLoadedMsg: Label '%1 demo rows were added.', Comment = '%1 = number of rows';
        DemoDataCreatedMsg: Label '%1 demo work orders were created.', Comment = '%1 = number of work orders';
        DemoDataDeletedMsg: Label 'The demo data was deleted.';
        DeleteDemoDataQst: Label 'Do you want to delete all demo work orders and the items and resources that were created for them?';
}
