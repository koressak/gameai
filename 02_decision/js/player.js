(function() {
  this.SIGHT_UP = 0;

  this.SIGHT_RIGHT = 1;

  this.SIGHT_DOWN = 2;

  this.SIGHT_LEFT = 3;

  this.Player = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.image = null;
      this.posx = 0;
      this.posy = 0;
      this.load_image();
      this.current_target = null;
      this.current_path = null;
      this.score = 0;
      this.health = 100;
      this.damage = 5;
      this.speed = 1;
      this.sight_radius = 2;
      return this.direction = SIGHT_LEFT;
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

    _Class.prototype.has_target = function() {
      return this.current_target !== null;
    };

    _Class.prototype.set_target = function(obj) {
      return this.current_target = obj;
    };

    _Class.prototype.clear_current_goal = function() {
      this.current_target = null;
      return this.current_path = null;
    };

    _Class.prototype.get_next_move = function() {
      var g, ind, step, t;
      g = window.g;
      if (this.current_target !== null) {
        ind = $.inArray(this.current_target, g.targets);
        if (ind === -1) {
          t = g.get_random_target();
          this.clear_current_goal();
          this.set_target(t);
        }
        if (this.current_path === null) {
          this.current_path = this.find_path_to_target(this.current_target);
        }
        step = this.current_path.splice(0, 1);
        if (step.length > 0) {
          return [step[0].posx - this.posx, step[0].posy - this.posy];
        } else {
          this.current_path = null;
          this.current_target = null;
        }
      }
      return [0, 0];
    };

    _Class.prototype.find_path_to_target = function(obj) {
      var p, path;
      p = new Path;
      path = p.find_path(this, obj);
      return path;
    };

    _Class.prototype.do_action = function() {
      if (!this.current_target) {
        return this.current_target = g.get_random_target();
      }
    };

    return _Class;

  })();

}).call(this);
