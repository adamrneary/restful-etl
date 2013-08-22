batches = require('../../lib/batches.coffee')
expect  = require('chai').expect

describe 'batches', ->
  describe 'test function', () ->
    it 'should return "batches"', ()->
      expect(batches.batches()).to.equal('batches')
