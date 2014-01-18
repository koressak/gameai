(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.TERRAIN_GRASS = 'grass';

  this.TERRAIN_ROCK = 'rock';

  this.MapTile = (function() {
    function _Class() {}

    _Class.prototype.init = function(walk, terrain, x, y) {
      this.walkable = walk;
      this.terrain = terrain;
      this.x = x;
      this.y = y;
      this.width = window.tile_width;
      return this.width = window.tile_height;
    };

    _Class.prototype.load_image = function() {
      switch (this.terrain) {
        case window.TERRAIN_GRASS:
          return this.image = window.pinst.loadImage('images/grass.png');
        case window.TERRAIN_ROCK:
          return this.image = window.pinst.loadImage('images/rock.png');
      }
    };

    _Class.prototype.draw = function() {
      return window.pinst.image(this.image, this.x, this.y, this.width, this.height);
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
      _results = [];
      for (i = _i = 0, _ref = w - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        _results.push(this.tiles[i] = new Array(h));
      }
      return _results;
    };

    _Class.prototype.add_tile = function(x, y, tile) {
      return this.tiles[x][y] = tile;
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
      var map, posx, posy, rock_no, t, x, y, _i, _j, _k, _l, _m, _ref, _ref1, _ref2, _ref3;
      map = new window.Map;
      map.init(w, h);
      for (x = _i = 0, _ref = w - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
        for (y = _j = 0, _ref1 = h - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          t = new window.MapTile;
          posx = x * tile_width;
          posy = y * tile_height;
          t.init(true, TERRAIN_GRASS, posx, posy);
          map.add_tile(x, y, t);
        }
      }
      rock_no = window.rock_count;
      for (x = _k = 1; 1 <= rock_no ? _k <= rock_no : _k >= rock_no; x = 1 <= rock_no ? ++_k : --_k) {
        posx = get_random_int(0, w - 1);
        posy = get_random_int(0, h - 1);
        t = map.tiles[posx][posy];
        t.walkable = false;
        t.terrain = TERRAIN_ROCK;
      }
      for (x = _l = 0, _ref2 = w - 1; 0 <= _ref2 ? _l <= _ref2 : _l >= _ref2; x = 0 <= _ref2 ? ++_l : --_l) {
        for (y = _m = 0, _ref3 = h - 1; 0 <= _ref3 ? _m <= _ref3 : _m >= _ref3; y = 0 <= _ref3 ? ++_m : --_m) {
          map.tiles[x][y].load_image();
        }
      }
      return map;
    };

    return _Class;

  })();

}).call(this);
