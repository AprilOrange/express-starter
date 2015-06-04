mongoose = require 'mongoose'
mongo_uri = process.env.EXP_MONGO_URI || 'mongodb://localhost/test'
connection = mongoose.connect mongo_uri
Schema = mongoose.Schema
timestamps = require 'mongoose-timestamp'
autoIncrement = require 'mongoose-auto-increment'

autoIncrement.initialize connection

# initialize
UserSchema = new Schema
  email: 
    type: String
    required: true
  is_active: 
    type: Boolean
  hash: 
    type: String

UserSchema.plugin timestamps
UserSchema.plugin autoIncrement.plugin,
  model: 'User',
  field: 'uid'
User = mongoose.model 'User', UserSchema

module.exports = 
  user: User