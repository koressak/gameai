#
# Main Game class handling the game dynamics
# 
@Game = class
    constructor: ->
        console.log "Initialization of Game"

    init_game: ->
        @game_finished = false
        @mrender = new window.MapRenderer
        @map = @mrender.render tile_no_x, tile_no_y

        @last_move_time = new Date
        @players = new Array

        @spawn_new_player()
        # @spawn_new_player()
        @update_ui()


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
        if delta > 300
            @last_move_time = now
            for i in [0..@players.length-1]
                p = @players[i] 
                p.do_action()

            ind = Math.floor(Math.random()*100)
            if ind <= 5
                @spawn_powerup()
        @update_ui()


    spawn_new_player: () ->
        # Instantiate player object and place him randomly on screen
        # Only on walkable tile
        if @players.length >= max_players
            return

        p = new Player
        p.init()
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


    update_ui: () ->
        stats.html("")
        for i in [0..@players.length-1]
            p = @players[i] 
            stats.append("<p><strong>Player "+(i+1)+"</strong><br>")
            stats.append("Score: "+p.score+"<br>")
            stats.append("Health: "+p.health+"<br>")
            stats.append("Speed: "+p.speed+"<br>")
            stats.append("</p><br>")

