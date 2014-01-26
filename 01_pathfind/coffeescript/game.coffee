#
# Main Game class handling the game dynamics
# 
@Game = class
    constructor: ->
        console.log "Initialization of Game"

    get_player: (x) ->
        if x < @players.length
            @players[x]
        else
            null

    get_map: () ->
        @map

    is_tile_free: (x, y) ->
        good = true
        for i in [0..@players.length-1]
            p = @players[i] 
            if p.posx == x and p.posy == y
                good = false

        good


    init_game: ->
        @game_finished = false
        @mrender = new window.MapRenderer
        @map = @mrender.render tile_no_x, tile_no_y

        @last_move_time = new Date

        game_objects.push(@map)

        @players = new Array
        @targets = new Array

        @spawn_new_player()
        @spawn_new_target()
        @update_ui()

    remove_game_object: (obj) ->
        ind = $.inArray(obj, game_objects)
        if ind != -1
            game_objects.splice(ind, 1)


    game_loop: () ->
        @check_got_chest()
        now = new Date

        delta = now - @last_move_time
        # Player movement
        if delta > 300
            @last_move_time = now
            for i in [0..@players.length-1]
                p = @players[i] 

                unless p.has_target()
                    p.set_target @get_random_target()

                [newx, newy] = p.get_next_move()
                p.move newx, newy

            ind = Math.floor(Math.random()*100)
            if ind <= 20
                @spawn_new_target()



    get_random_target: () ->
        if @targets.length == 0
            return null

        ind = Math.floor(Math.random()*@targets.length)
        @targets[ind]

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
                good = true
                p.set_position posx, posy

        @players.push p
        game_objects.push p

    spawn_new_target: () ->

        if @targets.length >= max_targets
            return 
            
        t = new Target
        t.init()
        good = false
        while not good
            posx = get_random_int 0, @map.width-1
            posy = get_random_int 0, @map.height-1
            if @is_tile_free posx, posy
                if @map.is_walkable posx, posy
                    good = true
                    t.set_position posx, posy

        @targets.push t
        game_objects.push t


    check_got_chest: () ->
        for i in [0..@players.length-1]
            p = @players[i] 
            for u in [0..@targets.length-1]
                t = @targets[u]
                if p.posx == t.posx and p.posy == t.posy
                    p.score += 1
                    p.clear_current_goal()
                    @remove_game_object(t)
                    @targets.splice(u, 1)
                    @spawn_new_target()
                    @spawn_new_player()
                    @update_ui()

    update_ui: () ->
        scores.html("")
        for i in [0..@players.length-1]
            p = @players[i] 
            scores.append("<p><strong>Player "+i+"</strong><br>")
            scores.append("Score: "+p.score+"</p>")

