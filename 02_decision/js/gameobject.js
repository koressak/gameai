(function() {
  var _MovableGameObject, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.GameObject = (function() {
    function _Class() {
      this.posx = -1;
      this.posy = -1;
      this.image = '';
      this.img = null;
      this.speed = 0;
    }

    _Class.prototype.set_position = function(x, y) {
      this.posx = x;
      return this.posy = y;
    };

    _Class.prototype.add_to_game = function() {
      var map;
      map = g.get_map();
      return map.add_game_object(this);
    };

    _Class.prototype.remove_from_game = function() {
      var map;
      map = g.get_map();
      return map.remove_game_object(this);
    };

    _Class.prototype.load_image = function() {
      if (this.image !== '') {
        return this.img = pinst.loadImage(this.image);
      } else {
        return console.error("No image to load");
      }
    };

    _Class.prototype.draw = function() {
      var x, y;
      x = this.posx * window.tile_width;
      y = this.posy * window.tile_height;
      return pinst.image(this.img, x, y, window.tile_width, window.tile_height);
    };

    return _Class;

  })();

  this.MovableGameObject = _MovableGameObject = (function(_super) {
    __extends(_MovableGameObject, _super);

    function _MovableGameObject() {
      _ref = _MovableGameObject.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    _MovableGameObject.prototype.move = function(x, y) {
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
      if (map.is_tile_walkable(nposx, nposy)) {
        map.move_game_object(this.posx, this.posy, nposx, nposy);
        this.posx = nposx;
        return this.posy = nposy;
      }
    };

    return _MovableGameObject;

  })(this.GameObject);

}).call(this);
