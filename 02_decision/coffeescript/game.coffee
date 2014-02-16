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

        for i in [0..max_players-1]
            @spawn_new_player()

    get_player: (x) ->
        if x < @players.length
            @players[x]
        else
            null

    get_map: () ->
        @map

    game_loop: () ->

        # The first player reaching the winning score, game ends
        if @game_finished
            return true

        now = new Date

        delta = now - @last_move_time
        # Player movement
        if delta > frame_step
            @last_move_time = now
            for i in [0..@players.length-1]
                p = @players[i] 
                unless p.state == PSTATE_DEATH
                    p.do_action()
                else
                    p.respawn_timeout -= 1
                    if p.respawn_timeout <= 0
                        @respawn_player p

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
        p.number = @player_counter
        p.name = 'Player ' + (@player_counter++)
        good = false
        while not good
            posx = get_random_int 0, @map.width-1
            posy = get_random_int 0, @map.height-1
            if @map.is_tile_walkable posx, posy
                if @map.is_tile_free posx, posy
                    good = true
                    p.set_position posx, posy
                    # @map.set_tile_explored posx, posy

        @players.push p
        @scope.new_event "primary", p.name + " has been spawned"
        @map.add_game_object p

    respawn_player: (pl) ->
        pl.set_initial_state()
        good = false
        while not good
            posx = get_random_int 0, @map.width-1
            posy = get_random_int 0, @map.height-1
            if @map.is_tile_walkable posx, posy
                if @map.is_tile_free posx, posy
                    good = true
                    pl.set_position posx, posy

        @scope.new_event "default", pl.name + " has been respawned"
        @map.add_game_object pl


    spawn_powerup: () ->

        type = get_random_int 0, 3
        if type == 0
            p = new HealthPowerUp
        else if type == 1
            p = new FirepowerPowerUp 
        else if type == 2
            p = new ArmorPowerUp 
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
        # @players.splice(ind, 1)
        @scope.new_event "danger", pl.name + " died"

        # Set respawn timeout - from 10 to 20 timeframes
        pl.state = PSTATE_DEATH
        pl.respawn_timeout = get_random_int 10, 20
        @scope.new_event "default", pl.name + " will respawn in " + pl.respawn_timeout

        # @spawn_new_player()

    player_won: (pl) ->
        # Player has reached the winning score
        @game_finished = true
        @scope.new_event "success", pl.name + " has won the game!!!"
        @scope.is_game_running = false

