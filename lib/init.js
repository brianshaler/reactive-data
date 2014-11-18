(function() {
  var Repository, listen, unlisten, update, _;

  _ = require('lodash');

  Repository = require('./Repository');

  listen = require('./listen');

  unlisten = require('./unlisten');

  update = require('./update');

  module.exports = function(options) {
    var reactor;
    reactor = {
      Repository: Repository,
      components: [],
      listen: function() {
        return listen.apply(reactor, arguments);
      },
      unlisten: function() {
        return unlisten.apply(reactor, arguments);
      },
      update: function() {
        return update.apply(reactor, arguments);
      },
      listeners: {},
      on: function(eventName, cb) {
        var _ref;
        if (!(((_ref = reactor.listeners[eventName]) != null ? _ref.length : void 0) > 0)) {
          reactor.listeners[eventName] = [];
        }
        reactor.listeners[eventName].push(cb);
        return reactor;
      },
      off: function(eventName, cb) {
        var i, _i, _ref, _ref1;
        if (!(((_ref = reactor.listeners[eventName]) != null ? _ref.length : void 0) > 0)) {
          return;
        }
        for (i = _i = _ref1 = reactor.listeners[eventName].length - 1; _i >= 0; i = _i += -1) {
          if (reactor.listeners[eventName][i] === cb) {
            reactor.listeners[eventName].splice(i, 1);
          }
        }
        return reactor;
      }
    };
    _.merge(reactor, options);
    return reactor;
  };

}).call(this);
