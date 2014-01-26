(function() {
  this.Game = (function() {
    function _Class() {
      console.log("Initialization of Game");
    }

    _Class.prototype.init_game = function() {
      var build;
      build = new DecisionBuilder;
      console.log(build.generate_tree());
      this.game_finished = false;
      this.mrender = new window.MapRenderer;
      this.map = this.mrender.render(tile_no_x, tile_no_y);
      this.last_move_time = new Date;
      this.players = new Array;
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

    _Class.prototype.game_loop = function() {
      var delta, i, ind, now, p, _i, _ref;
      now = new Date;
      delta = now - this.last_move_time;
      if (delta > 300) {
        this.last_move_time = now;
        for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          p = this.players[i];
          p.do_action();
        }
        ind = Math.floor(Math.random() * 100);
        if (ind <= 5) {
          this.spawn_powerup();
        }
      }
      return this.update_ui();
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
          if (this.map.is_tile_free(posx, posy)) {
            good = true;
            p.set_position(posx, posy);
          }
        }
      }
      this.players.push(p);
      return this.map.add_game_object(p);
    };

    _Class.prototype.spawn_powerup = function() {
      var good, p, posx, posy, type;
      type = get_random_int(0, 1);
      if (type === 0) {
        p = new HealthPowerUp;
      } else {
        p = new SpeedPowerUp;
      }
      p.init();
      good = false;
      while (!good) {
        posx = get_random_int(0, this.map.width - 1);
        posy = get_random_int(0, this.map.height - 1);
        if (this.is_tile_free(posx, posy)) {
          if (this.map.is_walkable(posx, posy)) {
            if (this.map.is_tile_free(posx, posy)) {
              good = true;
              p.set_position(posx, posy);
            }
          }
        }
      }
      return p.add_to_game();
    };

    _Class.prototype.update_ui = function() {
      var i, p, _i, _ref, _results;
      stats.html("");
      _results = [];
      for (i = _i = 0, _ref = this.players.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = this.players[i];
        stats.append("<p><strong>Player " + (i + 1) + "</strong><br>");
        stats.append("Score: " + p.score + "<br>");
        stats.append("Health: " + p.health + "<br>");
        stats.append("Speed: " + p.speed + "<br>");
        _results.push(stats.append("</p><br>"));
      }
      return _results;
    };

    return _Class;

  })();

}).call(this);
