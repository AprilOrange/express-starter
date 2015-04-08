M = require './models'

routes = module.exports = {}

routes.index = (req, res) ->
  M.user.findOne()
  res.render 'index'