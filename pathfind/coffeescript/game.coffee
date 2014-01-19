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
        # Instantiate player object and place him randomly on screen
        # Only on walkable tile
        p1 = new Player
        p1.init()
        good = false
        while not good
            posx = get_random_int 0, @map.width-1
            posy = get_random_int 0, @map.height-1
            if @map.is_walkable posx, posy
                good = true
                p1.set_position posx, posy

        @players.push p1
        game_objects.push p1

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

        @target = t
        game_objects.push t

    remove_game_object: (obj) ->
        ind = $.inArray(obj, game_objects)
        if ind != -1
            game_objects.splice(ind, 1)


    game_loop: () ->
        if @check_got_chest()
            @remove_game_object(@target)
            @game_finished = true
        else
            now = new Date

            delta = now - @last_move_time

            if delta > 300
                @last_move_time = now
                for i in [0..@players.length-1]
                    p = @players[i] 
                    [newx, newy] = p.find_next_move @target.posx, @target.posy
                    p.move newx, newy


    check_got_chest: () ->
        got_chest = false

        for i in [0..@players.length-1]
            p = @players[i] 
            if p.posx == @target.posx and p.posy == @target.posy
                good = true

        good
