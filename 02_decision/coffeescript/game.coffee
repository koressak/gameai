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
        @spawn_new_player()
        @update_ui()

    get_player: (x) ->
        if x < @players.length
            @players[x]
        else
            null

    get_map: () ->
        @map

    is_tile_free: (x, y) ->
        good = true
        if @players.length == 0
            return good
        for i in [0..@players.length-1]
            p = @players[i] 
            if p.posx == x and p.posy == y
                good = false
        good


    game_loop: () ->
        now = new Date

        delta = now - @last_move_time
        # Player movement
        if delta > 300
            @last_move_time = now
            for i in [0..@players.length-1]
                p = @players[i] 
                p.do_action()

            # ind = Math.floor(Math.random()*100)
            # if ind <= 20
            #     @spawn_new_target()
        @update_ui()


    get_random_target: () ->
        if @players.length == 0
            return null

        ind = Math.floor(Math.random()*@players.length)
        @players[ind]

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
            if @map.is_walkable posx, posy
                if @is_tile_free posx, posy
                    good = true
                    p.set_position posx, posy

        @players.push p
        @map.add_game_object p

    # spawn_new_target: () ->

    #     if @targets.length >= max_targets
    #         return 
            
    #     t = new Target
    #     t.init()
    #     good = false
    #     while not good
    #         posx = get_random_int 0, @map.width-1
    #         posy = get_random_int 0, @map.height-1
    #         if @is_tile_free posx, posy
    #             if @map.is_walkable posx, posy
    #                 good = true
    #                 t.set_position posx, posy

    #     @targets.push t
    #     @map.add_game_object t


    update_ui: () ->
        stats.html("")
        for i in [0..@players.length-1]
            p = @players[i] 
            stats.append("<p><strong>Player "+i+"</strong><br>")
            stats.append("Score: "+p.score+"</p>")
            stats.append("Health: "+p.health+"</p><br>")

