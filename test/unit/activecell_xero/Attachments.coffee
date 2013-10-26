describe "xero ActiveCell", ->
  describe "Attachment object", ->
    beforeEach ()->
      @companyId = "1A78ADSF6780AZXCVf"

      @xeroObj =
        AttachmentID: "e59a2c7f-1306-4078-a0f3-73537afcbba9"
        FileName: "Image00394.png"
        Url: "https://api.xero.com/api.xro/2.0/Receipts/e59a2c7f-4078-a0f3-73537afcbba9/Attachments/Image00394.png"
        MimeType: "image/png"
        ContentLength: "10294"

    it "can transform a xeroObj in order to create a new Activecell obj", ->
