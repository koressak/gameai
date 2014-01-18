(function() {
  this.sketchProcess = function(processing) {
    var f, p;
    p = processing;
    f = p.loadFont('Arial');
    processing.setup = function() {
      p.size(window.board_width, window.board_height);
      p.background(200);
      return window.game_objects = new Array();
    };
    processing.draw = function() {
      var centerx, centery, map, o, objects, _i, _len, _results;
      if (!g.game_finished) {
        g.game_loop();
        objects = window.game_objects;
        _results = [];
        for (_i = 0, _len = objects.length; _i < _len; _i++) {
          o = objects[_i];
          _results.push(o.draw());
        }
        return _results;
      } else {
        p.textFont(f, 40);
        map = g.get_map();
        centerx = Math.floor((map.width * tile_width) / 2);
        centery = Math.floor((map.height * tile_height) / 2);
        p.textAlign(p.CENTER);
        return p.text("GAME WON", centerx, centery);
      }
    };
    return processing.keyPressed = function() {
      var player;
      player = g.get_player(0);
      if (p.key.code === p.CODED) {
        if (p.keyCode === p.UP) {
          return player.move(0, -1);
        } else if (p.keyCode === p.DOWN) {
          return player.move(0, 1);
        } else if (p.keyCode === p.LEFT) {
          return player.move(-1, 0);
        } else if (p.keyCode === p.RIGHT) {
          return player.move(1, 0);
        }
      }
    };
  };

}).call(this);
