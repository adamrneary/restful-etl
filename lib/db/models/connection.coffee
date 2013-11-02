__proto = require './__proto'
mongoose = require 'mongoose'
Schema = mongoose.Schema

connectionSchema = new Schema
  name: String
  provider: String
  realm: String
  oauth_consumer_key: String
  oauth_consumer_secret: String
  oauth_access_key: String
  oauth_access_secret: String

  subdomain: String
  company_id: String
  token: String

class Connection extends __proto('Connection', connectionSchema)

module.exports = Connection
