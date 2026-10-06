namespace DEF.FieldService.WorkOrders;

using Microsoft.Foundation.Attachment;

page 50103 "DEF FS Mobile Order Card"
{
    Caption = 'Field Service Work Order';
    PageType = Document;
    SourceTable = "DEF FS Work Order Header";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(WorkOrder)
            {
                Caption = 'Work Order';

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
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer associated with this work order.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of this work order.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current processing status of this work order.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service address for this work order.';
                }
                field("Planned Date"; Rec."Planned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the day the job is planned for.';
                }
                field("Planned Start Time"; Rec."Planned Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time the job is planned to start.';
                }
                field("Estimated Duration"; Rec."Estimated Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how long the job is expected to take on site.';
                }
                field("Completion Note"; Rec."Completion Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the note that was entered when the job was completed, failed or paused.';
                }
                field("No. of Photos"; Rec."No. of Photos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many photos are attached to the work order. Open the Photos and Attachments factbox to view them.';
                }
            }
            part(Lines; "DEF FS Line Subform")
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(Attachments; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Photos and Attachments';
                SubPageLink = "Table ID" = const(50100), "No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Traveling)
            {
                ApplicationArea = All;
                Caption = 'Travel';
                Image = MoveUp;
                Enabled = CanTravel;
                ToolTip = 'Marks this work order as currently traveling to the customer.';

                trigger OnAction()
                begin
                    StatusMgt.SetStatus(Rec, Rec.Status::Traveling);
                    CurrPage.Update(false);
                end;
            }
            action(StartJob)
            {
                ApplicationArea = All;
                Caption = 'Start Job';
                Image = Start;
                Enabled = CanStart;
                ToolTip = 'Starts this work order.';

                trigger OnAction()
                begin
                    StatusMgt.SetStatus(Rec, Rec.Status::"In Progress");
                    CurrPage.Update(false);
                end;
            }
            action("Pause/Stop")
            {
                ApplicationArea = All;
                Caption = 'Pause';
                Image = Pause;
                Enabled = CanPause;
                ToolTip = 'Pauses this work order.';

                trigger OnAction()
                begin
                    StatusMgt.SetStatus(Rec, Rec.Status::Paused);
                    CurrPage.Update(false);
                end;
            }
            action(AddSparePart)
            {
                ApplicationArea = All;
                Caption = 'Add Material';
                Image = Item;
                Enabled = CanAddMaterial;
                ToolTip = 'Adds an item that was used for this work order.';

                trigger OnAction()
                var
                    WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
                begin
                    WorkOrderItemMgt.AddItemToWorkOrder(Rec."No.");
                    CurrPage.Update(false);
                end;
            }
            action(TakePhoto)
            {
                ApplicationArea = All;
                Caption = 'Take Photo';
                Image = Camera;
                Enabled = CanAddMaterial;
                ToolTip = 'Takes a photo with the camera of your device and attaches it to this work order. Without a camera, you can upload an image file.';

                trigger OnAction()
                var
                    PhotoMgt: Codeunit "DEF FS Photo Mgt";
                begin
                    PhotoMgt.TakePhoto(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CompleteJob)
            {
                ApplicationArea = All;
                Caption = 'Complete Job';
                Image = Completed;
                Enabled = CanComplete;
                ToolTip = 'Completes this work order, marks it as failed, or pauses it.';

                trigger OnAction()
                begin
                    StatusMgt.CompleteWithDialog(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(StatusHistory)
            {
                ApplicationArea = All;
                Caption = 'Status History';
                Image = History;
                RunObject = page "DEF FS Status Log Entries";
                RunPageLink = "Work Order No." = field("No.");
                ToolTip = 'Opens the status changes of this work order.';
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(TravelingPromoted; Traveling)
                {
                }
                actionref(StartPromoted; StartJob)
                {
                }
                actionref(StopPromoted; "Pause/Stop")
                {
                }
                actionref(AddSparePartPromoted; AddSparePart)
                {
                }
                actionref(TakePhotoPromoted; TakePhoto)
                {
                }
                actionref(CompleteJobPromoted; CompleteJob)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CanTravel := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Traveling);
        CanStart := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::"In Progress");
        CanPause := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Paused);
        CanComplete := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Done);
        CanAddMaterial := not (Rec.Status in [Rec.Status::Done, Rec.Status::Failed]);
    end;

    var
        StatusMgt: Codeunit "DEF FS Status Mgt";
        CanTravel: Boolean;
        CanStart: Boolean;
        CanPause: Boolean;
        CanComplete: Boolean;
        CanAddMaterial: Boolean;
}
