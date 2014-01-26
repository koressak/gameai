(function() {
  this.Game = (function() {
    function _Class() {
      console.log("Initialization of Game");
    }

    _Class.prototype.init_game = function() {
      this.game_finished = false;
      this.mrender = new window.MapRenderer;
      this.map = this.mrender.render(tile_no_x, tile_no_y);
      this.last_move_time = new Date;
      this.players = new Array;
      this.spawn_new_player();
      this.spawn_new_player();
      return this.update_ui();
    };

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
      if (this.players.length === 0) {
        return good;
      }
      for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = this.players[i];
        if (p.posx === x && p.posy === y) {
          good = false;
        }
      }
      return good;
    };

    _Class.prototype.game_loop = function() {
      var delta, i, now, p, _i, _ref;
      now = new Date;
      delta = now - this.last_move_time;
      if (delta > 300) {
        this.last_move_time = now;
        for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          p = this.players[i];
          p.do_action();
        }
      }
      return this.update_ui();
    };

    _Class.prototype.get_random_target = function() {
      var ind;
      if (this.players.length === 0) {
        return null;
      }
      ind = Math.floor(Math.random() * this.players.length);
      return this.players[ind];
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
          if (this.is_tile_free(posx, posy)) {
            good = true;
            p.set_position(posx, posy);
          }
        }
      }
      this.players.push(p);
      return this.map.add_game_object(p);
    };

    _Class.prototype.update_ui = function() {
      var i, p, _i, _ref, _results;
      stats.html("");
      _results = [];
      for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = this.players[i];
        stats.append("<p><strong>Player " + i + "</strong><br>");
        stats.append("Score: " + p.score + "</p>");
        _results.push(stats.append("Health: " + p.health + "</p><br>"));
      }
      return _results;
    };

    return _Class;

  })();

}).call(this);
