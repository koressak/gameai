#
# Main Game class handling the game dynamics
# 
@Game = class
    constructor: ->
        console.log "Initialization of Game"

    init_game: (scope) ->
        @game_finished = false
        @mrender = new window.MapRenderer
        @map = @mrender.render tile_no_x, tile_no_y
        @scope = scope
        @player_counter = 0

        @last_move_time = new Date
        @players = new Array

        @spawn_new_player()
        @spawn_new_player()


    get_player: (x) ->
        if x < @players.length
            @players[x]
        else
            null

    get_map: () ->
        @map

    game_loop: () ->
        now = new Date

        delta = now - @last_move_time
        # Player movement
        if delta > frame_step
            @last_move_time = now
            for i in [0..@players.length-1]
                p = @players[i] 
                p.do_action()

            ind = Math.floor(Math.random()*100)
            if ind <= powerup_spawn_percent
                @spawn_powerup()
            @scope.update_ui()


    spawn_new_player: () ->
        # Instantiate player object and place him randomly on screen
        # Only on walkable tile
        if @players.length >= max_players
            return

        p = new Player
        p.init()
        p.name = 'Player ' + (@player_counter++)
        good = false
        while not good
            posx = get_random_int 0, @map.width-1
            posy = get_random_int 0, @map.height-1
            if @map.is_tile_walkable posx, posy
                if @map.is_tile_free posx, posy
                    good = true
                    p.set_position posx, posy
                    @map.set_tile_explored posx, posy

        @players.push p
        @map.add_game_object p

    spawn_powerup: () ->

        type = get_random_int 0, 1
        if type == 0
            p = new HealthPowerUp
        else
            p = new SpeedPowerUp

        p.init()
        good = false
        while not good
            posx = get_random_int 0, @map.width-1
            posy = get_random_int 0, @map.height-1
            if @map.is_tile_free posx, posy
                if @map.is_tile_walkable posx, posy
                    if @map.get_tile_object(posx, posy) == null
                        good = true
                        p.set_position posx, posy

        p.add_to_game()

    player_death: (pl) ->
        ind = $.inArray(pl, @players)
        @map.remove_game_object pl
        @players.splice(ind, 1)
        @scope.new_event "warning", pl.name + " died"

        @spawn_new_player()

