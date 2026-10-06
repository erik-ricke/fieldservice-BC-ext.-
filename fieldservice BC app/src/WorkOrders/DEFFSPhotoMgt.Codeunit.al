namespace DEF.FieldService.WorkOrders;

using Microsoft.Foundation.Attachment;
using System.Device;

/// <summary>
/// Adds photos to work orders. Photos are stored as standard document attachments of the work order.
/// </summary>
codeunit 50136 "DEF FS Photo Mgt"
{
    var
        WorkOrderClosedErr: Label 'You cannot add photos to work order %1 because its status is %2.', Comment = '%1 = work order number, %2 = status';
        SelectPhotoTxt: Label 'Select a photo';
        ImageFileFilterTxt: Label 'Images (*.jpg;*.jpeg;*.png;*.heic)|*.jpg;*.jpeg;*.png;*.heic', Locked = true;
        PhotoFileNameTok: Label '%1_%2.%3', Locked = true, Comment = '%1 = work order number, %2 = date and time, %3 = file extension';
        TimestampFormatTok: Label '<Year4><Month,2><Day,2>_<Hours24,2><Minutes,2><Seconds,2>', Locked = true;
        DefaultExtensionTok: Label 'jpg', Locked = true;
        PhotoAddedMsg: Label 'The photo was added to work order %1.', Comment = '%1 = work order number';

    /// <summary>
    /// Takes a photo with the device camera, or lets the user upload an image where no camera is available (for example in the browser on a PC),
    /// and attaches it to the work order.
    /// </summary>
    procedure TakePhoto(WorkOrderHeader: Record "DEF FS Work Order Header")
    var
        Camera: Codeunit Camera;
        PhotoInStream: InStream;
        PictureName: Text;
    begin
        CheckCanAddPhoto(WorkOrderHeader);

        if Camera.IsAvailable() then begin
            if not Camera.GetPicture(GetPhotoQuality(), PhotoInStream, PictureName) then
                exit;
        end else
            if not UploadIntoStream(SelectPhotoTxt, '', ImageFileFilterTxt, PictureName, PhotoInStream) then
                exit;

        AddPhoto(WorkOrderHeader, PhotoInStream, GetPhotoFileName(WorkOrderHeader."No.", PictureName, CurrentDateTime()));
        Message(PhotoAddedMsg, WorkOrderHeader."No.");
    end;

    procedure AddPhoto(WorkOrderHeader: Record "DEF FS Work Order Header"; PhotoInStream: InStream; FileName: Text)
    var
        DocumentAttachment: Record "Document Attachment";
        WorkOrderRecRef: RecordRef;
    begin
        CheckCanAddPhoto(WorkOrderHeader);

        WorkOrderRecRef.GetTable(WorkOrderHeader);
        DocumentAttachment.SaveAttachmentFromStream(PhotoInStream, WorkOrderRecRef, FileName, true);
    end;

    procedure CheckCanAddPhoto(WorkOrderHeader: Record "DEF FS Work Order Header")
    begin
        if WorkOrderHeader.Status in [WorkOrderHeader.Status::Done, WorkOrderHeader.Status::Failed] then
            Error(WorkOrderClosedErr, WorkOrderHeader."No.", WorkOrderHeader.Status);
    end;

    /// <summary>
    /// Builds a file name like WO-00001_20261006_093015.jpg and keeps the extension of the original picture if it has one.
    /// </summary>
    procedure GetPhotoFileName(WorkOrderNo: Code[20]; OriginalName: Text; TakenAt: DateTime): Text
    var
        Extension: Text;
    begin
        Extension := GetExtension(OriginalName);
        if Extension = '' then
            Extension := DefaultExtensionTok;
        exit(StrSubstNo(PhotoFileNameTok, WorkOrderNo, Format(TakenAt, 0, TimestampFormatTok), Extension));
    end;

    local procedure GetExtension(FileName: Text): Text
    var
        Parts: List of [Text];
    begin
        if not FileName.Contains('.') then
            exit('');
        Parts := FileName.Split('.');
        exit(Parts.Get(Parts.Count()).ToLower());
    end;

    local procedure GetPhotoQuality(): Integer
    begin
        // Keeps photos readable while staying small enough for mobile uploads and the work report.
        exit(60);
    end;
}
