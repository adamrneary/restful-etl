connections = require('../../lib/connections.coffee')
expect  = require('chai').expect

describe 'connections', ->
  describe 'test function', () ->
    it 'should return "connections"', ()->
      expect(connections.connections()).to.equal('connections')
