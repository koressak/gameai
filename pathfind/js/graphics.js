(function() {
  this.sketchProcess = function(processing) {
    var p;
    p = processing;
    processing.setup = function() {
      p.size(window.board_width, window.board_height);
      p.background(200);
      return window.game_objects = new Array();
    };
    return processing.draw = function() {
      var o, objects, _i, _len, _results;
      objects = window.game_objects;
      _results = [];
      for (_i = 0, _len = objects.length; _i < _len; _i++) {
        o = objects[_i];
        _results.push(o.draw());
      }
      return _results;
    };
  };

}).call(this);
