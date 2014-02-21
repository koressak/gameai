@Animation = class _Animation
    constructor: (image, steps_duration) ->
        @parent = null
        @frames = 0
        @img = pinst.loadImage(image)
        @steps_duration = steps_duration

    draw: ->
        # Draw an animation on parent position
        if @parent != null
            x = @parent.posx * window.tile_width
            y = @parent.posy * window.tile_height
            pinst.image(@img, x, y, window.tile_width, window.tile_height)

    frame: ->
        # When frame happens, lower the duration steps
        # If there is no more duration steps.. remove from game
        @steps_duration -= 1
        if @steps_duration == 0
            @parent.remove_animation()


@GameObject = class 
    constructor: () ->
        @posx = -1
        @posy = -1
        @image = ''
        @img = null
        @speed = 0
        @pr = pinst
        @font = @pr.loadFont('Arial')
        @animation = null

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

    add_animation: (anim) ->
        if anim != null
            @animation = anim
            @animation.parent = @

    remove_animation: ->
        @animation = null

    frame: ->
        # Method to signalize, that a frame has passed
        # anything that is dependent on a frame, takes place here
        if @animation != null
            @animation.frame()

    draw: () ->
        x = @posx * window.tile_width
        y = @posy * window.tile_height

        if @animation != null
            @animation.draw()
        else
            @pr.image(@img, x, y, window.tile_width, window.tile_height)

        # Draw a player name
        if @ instanceof Player
            @pr.textFont(@font, 10)
            @pr.text(@number, x+12, y)




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
