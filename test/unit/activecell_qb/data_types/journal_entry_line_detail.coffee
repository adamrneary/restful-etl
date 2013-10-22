describe "qbd ActiveCell", ->
  describe "JournalEntryLineDetail", ->

    it "can find an account based on the item", ->
      @qbdObj =
        Id: "QB:123"
        Amount: 500
        DetailType: "JournalEntryLineDetail"
        JournalEntryLineDetail:
          PostingType: 'Credit'
          Entity:
            Type: 'Vendor'
            EntityRef: {value: 'QB:234'}
          AccountRef: {value: 'QB:345'}

      resultObj:
        Id: "QB:123"
        Amount: 500
        PostingType: 'Credit'
        AccountId: @accountLookup(@itemLookup('QB:345')['ExpenseAccountRef'])
        VendorId: @vendorLookup('QB:234') # See entity type ref. This could be customer or vendor.