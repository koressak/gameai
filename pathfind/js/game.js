(function() {
  this.Game = (function() {
    function _Class() {
      console.log("Initialization of Game");
    }

    _Class.prototype.init_game = function() {
      this.mrender = new window.MapRenderer;
      this.map = this.mrender.render(tile_no_x, tile_no_y);
      return window.game_objects.push(this.map);
    };

    return _Class;

  })();

}).call(this);
