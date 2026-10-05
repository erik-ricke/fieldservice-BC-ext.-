namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Projects.Resources.Ledger;
using Microsoft.Projects.Resources.Resource;

/// <summary>
/// Creates and removes demo work orders. The default demo rows live in the resource file DemoData.json, not in code.
/// Everything this codeunit creates is flagged, so deleting demo data never touches real records.
/// </summary>
codeunit 50115 "DEF FS Demo Data Mgt"
{
    var
        DemoDataResourceTok: Label 'DemoData.json', Locked = true;
        NoDemoSetupErr: Label 'Enter at least one demo setup row before creating demo work orders.';
        UnknownDemoValueErr: Label 'The value "%1" in the demo data file is not a valid %2.', Comment = '%1 = value from the file, %2 = field caption';
        DemoResourceNameLbl: Label 'Demo technician %1', Comment = '%1 = resource number', MaxLength = 100;

    /// <summary>
    /// Copies the default demo rows from the app's resource file into the Demo Setup table. Existing rows are kept.
    /// </summary>
    /// <returns>The number of rows that were added.</returns>
    procedure LoadDefaultSetupRows() AddedRows: Integer
    var
        DemoData: JsonObject;
        RowsToken: JsonToken;
        RowToken: JsonToken;
    begin
        DemoData.ReadFrom(NavApp.GetResourceAsText(DemoDataResourceTok, TextEncoding::UTF8));
        DemoData.Get('setupRows', RowsToken);
        foreach RowToken in RowsToken.AsArray() do
            if InsertSetupRow(RowToken.AsObject()) then
                AddedRows += 1;
    end;

    /// <summary>
    /// Creates work orders and lines from the Demo Setup rows, plus any item or resource a row refers to that does not exist yet.
    /// </summary>
    /// <returns>The number of work orders that were created.</returns>
    procedure CreateDemoData() CreatedOrders: Integer
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        if not DemoSetup.FindSet() then
            Error(NoDemoSetupErr);

        repeat
            if CreateOrder(DemoSetup) then
                CreatedOrders += 1;
            if IsDemoOrder(DemoSetup."Work Order No.") then begin
                EnsureLineSource(DemoSetup);
                CreateLine(DemoSetup);
            end;
        until DemoSetup.Next() = 0;
    end;

    /// <summary>
    /// Deletes demo work orders and the items and resources created for them.
    /// Items and resources that have ledger entries or are used on real work orders are kept.
    /// Demo Setup rows are configuration and are kept as well.
    /// </summary>
    procedure DeleteDemoData()
    var
        DemoRecord: Record "DEF FS Demo Record";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader.SetRange("Demo Data", true);
        WorkOrderHeader.DeleteAll(true);

        if DemoRecord.FindSet() then
            repeat
                if DeleteDemoSourceRecord(DemoRecord) then
                    DemoRecord.Delete();
            until DemoRecord.Next() = 0;
    end;

    local procedure InsertSetupRow(Row: JsonObject): Boolean
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        DemoSetup.Init();
        DemoSetup."Work Order No." := CopyStr(GetText(Row, 'workOrderNo'), 1, MaxStrLen(DemoSetup."Work Order No."));
        DemoSetup."Line No." := GetInteger(Row, 'lineNo');
        if DemoSetup.Find() then
            exit(false);

        DemoSetup.Description := CopyStr(GetText(Row, 'description'), 1, MaxStrLen(DemoSetup.Description));
        DemoSetup."Customer Name" := CopyStr(GetText(Row, 'customerName'), 1, MaxStrLen(DemoSetup."Customer Name"));
        DemoSetup.Address := CopyStr(GetText(Row, 'address'), 1, MaxStrLen(DemoSetup.Address));
        DemoSetup.Priority := GetInteger(Row, 'priority');
        DemoSetup.Status := ParseStatus(GetText(Row, 'status'));
        DemoSetup."Line Type" := ParseLineType(GetText(Row, 'lineType'));
        DemoSetup."Item or Resource No." := CopyStr(GetText(Row, 'no'), 1, MaxStrLen(DemoSetup."Item or Resource No."));
        DemoSetup."Line Description" := CopyStr(GetText(Row, 'lineDescription'), 1, MaxStrLen(DemoSetup."Line Description"));
        DemoSetup.Quantity := GetValue(Row, 'quantity').AsDecimal();
        DemoSetup."Needs Purchasing" := GetValue(Row, 'needsPurchasing').AsBoolean();
        DemoSetup.Insert(true);
        exit(true);
    end;

    local procedure CreateOrder(DemoSetup: Record "DEF FS Demo Setup"): Boolean
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        if WorkOrderHeader.Get(DemoSetup."Work Order No.") then
            exit(false);

        WorkOrderHeader.Init();
        WorkOrderHeader."No." := DemoSetup."Work Order No.";
        WorkOrderHeader.Description := DemoSetup.Description;
        WorkOrderHeader."Customer Name" := DemoSetup."Customer Name";
        WorkOrderHeader.Address := DemoSetup.Address;
        WorkOrderHeader.Priority := DemoSetup.Priority;
        WorkOrderHeader.Status := DemoSetup.Status;
        WorkOrderHeader."Demo Data" := true;
        WorkOrderHeader.Insert(true);
        exit(true);
    end;

    local procedure CreateLine(DemoSetup: Record "DEF FS Demo Setup")
    var
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        if WorkOrderLine.Get(DemoSetup."Work Order No.", DemoSetup."Line No.") then
            exit;

        WorkOrderLine.Init();
        WorkOrderLine."Document No." := DemoSetup."Work Order No.";
        WorkOrderLine."Line No." := DemoSetup."Line No.";
        WorkOrderLine.Type := DemoSetup."Line Type";
        WorkOrderLine."No." := DemoSetup."Item or Resource No.";
        WorkOrderLine.Description := DemoSetup."Line Description";
        WorkOrderLine.Quantity := DemoSetup.Quantity;
        WorkOrderLine."Needs Purchasing" := DemoSetup."Needs Purchasing";
        WorkOrderLine.Insert(true);
    end;

    local procedure IsDemoOrder(WorkOrderNo: Code[20]): Boolean
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        if not WorkOrderHeader.Get(WorkOrderNo) then
            exit(false);
        exit(WorkOrderHeader."Demo Data");
    end;

    local procedure EnsureLineSource(DemoSetup: Record "DEF FS Demo Setup")
    var
        Item: Record Item;
        Resource: Record Resource;
    begin
        if DemoSetup."Item or Resource No." = '' then
            exit;

        case DemoSetup."Line Type" of
            DemoSetup."Line Type"::Item:
                if not Item.Get(DemoSetup."Item or Resource No.") then
                    CreateDemoItem(DemoSetup."Item or Resource No.", DemoSetup."Line Description");
            DemoSetup."Line Type"::Resource:
                if not Resource.Get(DemoSetup."Item or Resource No.") then
                    CreateDemoResource(DemoSetup."Item or Resource No.");
        end;
    end;

    local procedure CreateDemoItem(ItemNo: Code[20]; ItemDescription: Text[100])
    var
        FSSetup: Record "DEF FS Setup";
        Item: Record Item;
        ItemTempl: Record "Item Templ.";
        ItemTemplMgt: Codeunit "Item Templ. Mgt.";
    begin
        Item.Init();
        Item."No." := ItemNo;
        Item.Description := ItemDescription;
        Item."Search Description" := ItemDescription;
        Item.Insert(true);

        FSSetup.GetRecordOnce();
        if FSSetup."Demo Item Template Code" <> '' then begin
            ItemTempl.Get(FSSetup."Demo Item Template Code");
            ItemTemplMgt.ApplyItemTemplate(Item, ItemTempl);
        end;

        LogDemoRecord(Database::Item, ItemNo);
    end;

    local procedure CreateDemoResource(ResourceNo: Code[20])
    var
        Resource: Record Resource;
    begin
        Resource.Init();
        Resource."No." := ResourceNo;
        Resource.Type := Resource.Type::Person;
        Resource.Name := StrSubstNo(DemoResourceNameLbl, ResourceNo);
        Resource."Search Name" := Resource.Name;
        Resource.Insert(true);

        LogDemoRecord(Database::Resource, ResourceNo);
    end;

    local procedure LogDemoRecord(TableNo: Integer; RecordNo: Code[20])
    var
        DemoRecord: Record "DEF FS Demo Record";
    begin
        DemoRecord."Table No." := TableNo;
        DemoRecord."Record No." := RecordNo;
        if DemoRecord.Insert() then;
    end;

    local procedure DeleteDemoSourceRecord(DemoRecord: Record "DEF FS Demo Record"): Boolean
    begin
        case DemoRecord."Table No." of
            Database::Item:
                exit(DeleteDemoItem(DemoRecord."Record No."));
            Database::Resource:
                exit(DeleteDemoResource(DemoRecord."Record No."));
        end;
        exit(true);
    end;

    local procedure DeleteDemoItem(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if not Item.Get(ItemNo) then
            exit(true);

        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        if not ItemLedgerEntry.IsEmpty() then
            exit(false);
        if IsUsedOnWorkOrder("DEF FS Line Type"::Item, ItemNo) then
            exit(false);

        Item.Delete(true);
        exit(true);
    end;

    local procedure DeleteDemoResource(ResourceNo: Code[20]): Boolean
    var
        Resource: Record Resource;
        ResLedgerEntry: Record "Res. Ledger Entry";
    begin
        if not Resource.Get(ResourceNo) then
            exit(true);

        ResLedgerEntry.SetRange("Resource No.", ResourceNo);
        if not ResLedgerEntry.IsEmpty() then
            exit(false);
        if IsUsedOnWorkOrder("DEF FS Line Type"::Resource, ResourceNo) then
            exit(false);

        Resource.Delete(true);
        exit(true);
    end;

    local procedure IsUsedOnWorkOrder(LineType: Enum "DEF FS Line Type"; No: Code[20]): Boolean
    var
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        WorkOrderLine.SetRange(Type, LineType);
        WorkOrderLine.SetRange("No.", No);
        exit(not WorkOrderLine.IsEmpty());
    end;

    local procedure ParseStatus(StatusName: Text): Enum "DEF FS Order Status"
    var
        DemoSetup: Record "DEF FS Demo Setup";
        Index: Integer;
    begin
        Index := Enum::"DEF FS Order Status".Names().IndexOf(StatusName);
        if Index = 0 then
            Error(UnknownDemoValueErr, StatusName, DemoSetup.FieldCaption(Status));
        exit(Enum::"DEF FS Order Status".FromInteger(Enum::"DEF FS Order Status".Ordinals().Get(Index)));
    end;

    local procedure ParseLineType(LineTypeName: Text): Enum "DEF FS Line Type"
    var
        DemoSetup: Record "DEF FS Demo Setup";
        Index: Integer;
    begin
        Index := Enum::"DEF FS Line Type".Names().IndexOf(LineTypeName);
        if Index = 0 then
            Error(UnknownDemoValueErr, LineTypeName, DemoSetup.FieldCaption("Line Type"));
        exit(Enum::"DEF FS Line Type".FromInteger(Enum::"DEF FS Line Type".Ordinals().Get(Index)));
    end;

    local procedure GetValue(Row: JsonObject; KeyName: Text): JsonValue
    var
        Token: JsonToken;
    begin
        Row.Get(KeyName, Token);
        exit(Token.AsValue());
    end;

    local procedure GetText(Row: JsonObject; KeyName: Text): Text
    begin
        exit(GetValue(Row, KeyName).AsText());
    end;

    local procedure GetInteger(Row: JsonObject; KeyName: Text): Integer
    begin
        exit(GetValue(Row, KeyName).AsInteger());
    end;
}
