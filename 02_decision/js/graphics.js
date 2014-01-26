(function() {
  this.sketchProcess = function(processing) {
    var f, p, running;
    p = processing;
    f = p.loadFont('Arial');
    running = true;
    processing.setup = function() {
      p.size(window.board_width, window.board_height);
      p.background(200);
      return window.game_objects = new Array();
    };
    processing.draw = function() {
      var centerx, centery, map;
      if (!g.game_finished) {
        g.game_loop();
        map = g.get_map();
        return map.draw();
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
      if (p.keyCode === 32) {
        running = !running;
        if (running) {
          return p.loop();
        } else {
          return p.noLoop();
        }
      }
    };
  };

}).call(this);