(function() {
  var _this = this;

  this.init_game = function(elid) {
    var el;
    _this.board_width = 630;
    _this.board_height = 630;
    _this.tile_no_x = 21;
    _this.tile_no_y = 21;
    _this.tile_width = 30;
    _this.tile_height = 30;
    _this.rock_count = 25;
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
