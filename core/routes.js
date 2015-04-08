var M, routes;

M = require('./models');

routes = module.exports = {};

routes.index = function(req, res) {
  M.user.findOne();
  return res.render('index');
};
