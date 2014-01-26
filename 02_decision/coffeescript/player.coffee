@SIGHT_UP = 0
@SIGHT_RIGHT = 1
@SIGHT_DOWN = 2
@SIGHT_LEFT = 3

@Player = class _Player extends @MovableGameObject
    init: ->
        @image = 'images/soldier.png'
        @load_image()
        @current_target = null
        @current_path = null
        @score = 0

        @health = 100
        @damage = 5
        @speed = 1
        @sight_radius = 2
        @direction = SIGHT_LEFT

    has_target: ->
        @current_target != null

    set_target: (obj) ->
        @current_target = obj

    clear_current_goal: ->
        @current_target = null
        @current_path = null

    get_next_move: () ->

        g = window.g

        if @current_target != null

            ind = $.inArray(@current_target, g.targets)
            if ind == -1
                t = g.get_random_target()
                @clear_current_goal()
                @set_target t

            if @current_path == null
                @current_path = @find_path_to_target @current_target

            step = @current_path.splice(0,1)
            if step.length > 0
                return [step[0].posx-@posx, step[0].posy-@posy]
            else
                @current_path = null
                @current_target = null

        [0,0]

    find_path_to_target: (obj) ->
        # A* algorithm implementation
        p = new Path
        path = p.find_path @, obj
        path

    do_action: () ->
        unless @current_target
            @current_target = g.get_random_target()
            


# @Target = class
#     init: ->
#         @image = null
#         @posx = 0
#         @posy = 0
#         @load_image()

#     load_image: ->
#         @image = pinst.loadImage('images/chest.png')

#     set_position: (x, y) ->
#         @posx = x
#         @posy = y

#     draw: () ->
#         x = @posx * tile_width
#         y = @posy * tile_height
#         window.pinst.image(@image, x, y, tile_width, tile_height)

