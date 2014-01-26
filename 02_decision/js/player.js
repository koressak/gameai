(function() {
  var _Player, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.SIGHT_UP = 0;

  this.SIGHT_RIGHT = 1;

  this.SIGHT_DOWN = 2;

  this.SIGHT_LEFT = 3;

  this.Player = _Player = (function(_super) {
    __extends(_Player, _super);

    function _Player() {
      _ref = _Player.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    _Player.prototype.init = function() {
      this.image = 'images/soldier.png';
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

    _Player.prototype.has_target = function() {
      return this.current_target !== null;
    };

    _Player.prototype.set_target = function(obj) {
      return this.current_target = obj;
    };

    _Player.prototype.clear_current_goal = function() {
      this.current_target = null;
      return this.current_path = null;
    };

    _Player.prototype.get_next_move = function() {
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

    _Player.prototype.find_path_to_target = function(obj) {
      var p, path;
      p = new Path;
      path = p.find_path(this, obj);
      return path;
    };

    _Player.prototype.do_action = function() {
      if (!this.current_target) {
        return this.current_target = g.get_random_target();
      }
    };

    return _Player;

  })(this.MovableGameObject);

}).call(this);
