namespace DEF.FieldService.WorkOrders;

using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Customer;

table 50100 "DEF FS Work Order Header"
{
    Caption = 'Field Service Work Order';
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", "Customer Name";
    DrillDownPageId = "DEF FS Mobile Order List";
    LookupPageId = "DEF FS Mobile Order List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if Rec."No." = xRec."No." then
                    exit;

                FSSetup.GetRecordOnce();
                NoSeries.TestManual(FSSetup."Work Order Nos.");
                Rec."No. Series" := '';
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer';
            DataClassification = CustomerContent;
        }
        field(4; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(5; Priority; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(6; Status; Enum "DEF FS Order Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Demo Data"; Boolean)
        {
            Caption = 'Demo Data';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = SystemMetadata;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(9; "Completion Note"; Text[250])
        {
            Caption = 'Completion Note';
            DataClassification = CustomerContent;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Rec."Customer No." = '' then
                    exit;

                Customer.Get(Rec."Customer No.");
                Rec."Customer Name" := Customer.Name;
                Rec.Address := CopyStr(FormatCustomerAddress(Customer), 1, MaxStrLen(Rec.Address));
            end;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(PriorityStatus; Priority, Status)
        {
        }
    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if Rec."No." <> '' then
            exit;

        FSSetup.GetRecordOnce();
        FSSetup.TestField("Work Order Nos.");
        Rec."No. Series" := FSSetup."Work Order Nos.";
        Rec."No." := NoSeries.GetNextNo(Rec."No. Series");
    end;

    trigger OnDelete()
    var
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        WorkOrderLine.SetRange("Document No.", Rec."No.");
        if not WorkOrderLine.IsEmpty() then
            WorkOrderLine.DeleteAll(true);
    end;

    var
        FSSetup: Record "DEF FS Setup";
        AddressWithCityTok: Label '%1, %2 %3', Locked = true, Comment = '%1 = street address, %2 = post code, %3 = city';

    /// <summary>
    /// Lets the user pick a related number series for a new work order and assigns the next number from it.
    /// </summary>
    procedure AssistEdit(OldWorkOrderHeader: Record "DEF FS Work Order Header"): Boolean
    var
        NoSeries: Codeunit "No. Series";
    begin
        FSSetup.GetRecordOnce();
        FSSetup.TestField("Work Order Nos.");
        if not NoSeries.LookupRelatedNoSeries(FSSetup."Work Order Nos.", OldWorkOrderHeader."No. Series", Rec."No. Series") then
            exit(false);

        Rec."No." := NoSeries.GetNextNo(Rec."No. Series");
        exit(true);
    end;

    local procedure FormatCustomerAddress(Customer: Record Customer): Text
    begin
        if Customer.City = '' then
            exit(Customer.Address);
        if Customer.Address = '' then
            exit(Customer.City);
        exit(StrSubstNo(AddressWithCityTok, Customer.Address, Customer."Post Code", Customer.City).Replace('  ', ' '));
    end;
}
