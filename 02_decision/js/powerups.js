(function() {
  var _HealthPowerUp, _PowerUp, _SpeedPowerUp, _ref, _ref1, _ref2,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.PowerUp = _PowerUp = (function(_super) {
    __extends(_PowerUp, _super);

    function _PowerUp() {
      _ref = _PowerUp.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    _PowerUp.prototype.init = function() {
      this.bonus = 0;
      this.timeout = 0;
      return this.type = '';
    };

    _PowerUp.prototype.pick_up = function(player) {
      if (this.type !== '') {
        player.add_bonus(this);
        return this.remove_from_game();
      }
    };

    return _PowerUp;

  })(this.GameObject);

  this.SpeedPowerUp = _SpeedPowerUp = (function(_super) {
    __extends(_SpeedPowerUp, _super);

    function _SpeedPowerUp() {
      _ref1 = _SpeedPowerUp.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    _SpeedPowerUp.prototype.init = function() {
      this.bonus = 1;
      this.timeout = 20;
      this.type = 'speed';
      this.image = 'images/powerups/speed.png';
      return this.load_image();
    };

    return _SpeedPowerUp;

  })(this.PowerUp);

  this.HealthPowerUp = _HealthPowerUp = (function(_super) {
    __extends(_HealthPowerUp, _super);

    function _HealthPowerUp() {
      _ref2 = _HealthPowerUp.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    _HealthPowerUp.prototype.init = function() {
      this.bonus = 20;
      this.timeout = 1;
      this.type = 'health';
      this.image = 'images/powerups/health.png';
      return this.load_image();
    };

    return _HealthPowerUp;

  })(this.PowerUp);

}).call(this);
