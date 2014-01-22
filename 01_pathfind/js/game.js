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
      this.game_finished = false;
      this.mrender = new window.MapRenderer;
      this.map = this.mrender.render(tile_no_x, tile_no_y);
      this.last_move_time = new Date;
      game_objects.push(this.map);
      this.players = new Array;
      this.targets = new Array;
      this.spawn_new_player();
      this.spawn_new_target();
      return this.update_ui();
    };

    _Class.prototype.remove_game_object = function(obj) {
      var ind;
      ind = $.inArray(obj, game_objects);
      if (ind !== -1) {
        return game_objects.splice(ind, 1);
      }
    };

    _Class.prototype.game_loop = function() {
      var delta, i, ind, newx, newy, now, p, _i, _ref, _ref1;
      this.check_got_chest();
      now = new Date;
      delta = now - this.last_move_time;
      if (delta > 300) {
        this.last_move_time = now;
        for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          p = this.players[i];
          if (!p.has_target()) {
            p.set_target(this.get_random_target());
          }
          _ref1 = p.get_next_move(), newx = _ref1[0], newy = _ref1[1];
          p.move(newx, newy);
        }
        ind = Math.floor(Math.random() * 100);
        if (ind <= 20) {
          return this.spawn_new_target();
        }
      }
    };

    _Class.prototype.get_random_target = function() {
      var ind;
      if (this.targets.length === 0) {
        return null;
      }
      ind = Math.floor(Math.random() * this.targets.length);
      return this.targets[ind];
    };

    _Class.prototype.spawn_new_player = function() {
      var good, p, posx, posy;
      if (this.players.length >= max_players) {
        return;
      }
      p = new Player;
      p.init();
      good = false;
      while (!good) {
        posx = get_random_int(0, this.map.width - 1);
        posy = get_random_int(0, this.map.height - 1);
        if (this.map.is_walkable(posx, posy)) {
          good = true;
          p.set_position(posx, posy);
        }
      }
      this.players.push(p);
      return game_objects.push(p);
    };

    _Class.prototype.spawn_new_target = function() {
      var good, posx, posy, t;
      if (this.targets.length >= max_targets) {
        return;
      }
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
      this.targets.push(t);
      return game_objects.push(t);
    };

    _Class.prototype.check_got_chest = function() {
      var i, p, t, u, _i, _ref, _results;
      _results = [];
      for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = this.players[i];
        _results.push((function() {
          var _j, _ref1, _results1;
          _results1 = [];
          for (u = _j = 0, _ref1 = this.targets.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; u = 0 <= _ref1 ? ++_j : --_j) {
            t = this.targets[u];
            if (p.posx === t.posx && p.posy === t.posy) {
              p.score += 1;
              p.clear_current_goal();
              this.remove_game_object(t);
              this.targets.splice(u, 1);
              this.spawn_new_target();
              this.spawn_new_player();
              _results1.push(this.update_ui());
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    _Class.prototype.update_ui = function() {
      var i, p, _i, _ref, _results;
      scores.html("");
      _results = [];
      for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = this.players[i];
        scores.append("<p><strong>Player " + i + "</strong><br>");
        _results.push(scores.append("Score: " + p.score + "</p>"));
      }
      return _results;
    };

    return _Class;

  })();

}).call(this);
