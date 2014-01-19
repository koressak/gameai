(function() {
  var _this = this;

  this.init_game = function(elid) {
    var el;
    _this.board_width = 150;
    _this.board_height = 150;
    _this.tile_no_x = 5;
    _this.tile_no_y = 5;
    _this.tile_width = 30;
    _this.tile_height = 30;
    _this.rock_count = 1;
    _this.game_objects = new Array;
    el = document.getElementById(elid);
    _this.pinst = new Processing(el, _this.sketchProcess);
    _this.g = new _this.Game;
    return _this.g.init_game();
  };

  this.get_random_int = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

}).call(this);
