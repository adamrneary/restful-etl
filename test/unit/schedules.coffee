schedules = require('../../lib/schedules.coffee')
expect  = require('chai').expect

describe 'schedules', ->
  describe 'test function', () ->
    it 'should return "schedules"', ()->
      expect(schedules.schedules()).to.equal('schedules')
