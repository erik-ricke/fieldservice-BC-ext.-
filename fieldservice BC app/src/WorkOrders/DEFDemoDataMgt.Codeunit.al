namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;

codeunit 50115 "DEF FS Demo Data Mgt"
{
    procedure CreateFromSetup()
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        if not DemoSetup.FindSet() then
            exit;

        repeat
            CreateOrder(DemoSetup);
            CreateLine(DemoSetup);
        until DemoSetup.Next() = 0;
    end;

    procedure EnsureDefaultSetupData()
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        if not DemoSetup.IsEmpty() then
            exit;

        AddDemoSetupRow('FS-1001', 'Heizungsprüfung', 'Müller GmbH', 'Musterstraße 12, Berlin', 1, Format('Open'), 10000, Format('Item'), 'ITEM-1001', 'Filter ersetzen', 1, true);
        AddDemoSetupRow('FS-1002', 'Kälteanlage inspizieren', 'Schmidt & Partner', 'Hauptstraße 8, Hamburg', 2, Format('Traveling'), 10000, Format('Resource'), 'TECH-01', 'Servicevorbereitung', 1, false);
        AddDemoSetupRow('FS-1003', 'Lüftungsreinigung', 'Bauer Immobilien', 'Kaiserweg 21, München', 3, Format('In Progress'), 10000, Format('Item'), 'ITEM-1003', 'Luftfilter', 2, true);
        AddDemoSetupRow('FS-1004', 'Stromversorgung prüfen', 'Klein Elektro', 'Schillerallee 5, Köln', 1, Format('Paused'), 10000, Format('Resource'), 'TECH-02', 'Techniker vor Ort', 1, false);
        AddDemoSetupRow('FS-1005', 'Sanitäranlage warten', 'Grüne Bau GmbH', 'Am Markt 44, Dresden', 4, Format('Done'), 10000, Format('Item'), 'ITEM-1005', 'Dichtungen', 3, true);
        AddDemoSetupRow('FS-1006', 'Aufzug überwachen', 'City Center AG', 'Bahnhofplatz 9, Stuttgart', 2, Format('Open'), 10000, Format('Resource'), 'TECH-03', 'Technikprüfung', 1, false);
        AddDemoSetupRow('FS-1007', 'Wasserzähler prüfen', 'Nordwerk AG', 'Industriestraße 30, Bremen', 5, Format('In Progress'), 10000, Format('Item'), 'ITEM-1007', 'Messgerät', 1, true);
        AddDemoSetupRow('FS-1008', 'Security System check', 'Westside Hotel', 'Parkallee 15, Frankfurt', 3, Format('Traveling'), 10000, Format('Resource'), 'TECH-04', 'Alarmtest', 1, false);
        AddDemoSetupRow('FS-1009', 'Reparatur Dachfenster', 'Bergmann Haus', 'Rosenweg 7, Düsseldorf', 2, Format('Open'), 10000, Format('Item'), 'ITEM-1009', 'Dichtung setzen', 2, true);
        AddDemoSetupRow('FS-1010', 'Energieaudit', 'GreenTech Solutions', 'Lindenstraße 18, Leipzig', 4, Format('Paused'), 10000, Format('Item'), 'ITEM-1010', 'Messsensor', 1, true);
        AddDemoSetupRow('FS-1011', 'Brennstoffanlage testen', 'Alpine Energy', 'Südring 66, Nürnberg', 1, Format('In Progress'), 10000, Format('Resource'), 'TECH-05', 'Prüfung + Diagnose', 1, false);
        AddDemoSetupRow('FS-1012', 'Schließanlage reparieren', 'Peters Wohnbau', 'Waldfeld 11, Hannover', 3, Format('Done'), 10000, Format('Item'), 'ITEM-1012', 'Schließzylinder', 2, true);
    end;

    procedure EnsureDemoItems()
    var
        Item: Record Item;
    begin
        AddDemoItem('ITEM-1001', 'Filter ersetzen');
        AddDemoItem('ITEM-1002', 'Schlauchset 2m');
        AddDemoItem('ITEM-1003', 'Luftfilter');
        AddDemoItem('ITEM-1004', 'Kabelsatz 5m');
        AddDemoItem('ITEM-1005', 'Dichtungen');
        AddDemoItem('ITEM-1006', 'Schaltschrank-Set');
        AddDemoItem('ITEM-1007', 'Messgerät');
        AddDemoItem('ITEM-1008', 'Sensor Upgrade');
        AddDemoItem('ITEM-1009', 'Dichtung setzen');
        AddDemoItem('ITEM-1010', 'Messsensor');
        AddDemoItem('ITEM-1011', 'Verteilerklemmen');
        AddDemoItem('ITEM-1012', 'Schließzylinder');
        AddDemoItem('ITEM-1013', 'Ventilatorbaugruppe');
        AddDemoItem('ITEM-1014', 'Kabelhalter');
        AddDemoItem('ITEM-1015', 'Installationssatz');
    end;

    procedure DeleteDemoData()
    var
        DemoSetup: Record "DEF FS Demo Setup";
        WorkOrderHeader: Record "DEF FS Work Order Header";
        WorkOrderLine: Record "DEF FS Work Order Line";
        MobileCue: Record "DEF FS Mobile Cue";
        Item: Record Item;
    begin
        if WorkOrderLine.FindSet() then
            repeat
                WorkOrderLine.Delete(true);
            until WorkOrderLine.Next() = 0;

        if WorkOrderHeader.FindSet() then
            repeat
                WorkOrderHeader.Delete(true);
            until WorkOrderHeader.Next() = 0;

        if DemoSetup.FindSet() then
            repeat
                DemoSetup.Delete();
            until DemoSetup.Next() = 0;

        if MobileCue.Get('DEFAULT') then
            MobileCue.Delete();

        Item.SetFilter("No.", 'ITEM-1001|ITEM-1002|ITEM-1003|ITEM-1004|ITEM-1005|ITEM-1006|ITEM-1007|ITEM-1008|ITEM-1009|ITEM-1010|ITEM-1011|ITEM-1012|ITEM-1013|ITEM-1014|ITEM-1015');
        if Item.FindSet() then
            repeat
                Item.Delete();
            until Item.Next() = 0;
    end;

    local procedure AddDemoItem(ItemNo: Code[20]; DescriptionValue: Text[100])
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            exit;

        Item.Init();
        Item."No." := ItemNo;
        Item.Description := DescriptionValue;
        Item."Base Unit of Measure" := 'PCS';
        Item.Insert(false);
    end;

    local procedure AddDemoSetupRow(
        WorkOrderNo: Code[20];
        DescriptionValue: Text[100];
        CustomerName: Text[100];
        AddressValue: Text[100];
        PriorityValue: Integer;
        StatusValue: Text[30];
        LineNoValue: Integer;
        LineTypeValue: Text[30];
        ItemOrResourceNo: Code[20];
        LineDescriptionValue: Text[100];
        QuantityValue: Decimal;
        NeedsPurchasingValue: Boolean)
    var
        DemoSetup: Record "DEF FS Demo Setup";
    begin
        DemoSetup.Init();
        DemoSetup."Work Order No." := WorkOrderNo;
        DemoSetup.Description := DescriptionValue;
        DemoSetup."Customer Name" := CustomerName;
        DemoSetup.Address := AddressValue;
        DemoSetup.Priority := PriorityValue;
        Evaluate(DemoSetup.Status, StatusValue);
        DemoSetup."Line No." := LineNoValue;
        Evaluate(DemoSetup."Line Type", LineTypeValue);
        DemoSetup."Item or Resource No." := ItemOrResourceNo;
        DemoSetup."Line Description" := LineDescriptionValue;
        DemoSetup.Quantity := QuantityValue;
        DemoSetup."Needs Purchasing" := NeedsPurchasingValue;
        DemoSetup.Insert(false);
    end;

    local procedure CreateOrder(DemoSetup: Record "DEF FS Demo Setup")
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        if WorkOrderHeader.Get(DemoSetup."Work Order No.") then
            exit;

        WorkOrderHeader.Init();
        WorkOrderHeader."No." := DemoSetup."Work Order No.";
        WorkOrderHeader.Description := DemoSetup.Description;
        WorkOrderHeader."Customer Name" := DemoSetup."Customer Name";
        WorkOrderHeader.Address := DemoSetup.Address;
        WorkOrderHeader.Priority := DemoSetup.Priority;
        WorkOrderHeader.Status := DemoSetup.Status;
        WorkOrderHeader.Insert(false);
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
        WorkOrderLine.Insert(false);
    end;
}