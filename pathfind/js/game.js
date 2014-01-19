(function() {
  this.Game = (function() {
    function _Class() {
      console.log("Initialization of Game");
    }

    _Class.prototype.get_player = function(x) {
      if (x < this.players.length) {
        return this.players[x];
      } else {
        return null;
      }
    };

    _Class.prototype.get_map = function() {
      return this.map;
    };

    _Class.prototype.is_tile_free = function(x, y) {
      var good, i, p, _i, _ref;
      good = true;
      for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = this.players[i];
        if (p.posx === x && p.posy === y) {
          good = false;
        }
      }
      return good;
    };

    _Class.prototype.init_game = function() {
      var good, p1, posx, posy, t;
      this.game_finished = false;
      this.mrender = new window.MapRenderer;
      this.map = this.mrender.render(tile_no_x, tile_no_y);
      this.last_move_time = new Date;
      game_objects.push(this.map);
      this.players = new Array;
      p1 = new Player;
      p1.init();
      good = false;
      while (!good) {
        posx = get_random_int(0, this.map.width - 1);
        posy = get_random_int(0, this.map.height - 1);
        if (this.map.is_walkable(posx, posy)) {
          good = true;
          p1.set_position(posx, posy);
        }
      }
      this.players.push(p1);
      game_objects.push(p1);
      t = new Target;
      t.init();
      good = false;
      while (!good) {
        posx = get_random_int(0, this.map.width - 1);
        posy = get_random_int(0, this.map.height - 1);
        if (this.is_tile_free(posx, posy)) {
          if (this.map.is_walkable(posx, posy)) {
            good = true;
            t.set_position(posx, posy);
          }
        }
      }
      this.target = t;
      return game_objects.push(t);
    };

    _Class.prototype.remove_game_object = function(obj) {
      var ind;
      ind = $.inArray(obj, game_objects);
      if (ind !== -1) {
        return game_objects.splice(ind, 1);
      }
    };

    _Class.prototype.game_loop = function() {
      var delta, i, newx, newy, now, p, _i, _ref, _ref1, _results;
      if (this.check_got_chest()) {
        this.remove_game_object(this.target);
        return this.game_finished = true;
      } else {
        now = new Date;
        delta = now - this.last_move_time;
        if (delta > 300) {
          this.last_move_time = now;
          _results = [];
          for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
            p = this.players[i];
            _ref1 = p.find_next_move(this.target.posx, this.target.posy), newx = _ref1[0], newy = _ref1[1];
            _results.push(p.move(newx, newy));
          }
          return _results;
        }
      }
    };

    _Class.prototype.check_got_chest = function() {
      var good, got_chest, i, p, _i, _ref;
      got_chest = false;
      for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = this.players[i];
        if (p.posx === this.target.posx && p.posy === this.target.posy) {
          good = true;
        }
      }
      return good;
    };

    return _Class;

  })();

}).call(this);
