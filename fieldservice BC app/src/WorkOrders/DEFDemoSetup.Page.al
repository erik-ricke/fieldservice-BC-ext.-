namespace DEF.FieldService.WorkOrders;

page 50113 "DEF FS Demo Setup"
{
    Caption = 'Field Service Demo Setup';
    PageType = List;
    SourceTable = "DEF FS Demo Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    PromotedActionCategories = 'New,Process,Report';

    layout
    {
        area(Content)
        {
            repeater(Orders)
            {
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable number for the demo work order.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable description for the demo work order.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable customer name for the demo work order.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable service address for the demo work order.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable priority for the demo work order.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable status for the demo work order.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable line number for the demo work order.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the demo line represents an item or a resource.';
                }
                field("Item or Resource No."; Rec."Item or Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable item or resource number for the demo line.';
                }
                field("Line Description"; Rec."Line Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable description for the demo line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the configurable quantity for the demo line.';
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
            action(CreateDemoOrders)
            {
                Caption = 'Create Demo Orders';
                ApplicationArea = All;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Creates work orders from the configured demo setup rows.';

                trigger OnAction()
                var
                    DemoDataMgt: Codeunit "DEF FS Demo Data Mgt";
                begin
                    if Rec.IsEmpty() then
                        Error(NoDemoSetupErr);

                    DemoDataMgt.CreateFromSetup();
                    Message(DemoDataCreatedMsg);
                end;
            }
        }
    }

    var
        DemoDataCreatedMsg: Label 'Demo work orders were created from setup.', Comment = 'Shown after creating demo work orders from the setup table.';
        NoDemoSetupErr: Label 'Enter at least one demo setup row before creating demo work orders.', Comment = 'Shown when the demo setup table is empty.';
}