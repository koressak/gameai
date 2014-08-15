// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.TERRAIN_GRASS = 'grass';

  this.TERRAIN_ROCK = 'rock';

  this.WALL_THICKNESS = 2;

  this.MapTile = (function() {
    function _Class() {}

    _Class.prototype.init = function(walk, terrain, x, y) {
      this.walkable = walk;
      this.terrain = terrain;
      this.posx = x;
      this.posy = y;
      this.objects = new Array;
      this.explored = true;
      this.unexplored_image = null;
      return this.walls = [true, true, true, true];
    };

    _Class.prototype.load_image = function() {
      this.terrain_image = pinst.loadImage('images/grass.png');
      this.wall_image = pinst.loadImage('images/rock.png');
      return this.unexplored_image = pinst.loadImage('images/unexplored.png');
    };

    _Class.prototype.add_object = function(obj) {
      return this.objects.push(obj);
    };

    _Class.prototype.get_objects = function() {
      return this.objects;
    };

    _Class.prototype.remove_object = function(obj) {
      var ind, o;
      ind = $.inArray(obj, this.objects);
      if (ind !== -1) {
        o = this.objects.splice(ind, 1);
        return o[0];
      }
      return null;
    };

    _Class.prototype.is_walkable = function() {
      if (!this.walkable) {
        return false;
      }
      if (this.objects.length > 0) {
        return false;
      }
      return true;
    };

    _Class.prototype.remove_wall_in_direction = function(x, y) {
      var dx, dy;
      dx = this.posx - x;
      dy = this.posy - y;
      if (dy > 0) {
        this.walls[0] = false;
      }
      if (dy < 0) {
        this.walls[2] = false;
      }
      if (dx > 0) {
        this.walls[3] = false;
      }
      if (dx < 0) {
        return this.walls[1] = false;
      }
    };

    _Class.prototype.can_get_there_from = function(x, y) {
      var dx, dy;
      dx = this.posx - x;
      dy = this.posy - y;
      if (dy > 0 && this.walls[0]) {
        return false;
      }
      if (dy < 0 && this.walls[2]) {
        return false;
      }
      if (dx > 0 && this.walls[3]) {
        return false;
      }
      if (dx < 0 && this.walls[1]) {
        return false;
      }
      return true;
    };

    _Class.prototype.draw = function() {
      var o, x, y, _i, _len, _ref;
      x = this.posx * tile_width;
      y = this.posy * tile_height;
      window.pinst.image(this.terrain_image, x, y, tile_width, tile_height);
      if (this.walls[0]) {
        window.pinst.image(this.wall_image, x, y, tile_width, WALL_THICKNESS);
      }
      if (this.walls[1]) {
        window.pinst.image(this.wall_image, x + tile_width - WALL_THICKNESS, y, WALL_THICKNESS, tile_height);
      }
      if (this.walls[2]) {
        window.pinst.image(this.wall_image, x, y + tile_height - WALL_THICKNESS, tile_width, y + tile_height);
      }
      if (this.walls[3]) {
        window.pinst.image(this.wall_image, x, y, WALL_THICKNESS, tile_height);
      }
      _ref = this.objects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        o = _ref[_i];
        o.draw();
      }
      if (!this.explored) {
        return window.pinst.image(this.unexplored_image, x, y, tile_width, tile_height);
      }
    };

    return _Class;

  })();

  this.Map = (function() {
    function _Class() {
      this.draw = __bind(this.draw, this);
      console.log("Initializing Map");
    }

    _Class.prototype.init = function(w, h) {
      var i, _i, _ref, _results;
      this.width = w;
      this.height = h;
      this.tiles = new Array(w);
      this.game_objects = new Array;
      _results = [];
      for (i = _i = 0, _ref = w - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        _results.push(this.tiles[i] = new Array(h));
      }
      return _results;
    };

    _Class.prototype.add_tile = function(x, y, tile) {
      return this.tiles[x][y] = tile;
    };

    _Class.prototype.add_game_object = function(obj) {
      if ($.inArray(obj, this.game_objects === -1)) {
        this.game_objects.push(obj);
        return this.tiles[obj.posx][obj.posy].add_object(obj);
      }
    };

    _Class.prototype.move_game_object = function(obj, ox, oy, nx, ny) {
      var o;
      this.set_tile_explored(nx, ny);
      o = this.tiles[ox][oy].remove_object(obj);
      if (o !== null) {
        return this.tiles[nx][ny].add_object(o);
      }
    };

    _Class.prototype.remove_game_object = function(obj) {
      var ind, o;
      ind = $.inArray(obj, this.game_objects);
      if (ind !== -1) {
        o = this.game_objects[ind];
        this.tiles[o.posx][o.posy].remove_object(obj);
        return this.game_objects.splice(ind, 1);
      }
    };

    _Class.prototype.is_tile_walkable = function(x, y) {
      var t;
      if (x < 0 || x > this.width - 1) {
        return false;
      }
      if (y < 0 || y > this.height - 1) {
        return false;
      }
      t = this.tiles[x][y];
      return t.is_walkable();
    };

    _Class.prototype.is_tile_free = function(x, y) {
      if (x < 0 || x > this.width - 1) {
        return false;
      }
      if (y < 0 || y > this.height - 1) {
        return false;
      }
      return this.tiles[x][y].get_objects().length === 0;
    };

    _Class.prototype.get_tile_objects = function(x, y) {
      if (x < 0 || x > this.width - 1) {
        return null;
      }
      if (y < 0 || y > this.height - 1) {
        return null;
      }
      return this.tiles[x][y].get_objects();
    };

    _Class.prototype.set_tile_explored = function(x, y) {
      return this.tiles[x][y].explored = true;
    };

    _Class.prototype.get_adjacent_tiles = function(x, y) {
      var tiles;
      tiles = new Array;
      if (x - 1 >= 0) {
        tiles.push(this.tiles[x - 1][y]);
      }
      if (x + 1 <= this.width - 1) {
        tiles.push(this.tiles[x + 1][y]);
      }
      if (y - 1 >= 0) {
        tiles.push(this.tiles[x][y - 1]);
      }
      if (y + 1 <= this.height - 1) {
        tiles.push(this.tiles[x][y + 1]);
      }
      return tiles;
    };

    _Class.prototype.get_adjacent_walkable_tiles = function(x, y) {
      var ret, t, tiles, _i, _len;
      ret = new Array;
      tiles = this.get_adjacent_tiles(x, y);
      for (_i = 0, _len = tiles.length; _i < _len; _i++) {
        t = tiles[_i];
        if (t.can_get_there_from(x, y)) {
          ret.push(t);
        }
      }
      return ret;
    };

    _Class.prototype.draw = function() {
      var x, y, _i, _ref, _results;
      _results = [];
      for (x = _i = 0, _ref = this.width - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
        _results.push((function() {
          var _j, _ref1, _results1;
          _results1 = [];
          for (y = _j = 0, _ref1 = this.height - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
            _results1.push(this.tiles[x][y].draw());
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    return _Class;

  })();

  this.MapRenderer = (function() {
    function _Class() {
      console.log("Initializing MapRenderer");
    }

    _Class.prototype.render = function(w, h) {
      var adj, here, map, n, neib, neighbors, next, nodes, path, posx, posy, rem_walls_no, t, unvisited, x, y, _i, _j, _k, _l, _len, _len1, _m, _n, _o, _ref, _ref1, _ref2, _ref3;
      map = new window.Map;
      map.init(w, h);
      nodes = (w * h) - 1;
      here = [Math.floor(Math.random() * w), Math.floor(Math.random() * h)];
      path = [here];
      unvisited = new Array(w);
      for (x = _i = 0, _ref = w - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
        unvisited[x] = new Array(h);
        for (y = _j = 0, _ref1 = h - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          unvisited[x][y] = true;
          t = new window.MapTile;
          t.init(true, TERRAIN_GRASS, x, y);
          map.add_tile(x, y, t);
        }
      }
      unvisited[here[0]][here[1]] = false;
      while (0 < nodes) {
        if (typeof here === "undefined") {
          break;
        }
        neighbors = new Array();
        adj = map.get_adjacent_tiles(here[0], here[1]);
        for (_k = 0, _len = adj.length; _k < _len; _k++) {
          t = adj[_k];
          if (unvisited[t.posx][t.posy]) {
            neighbors.push(t);
          }
        }
        if (neighbors.length > 0) {
          nodes -= 1;
          next = neighbors[Math.floor(Math.random() * neighbors.length)];
          unvisited[next.posx][next.posy] = false;
          map.tiles[next.posx][next.posy].remove_wall_in_direction(here[0], here[1]);
          map.tiles[here[0]][here[1]].remove_wall_in_direction(next.posx, next.posy);
          path.push(here);
          here = [next.posx, next.posy];
        } else {
          here = path.pop();
        }
      }
      rem_walls_no = window.remove_walls_no;
      for (x = _l = 1; 1 <= rem_walls_no ? _l <= rem_walls_no : _l >= rem_walls_no; x = 1 <= rem_walls_no ? ++_l : --_l) {
        posx = get_random_int(0, w - 1);
        posy = get_random_int(0, h - 1);
        t = map.tiles[posx][posy];
        t.walls = [false, false, false, false];
        n = map.get_adjacent_tiles(t.posx, t.posy);
        for (_m = 0, _len1 = n.length; _m < _len1; _m++) {
          neib = n[_m];
          neib.remove_wall_in_direction(t.posx, t.posy);
        }
      }
      for (x = _n = 0, _ref2 = w - 1; 0 <= _ref2 ? _n <= _ref2 : _n >= _ref2; x = 0 <= _ref2 ? ++_n : --_n) {
        for (y = _o = 0, _ref3 = h - 1; 0 <= _ref3 ? _o <= _ref3 : _o >= _ref3; y = 0 <= _ref3 ? ++_o : --_o) {
          map.tiles[x][y].load_image();
        }
      }
      return map;
    };

    return _Class;

  })();

}).call(this);
