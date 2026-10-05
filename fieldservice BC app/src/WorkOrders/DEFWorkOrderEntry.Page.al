namespace DEF.FieldService.WorkOrders;

page 50118 "DEF FS Work Order Entry"
{
    Caption = 'Field Service Work Orders';
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
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."No." = '' then
            Rec."No." := 'WO-' + Format(GetNextNo());
    end;

    local procedure GetNextNo(): Integer
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        Candidate: Integer;
        HighestNo: Integer;
    begin
        HighestNo := 0;
        if WorkOrderHeader.FindSet() then
            repeat
                if CopyStr(WorkOrderHeader."No.", 1, 3) = 'WO-' then
                    if Evaluate(Candidate, CopyStr(WorkOrderHeader."No.", 4)) then
                        if Candidate > HighestNo then
                            HighestNo := Candidate;
            until WorkOrderHeader.Next() = 0;

        exit(HighestNo + 1);
    end;
}
