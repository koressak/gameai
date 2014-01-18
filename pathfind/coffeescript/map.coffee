@TERRAIN_GRASS = 'grass'
@TERRAIN_ROCK = 'rock'

@MapTile = class
    init: (walk, terrain, x, y) ->
        @walkable = walk 
        @terrain = terrain
        @x = x
        @y = y
        @width = window.tile_width
        @width = window.tile_height

    load_image: ->
        switch @terrain
            when window.TERRAIN_GRASS
                @image = window.pinst.loadImage('images/grass.png')
            when window.TERRAIN_ROCK
                @image = window.pinst.loadImage('images/rock.png')


    draw: () ->
        window.pinst.image(@image, @x, @y, @width, @height)



@Map = class
    constructor: ->
        console.log "Initializing Map"

    init: (w, h) ->
        @width = w
        @height = h
        @tiles = new Array(w)
        for i in [0..w-1]
            @tiles[i] = new Array(h)

    add_tile: (x, y, tile) ->
        @tiles[x][y] = tile

    draw: () =>
        for x in [0..@width-1]
            for y in [0..@height-1]
                @tiles[x][y].draw()



@MapRenderer = class
    constructor: ->
        console.log "Initializing MapRenderer"

    render: (w, h) ->
        map = new window.Map
        map.init(w, h)

        for x in [0..w-1]
            for y in [0..h-1]
                t = new window.MapTile
                posx = x * tile_width
                posy = y * tile_height
                t.init true, TERRAIN_GRASS, posx, posy
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
