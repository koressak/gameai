(function() {
  var _Player, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.SIGHT_UP = 0;

  this.SIGHT_RIGHT = 1;

  this.SIGHT_DOWN = 2;

  this.SIGHT_LEFT = 3;

  this.PSTATE_EXPLORE = 0;

  this.PSTATE_ATTACK = 1;

  this.Player = _Player = (function(_super) {
    __extends(_Player, _super);

    function _Player() {
      _ref = _Player.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    _Player.prototype.init = function() {
      var dbuilder, i, u, _i, _j, _ref1, _ref2;
      this.image = 'images/soldier.png';
      this.load_image();
      this.score = 0;
      dbuilder = new DecisionBuilder;
      this.decision = dbuilder.generate_tree();
      this.health = 100;
      this.damage = 5;
      this.speed = 1;
      this.sight_radius = 2;
      this.direction = SIGHT_LEFT;
      this.map = g.get_map();
      this.explored_tiles = new Array(this.map.width);
      for (i = _i = 0, _ref1 = this.map.width - 1; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
        this.explored_tiles[i] = new Array(this.map.height);
        for (u = _j = 0, _ref2 = this.map.height - 1; 0 <= _ref2 ? _j <= _ref2 : _j >= _ref2; u = 0 <= _ref2 ? ++_j : --_j) {
          this.explored_tiles[i][u] = false;
        }
      }
      this.state = PSTATE_EXPLORE;
      this.current_action = null;
      this.current_goal = null;
      this.current_path = null;
      this.seeable_objects = new Array;
      return this.active_bonuses = new Array;
    };

    _Player.prototype.set_state = function(state) {
      return this.state = state;
    };

    _Player.prototype.get_next_move = function() {
      var step;
      step = this.current_path.splice(0, 1);
      if (step.length > 0) {
        this.explored_tiles[step[0].posx][step[0].posy] = true;
        return [step[0].posx - this.posx, step[0].posy - this.posy];
      } else {
        this.current_path = null;
      }
      return [0, 0];
    };

    _Player.prototype.find_path_to_target = function(obj) {
      var p, path;
      p = new Path;
      path = p.find_path(this, obj);
      return path;
    };

    _Player.prototype.process_bonuses = function() {
      var i, new_bonuses, o, _i, _ref1;
      new_bonuses = new Array;
      if (this.active_bonuses.length > 0) {
        for (i = _i = 0, _ref1 = this.active_bonuses.length - 1; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
          console.log(i);
          o = this.active_bonuses[i];
          o.timeout -= 1;
          if (o.timeout === 0) {
            o.do_timeout(this);
          } else {
            new_bonuses.push(o);
          }
        }
      }
      return this.active_bonuses = new_bonuses;
    };

    _Player.prototype.is_acting = function() {
      return this.current_action !== null;
    };

    _Player.prototype.has_goal = function() {
      return this.current_goal !== null;
    };

    _Player.prototype.get_goal = function() {
      return 1;
    };

    _Player.prototype.set_goal = function(obj) {
      this.current_path = null;
      return this.current_goal = obj;
    };

    _Player.prototype.clear_current_goal = function() {
      this.current_goal = null;
      return this.current_path = null;
    };

    _Player.prototype.can_see_object = function() {
      var i, o, tiles, _i, _ref1;
      this.seeable_objects = new Array;
      tiles = this.map.get_adjacent_tiles(this.posx, this.posy);
      for (i = _i = 0, _ref1 = tiles.length - 1; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
        o = tiles[i].get_object();
        if (o !== null) {
          this.seeable_objects.push(o);
        }
      }
      console.log("Seeable objects", this.seeable_objects);
      console.log("Result", this.seeable_objects.length);
      return this.seeable_objects.length !== 0;
    };

    _Player.prototype.is_object_consumable = function() {
      var obj;
      obj = this.seeable_objects[0];
      return obj instanceof PowerUp;
    };

    _Player.prototype.pick_random_unexplored_tile = function() {
      var good, x, y;
      good = false;
      while (!good) {
        x = get_random_int(0, this.map.width - 1);
        y = get_random_int(0, this.map.height - 1);
        if (!this.explored_tiles[x][y]) {
          if (this.map.is_tile_walkable(x, y)) {
            return [x, y];
          }
        }
      }
    };

    _Player.prototype.explore = function() {
      var nx, ny, tile, x, y, _ref1, _ref2;
      if (this.current_path === null) {
        _ref1 = this.pick_random_unexplored_tile(), x = _ref1[0], y = _ref1[1];
        console.log("New target");
        console.log(x, y);
        tile = this.map.tiles[x][y];
        this.current_path = this.find_path_to_target(tile);
        if (!this.current_path) {
          throw "No feasible path found, cannot move further :(";
        }
      }
      _ref2 = this.get_next_move(), nx = _ref2[0], ny = _ref2[1];
      return this.move(nx, ny);
    };

    _Player.prototype.consume_object = function() {
      var obj;
      obj = this.seeable_objects.splice(0, 1)[0];
      obj.consume(this);
      return this.move(obj.posx - this.posx, obj.posy - this.posy);
    };

    _Player.prototype.do_action = function() {
      var node;
      this.process_bonuses();
      node = this.decision.make_decision(this);
      console.log('Current decision node');
      console.log(node);
      if (node !== null) {
        this.current_action = node.action;
        return this[this.current_action]();
      } else {
        return console.log("We have no action to take. Returned node is null");
      }
    };

    return _Player;

  })(this.MovableGameObject);

}).call(this);
