@init_game = (elid) =>
    # Base game definitions
    @board_width = 630
    @board_height = 630
    @tile_no_x = 21
    @tile_no_y = 21
    @tile_width = 30
    @tile_height = 30
    @rock_count = 100

    @powerup_spawn_percent = 15

    @max_players = 5
    @max_targets = 5

    @stats = $("#gamestats")

    # @board_width = 150
    # @board_height = 150
    # @tile_no_x = 5
    # @tile_no_y = 5
    # @tile_width = 30
    # @tile_height = 30
    # @rock_count = 1

    # Init visualisation
    el = document.getElementById elid
    @pinst = new Processing(el, @sketchProcess)

    # Initialize and run game
    @g = new @Game
    @g.init_game()

@get_random_int = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min;
