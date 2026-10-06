namespace DEF.FieldService.Test;

using DEF.FieldService.WorkOrders;
using Microsoft.Foundation.Attachment;
using System.Text;
using System.Utilities;

codeunit 50196 "DEF FS Photo Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        TestLibrary: Codeunit "DEF FS Test Library";
        PhotoMgt: Codeunit "DEF FS Photo Mgt";
        // A 1x1 pixel PNG, so the attachment holds a real image.
        PixelPngTok: Label 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==', Locked = true;

    [Test]
    procedure AddPhoto_OpenOrder_AttachesImageToOrder()
    var
        DocumentAttachment: Record "Document Attachment";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);

        AddTestPhoto(WorkOrderHeader, 'photo1.png');

        DocumentAttachment.SetRange("Table ID", Database::"DEF FS Work Order Header");
        DocumentAttachment.SetRange("No.", WorkOrderHeader."No.");
        TestLibrary.AreEqual(1, DocumentAttachment.Count(), 'Number of attachments');
        DocumentAttachment.FindFirst();
        TestLibrary.AreEqual(DocumentAttachment."File Type"::Image, DocumentAttachment."File Type", 'File type');
        TestLibrary.IsTrue(DocumentAttachment.HasContent(), 'The photo must have content');
    end;

    [Test]
    procedure AddPhoto_DoneOrder_ThrowsError()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Done, false);

        asserterror AddTestPhoto(WorkOrderHeader, 'photo.png');

        TestLibrary.ExpectedError('You cannot add photos');
    end;

    [Test]
    procedure NoOfPhotos_TwoPhotos_CountsTwo()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);

        AddTestPhoto(WorkOrderHeader, 'photo1.png');
        AddTestPhoto(WorkOrderHeader, 'photo2.png');

        WorkOrderHeader.CalcFields("No. of Photos");
        TestLibrary.AreEqual(2, WorkOrderHeader."No. of Photos", 'No. of photos');
    end;

    [Test]
    procedure Delete_OrderWithPhotos_DeletesAttachments()
    var
        DocumentAttachment: Record "Document Attachment";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        AddTestPhoto(WorkOrderHeader, 'photo1.png');

        WorkOrderHeader.Delete(true);

        DocumentAttachment.SetRange("Table ID", Database::"DEF FS Work Order Header");
        DocumentAttachment.SetRange("No.", WorkOrderHeader."No.");
        TestLibrary.IsTrue(DocumentAttachment.IsEmpty(), 'Photos must be deleted with their work order');
    end;

    [Test]
    procedure GetPhotoFileName_WithAndWithoutExtension_BuildsName()
    var
        TakenAt: DateTime;
    begin
        TakenAt := CreateDateTime(DMY2Date(6, 10, 2026), 093015T);

        TestLibrary.AreEqual('WO-00001_20261006_093015.png', PhotoMgt.GetPhotoFileName('WO-00001', 'IMG_4711.PNG', TakenAt), 'With extension');
        TestLibrary.AreEqual('WO-00001_20261006_093015.jpg', PhotoMgt.GetPhotoFileName('WO-00001', 'camera', TakenAt), 'Without extension');
    end;

    local procedure AddTestPhoto(WorkOrderHeader: Record "DEF FS Work Order Header"; FileName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        PhotoInStream: InStream;
        PhotoOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(PhotoOutStream);
        Base64Convert.FromBase64(PixelPngTok, PhotoOutStream);
        TempBlob.CreateInStream(PhotoInStream);
        PhotoMgt.AddPhoto(WorkOrderHeader, PhotoInStream, FileName);
    end;
}
