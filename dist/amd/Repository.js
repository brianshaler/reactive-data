(function() {
  define(function(require, exports, module) {
    var Bacon, ItemStream, KVStream, Repository, keyval, _;
    _ = require('lodash');
    Bacon = require('baconjs');
    if (Bacon.Bacon) {
      Bacon = Bacon.Bacon;
    }
    keyval = {};
    KVStream = new Bacon.Bus();
    ItemStream = new Bacon.Bus();
    Repository = {
      reset: function() {
        return keyval = {};
      },
      update: function(key, value) {
        keyval[key] = value;
        KVStream.push({
          key: key,
          value: _.clone(value)
        });
      },
      subscribe: function(name, cb) {
        var latest, stream, _ref;
        _ref = Repository.get(name), stream = _ref.stream, latest = _ref.latest;
        cb(latest);
        return stream.onValue(cb);
      },
      getStream: function(key) {
        return KVStream.filter(function(item) {
          return item.key === key;
        }).map(function(item) {
          return item.value;
        });
      },
      getLatest: function(key) {
        return _.clone(keyval[key]);
      },
      get: function(key) {
        return {
          stream: Repository.getStream(key),
          latest: Repository.getLatest(key)
        };
      },
      pushItem: function(obj) {
        return Repository.pushItems([obj]);
      },
      pushItems: function(objs) {
        return ItemStream.push(objs);
      },
      onItem: function(filter, cb) {
        var stop;
        if (filter == null) {
          filter = (function() {
            return true;
          });
        }
        stop = Repository.onItems(filter, function(items) {
          var item, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = items.length; _i < _len; _i++) {
            item = items[_i];
            _results.push(cb(item));
          }
          return _results;
        });
        return stop;
      },
      onItems: function(filter, cb) {
        var bus, unsubscribeBus, unsubscribeStream;
        bus = new Bacon.Bus();
        unsubscribeStream = ItemStream.onValue(function(newItems) {
          var items;
          items = typeof filter === 'function' ? _.filter(newItems, filter) : _.filter(newItems, function(item) {
            if ((_.where([item], filter)).length !== 1) {
              return false;
            }
            return true;
          });
          if (!(items.length > 0)) {
            return;
          }
          return bus.push(items);
        });
        unsubscribeBus = bus.onValue(cb);
        return function() {
          unsubscribeStream();
          return unsubscribeBus();
        };
      }
    };
    return module.exports = Repository;
  });

}).call(this);
