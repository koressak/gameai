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
