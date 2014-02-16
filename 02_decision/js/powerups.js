// Generated by CoffeeScript 1.6.3
(function() {
  var _ArmorPowerUp, _FirepowerPowerUp, _HealthPowerUp, _PowerUp, _SpeedPowerUp, _ref, _ref1, _ref2, _ref3, _ref4,
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

    _PowerUp.prototype.consume = function(player) {
      player[this.type] += this.bonus;
      console.log("Removing powerup from game", this);
      return this.remove_from_game();
    };

    _PowerUp.prototype.pre_consume = function(player) {
      return 1;
    };

    _PowerUp.prototype.post_consume = function(player) {
      return 1;
    };

    _PowerUp.prototype.do_timeout = function() {
      return true;
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
      this.timeout = 5;
      this.type = 'speed';
      this.image = 'images/powerups/speed.png';
      return this.load_image();
    };

    _SpeedPowerUp.prototype.consume = function(player) {
      player[this.type] += this.bonus;
      player.active_bonuses.push(this);
      console.log("Removing powerup from game", this);
      return this.remove_from_game();
    };

    _SpeedPowerUp.prototype.do_timeout = function(player) {
      player[this.type] -= this.bonus;
      return console.log("Bonus timeout", this);
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
      this.timeout = 0;
      this.type = 'health';
      this.image = 'images/powerups/health.png';
      return this.load_image();
    };

    _HealthPowerUp.prototype.post_consume = function(player) {
      if (player[this.type] > MAX_HEALTH) {
        return player[this.type] = MAX_HEALTH;
      }
    };

    return _HealthPowerUp;

  })(this.PowerUp);

  this.FirepowerPowerUp = _FirepowerPowerUp = (function(_super) {
    __extends(_FirepowerPowerUp, _super);

    function _FirepowerPowerUp() {
      _ref3 = _FirepowerPowerUp.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    _FirepowerPowerUp.prototype.init = function() {
      this.bonus = 2;
      this.timeout = 0;
      this.type = 'damage';
      this.image = 'images/powerups/firepower.png';
      return this.load_image();
    };

    return _FirepowerPowerUp;

  })(this.PowerUp);

  this.ArmorPowerUp = _ArmorPowerUp = (function(_super) {
    __extends(_ArmorPowerUp, _super);

    function _ArmorPowerUp() {
      _ref4 = _ArmorPowerUp.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    _ArmorPowerUp.prototype.init = function() {
      this.bonus = 5;
      this.timeout = 0;
      this.type = 'armor';
      this.image = 'images/powerups/defend.png';
      return this.load_image();
    };

    return _ArmorPowerUp;

  })(this.PowerUp);

}).call(this);
