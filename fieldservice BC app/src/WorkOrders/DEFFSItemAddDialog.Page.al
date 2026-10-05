namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;

page 50120 "DEF FS Item Add Dialog"
{
    PageType = StandardDialog;
    Caption = 'Add Material';

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;

                field(ItemNo; ItemNo)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    TableRelation = Item."No.";
                    ToolTip = 'Specifies the item that was used.';

                    trigger OnValidate()
                    begin
                        UpdateItemDescription();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        AddItemLookup: Page "DEF FS Add Item Lookup";
                    begin
                        AddItemLookup.LookupMode(true);
                        if AddItemLookup.RunModal() <> Action::LookupOK then
                            exit(false);

                        AddItemLookup.GetRecord(Item);
                        Text := Item."No.";
                        exit(true);
                    end;
                }
                field(ItemDescription; ItemDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the selected item.';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                    MinValue = 0;
                    ToolTip = 'Specifies how many units of the item were used.';
                }
                field(NeedsPurchasing; NeedsPurchasing)
                {
                    ApplicationArea = All;
                    Caption = 'Needs Purchasing';
                    ToolTip = 'Specifies that the item must be purchased, for example because it is not in stock.';
                }
                field(ItemNote; ItemNote)
                {
                    ApplicationArea = All;
                    Caption = 'Note';
                    MultiLine = true;
                    ToolTip = 'Specifies a note about the material, for example the installation place.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Quantity = 0 then
            Quantity := 1;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction <> Action::OK then
            exit(true);

        if (ItemNo <> '') and (Quantity <= 0) then begin
            Message(QuantityMustBePositiveMsg);
            exit(false);
        end;
        exit(true);
    end;

    var
        ItemNo: Code[20];
        ItemDescription: Text[100];
        Quantity: Decimal;
        NeedsPurchasing: Boolean;
        ItemNote: Text[250];
        QuantityMustBePositiveMsg: Label 'The quantity must be greater than 0.';

    procedure GetItemNo(): Code[20]
    begin
        exit(ItemNo);
    end;

    procedure GetQuantity(): Decimal
    begin
        exit(Quantity);
    end;

    procedure GetNeedsPurchasing(): Boolean
    begin
        exit(NeedsPurchasing);
    end;

    procedure GetItemNote(): Text[250]
    begin
        exit(ItemNote);
    end;

    local procedure UpdateItemDescription()
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            ItemDescription := Item.Description
        else
            ItemDescription := '';
    end;
}
