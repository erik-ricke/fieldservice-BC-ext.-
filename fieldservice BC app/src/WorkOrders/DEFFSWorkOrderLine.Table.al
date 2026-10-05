namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;

table 50105 "DEF FS Work Order Line"
{
    Caption = 'Field Service Work Order Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "DEF FS Work Order Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; Type; Enum "DEF FS Line Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec.Type = xRec.Type then
                    exit;

                Rec."No." := '';
                Rec.Description := '';
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = if (Type = const(Item)) Item
            else
            if (Type = const(Resource)) Resource;

            trigger OnValidate()
            begin
                Rec.Description := GetSourceDescription();
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(7; "Needs Purchasing"; Boolean)
        {
            Caption = 'Needs Purchasing';
            DataClassification = CustomerContent;
        }
        field(8; "Item Note"; Text[250])
        {
            Caption = 'Item Note';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    local procedure GetSourceDescription(): Text[100]
    var
        Item: Record Item;
        Resource: Record Resource;
    begin
        if Rec."No." = '' then
            exit('');

        case Rec.Type of
            Rec.Type::Item:
                if Item.Get(Rec."No.") then
                    exit(Item.Description);
            Rec.Type::Resource:
                if Resource.Get(Rec."No.") then
                    exit(Resource.Name);
        end;
        exit(Rec.Description);
    end;
}
