@TERRAIN_GRASS = 'grass'
@TERRAIN_ROCK = 'rock'

@MapTile = class
    init: (walk, terrain, x, y) ->
        @walkable = walk 
        @terrain = terrain
        @posx = x
        @posy = y
        @object = null
        @explored = false
        @unexplored_image = null

    load_image: ->
        switch @terrain
            when window.TERRAIN_GRASS
                @image = pinst.loadImage('images/grass.png')
            when window.TERRAIN_ROCK
                @image = pinst.loadImage('images/rock.png')

        @unexplored_image = pinst.loadImage('images/unexplored.png')

    set_object: (obj) ->
        @object = obj

    get_object: ->
        @object

    remove_object: ->
        o = @object
        @object = null
        o

    draw: () ->
        x = @posx * tile_width
        y = @posy * tile_height
        window.pinst.image(@image, x, y, tile_width, tile_height)
        if not @explored
            window.pinst.image(@unexplored_image, x, y, tile_width, tile_height)

        if @object != null
            @object.draw()



@Map = class
    constructor: ->
        console.log "Initializing Map"

    init: (w, h) ->
        @width = w
        @height = h
        @tiles = new Array(w)
        @game_objects = new Array
        for i in [0..w-1]
            @tiles[i] = new Array(h)

    add_tile: (x, y, tile) ->
        @tiles[x][y] = tile

    add_game_object: (obj) ->
        if $.inArray obj, @game_objects == -1
            @game_objects.push obj
            @tiles[obj.posx][obj.posy].set_object obj

    move_game_object: (ox, oy, nx, ny) ->
        # Set tile explored if someone is moving to it
        @set_tile_explored nx, ny
        o = @tiles[ox][oy].remove_object()
        if o != null
            @tiles[nx][ny].set_object o

    remove_game_object: (obj) ->
        ind =  $.inArray obj, @game_objects

        if ind != -1
            o = @game_objects[ind]
            @tiles[o.posx][o.posy].remove_object()
            @game_objects.splice ind, 1

    is_tile_walkable: (x, y) ->
        if x < 0 or x > @width-1
            return false
        if y < 0 or y > @height-1
            return false

        t = @tiles[x][y]
        t.walkable

    is_tile_free: (x, y) ->
        if x < 0 or x > @width-1
            return false
        if y < 0 or y > @height-1
            return false

        @tiles[x][y].get_object() == null

    get_tile_object: (x, y) ->
        if x < 0 or x > @width-1
            return null
        if y < 0 or y > @height-1
            return null 

        @tiles[x][y].get_object()

    set_tile_explored: (x, y) ->
        @tiles[x][y].explored = true

    get_adjacent_tiles: (x, y) ->
        tiles = new Array
        if x-1 >= 0 and @is_tile_walkable x-1, y
            tiles.push @tiles[x-1][y]
        if x+1 <= @width-1 and @is_tile_walkable x+1, y
            tiles.push @tiles[x+1][y]

        if y-1 >= 0 and @is_tile_walkable x, y-1
            tiles.push @tiles[x][y-1]
        if y+1 <= @height-1 and @is_tile_walkable x, y+1
            tiles.push @tiles[x][y+1]

        return tiles

    draw: () =>
        for x in [0..@width-1]
            for y in [0..@height-1]
                @tiles[x][y].draw()

        # for obj in @game_objects
        #     obj.draw()



@MapRenderer = class
    constructor: ->
        console.log "Initializing MapRenderer"

    render: (w, h) ->
        map = new window.Map
        map.init(w, h)

        for x in [0..w-1]
            for y in [0..h-1]
                t = new window.MapTile
                t.init true, TERRAIN_GRASS, x, y
                map.add_tile x, y, t

        rock_no = window.rock_count
        for x in [1..rock_no]
            posx = get_random_int 0, w-1
            posy = get_random_int 0, h-1
            t = map.tiles[posx][posy]
            t.walkable = false
            t.terrain = TERRAIN_ROCK

        for x in [0..w-1]
            for y in [0..h-1]
                map.tiles[x][y].load_image()

        map
