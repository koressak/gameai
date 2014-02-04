@GameObject = class 
    constructor: () ->
        @posx = -1
        @posy = -1
        @image = ''
        @img = null
        @speed = 0

    set_position: (x, y) ->
        @posx = x
        @posy = y

    add_to_game: ->
        map = g.get_map()
        map.add_game_object @

    remove_from_game: ->
        map = g.get_map()
        map.remove_game_object @

    load_image: ->
        if @image != ''
            @img = pinst.loadImage(@image)
        else
            console.error "No image to load"

    draw: () ->
        x = @posx * window.tile_width
        y = @posy * window.tile_height
        pinst.image(@img, x, y, window.tile_width, window.tile_height)


@MovableGameObject = class _MovableGameObject extends @GameObject
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

        if map.is_tile_walkable nposx, nposy
            map.move_game_object @posx, @posy, nposx, nposy
            @posx = nposx
            @posy = nposy
