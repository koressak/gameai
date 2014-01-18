@init_game = (elid) =>
    # Base game definitions
    @board_width = 630
    @board_height = 630
    @tile_no_x = 21
    @tile_no_y = 21
    @tile_width = 30
    @tile_height = 30
    @rock_count = 25

    # Init visualisation
    @game_objects = new Array
    el = document.getElementById elid
    @pinst = new Processing(el, @sketchProcess)

    # Initialize and run game
    @g = new @Game
    @g.init_game()

@get_random_int = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min;
