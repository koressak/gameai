(function() {
  this.Player = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.image = null;
      this.posx = 0;
      this.posy = 0;
      return this.load_image();
    };

    _Class.prototype.set_position = function(x, y) {
      this.posx = x;
      return this.posy = y;
    };

    _Class.prototype.move = function(x, y) {
      var map, nposx, nposy;
      map = g.get_map();
      nposx = this.posx;
      nposy = this.posy;
      if (x > 0) {
        nposx += 1;
      } else if (x < 0) {
        nposx -= 1;
      }
      if (y > 0) {
        nposy += 1;
      } else if (y < 0) {
        nposy -= 1;
      }
      if (map.is_walkable(nposx, nposy)) {
        this.posx = nposx;
        return this.posy = nposy;
      }
    };

    _Class.prototype.load_image = function() {
      return this.image = pinst.loadImage('images/soldier.png');
    };

    _Class.prototype.draw = function() {
      var x, y;
      x = this.posx * tile_width;
      y = this.posy * tile_height;
      return window.pinst.image(this.image, x, y, tile_width, tile_height);
    };

    _Class.prototype.find_path_to_target = function(obj) {
      var best, cost, i, map, next_cost, p, path, t, tiles, _i, _ref;
      p = new Path;
      path = p.find_path(this, obj);
      map = g.get_map();
      tiles = map.get_adjacent_tiles(this.posx, this.posy);
      next_cost = 1000000;
      best = -1;
      for (i = _i = 0, _ref = tiles.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        t = tiles[i];
        cost = map.get_path_cost(t.posx, t.posy, tx, ty);
        if (cost < next_cost) {
          best = t;
          next_cost = cost;
        }
      }
      return [best.posx - this.posx, best.posy - this.posy];
    };

    return _Class;

  })();

  this.NodeRecord = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.node = null;
      this.connection = null;
      this.cost_so_far = 0;
      return this.estimate_cost = 0;
    };

    return _Class;

  })();

  this.Path = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.start = null;
      return this.end = null;
    };

    _Class.prototype.find_path = function(start, end) {
      var closed, connections, current, i, ind, ind2, map, newrec, node, node_cost, node_estimate, open, path, rec, sn, _i, _ref;
      this.start = start;
      this.end = end;
      map = g.get_map();
      path = null;
      open = new Array;
      closed = new Array;
      sn = new NodeRecord;
      sn.node = this.start;
      sn.cost_so_far = 0;
      sn.estimate_cost = this.estimate_cost(this.start.posx, this.start.posya, this.end.posx, this.end.posy);
      open.push(sn);
      current = null;
      while (open.length > 0) {
        current = _.min(open, function(el) {
          return el.estimated_cost;
        });
        if (current.posx === this.end.posx && current.posy === this.end.posy) {
          break;
        }
        connections = map.get_adjacent_tiles(current.posx, current.posy);
        for (i = _i = 0, _ref = connections.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          node = this.get_to_node(connections[i]);
          node_cost = current.cost_so_far + 1;
          node_estimate = this.estimate_cost(node.node.posx, node.node.posy, this.end.posx, this.end.posy);
          ind = this.in_node_records(node, closed);
          ind2 = this.in_node_records(node, open);
          if (ind !== -1) {
            rec = closed[ind];
            if (rec.cost_so_far <= node_cost) {
              continue;
            }
            closed.splice(ind, 1);
          } else if (ind2 !== -1) {
            rec = open[ind2];
            if (rec.cost_so_far <= node_cost) {
              continue;
            }
            open.splice(ind2, 1);
          } else {
            newrec = node;
          }
          newrec.cost_so_far = node_cost;
          newrec.estimate_cost = node_estimate;
          newrec.connection = current;
          open.push(newrec);
        }
        ind = this.in_node_records(current, open);
        open.splice(ind, 1);
        closed.push(current);
      }
      if (current.node.posx === this.end.posx && current.node.posy === this.ned.posy) {
        while (!this.is_equals(current.node, this.start)) {
          path.push(current.node);
          current = current.connection;
        }
      }
      return path;
    };

    _Class.prototype.is_equals = function(obj1, obj2) {
      if (obj1.posx === obj2.posx && obj1.posy === obj2.posy) {
        return true;
      } else {
        return false;
      }
    };

    _Class.prototype.estimate_cost = function(x1, y1, x2, y2) {
      var c1, c2;
      c1 = Math.abs(x1 - x2);
      c2 = Math.abs(y1 - y2);
      return c1 + c2;
    };

    _Class.prototype.get_to_node = function(connection) {
      var node;
      node = new NodeRecord;
      node.node = connection;
      return node;
    };

    _Class.prototype.in_node_records = function(node, records) {
      var i, r, _i, _ref;
      for (i = _i = 0, _ref = records.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        r = records[i];
        if (node.node.posx === r.node.posx && node.node.posy === r.node.posy) {
          return i;
        }
      }
      return -1;
    };

    return _Class;

  })();

  this.Target = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.image = null;
      this.posx = 0;
      this.posy = 0;
      return this.load_image();
    };

    _Class.prototype.load_image = function() {
      return this.image = pinst.loadImage('images/chest.png');
    };

    _Class.prototype.set_position = function(x, y) {
      this.posx = x;
      return this.posy = y;
    };

    _Class.prototype.draw = function() {
      var x, y;
      x = this.posx * tile_width;
      y = this.posy * tile_height;
      return window.pinst.image(this.image, x, y, tile_width, tile_height);
    };

    return _Class;

  })();

}).call(this);
