@Player = class
    init: ->
        @image = null
        @posx = 0
        @posy = 0
        @load_image()

    set_position: (x, y) ->
        @posx = x
        @posy = y

    move: (x, y) ->
        # Move in positive or negative direction
        map = g.get_map()
        nposx = @posx
        nposy = @posy

        if x > 0
            nposx += 1
        else if x < 0
            nposx -=1

        if y > 0
            nposy += 1
        else if y < 0
            nposy -=1

        if map.is_walkable nposx, nposy
            @posx = nposx
            @posy = nposy

    load_image: ->
        @image = pinst.loadImage('images/soldier.png')

    draw: () ->
        x = @posx * tile_width
        y = @posy * tile_height
        window.pinst.image(@image, x, y, tile_width, tile_height)


@Target = class
    init: ->
        @image = null
        @posx = 0
        @posy = 0
        @load_image()

    load_image: ->
        @image = pinst.loadImage('images/chest.png')

    set_position: (x, y) ->
        @posx = x
        @posy = y

    draw: () ->
        x = @posx * tile_width
        y = @posy * tile_height
        window.pinst.image(@image, x, y, tile_width, tile_height)

