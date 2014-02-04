@SIGHT_UP = 0
@SIGHT_RIGHT = 1
@SIGHT_DOWN = 2
@SIGHT_LEFT = 3

@PSTATE_EXPLORE = 0
@PSTATE_ATTACK = 1

@Player = class _Player extends @MovableGameObject
    init: ->
        @image = 'images/soldier.png'
        @load_image()
        @score = 0


        dbuilder = new DecisionBuilder
        @decision = dbuilder.generate_tree()
        # console.log @decision

        @health = 100
        @damage = 5
        @speed = 1
        @sight_radius = 2
        @direction = SIGHT_LEFT

        # Save game map
        @map = g.get_map()

        # Init personal explored tile arrays
        @explored_tiles = new Array(@map.width)
        for i in [0..@map.width-1]
            @explored_tiles[i] = new Array(@map.height)
            for u in [0..@map.height-1]
                @explored_tiles[i][u] = false

        # console.log @explored_tiles

        # Decision variables
        @state = PSTATE_EXPLORE
        @current_action = null
        @current_goal = null
        @current_path = null
        @seeable_objects = new Array

    set_state: (state) ->
        @state = state

    get_next_move: () ->

        # g = window.g

        # if @current_target != null

        #     ind = $.inArray(@current_target, g.targets)
        #     if ind == -1
        #         t = g.get_random_target()
        #         @clear_current_goal()
        #         @set_target t

        #     if @current_path == null
        #         @current_path = @find_path_to_target @current_target

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

    # --------- Target cond and decision -----------
    is_acting: ->
        @current_action != null

    has_goal: ->
        @current_goal != null

    get_goal: ->
        1

    set_goal: (obj) ->
        @current_goal = obj


    clear_current_goal: ->
        @current_goal = null
        @current_path = null

    #  --- Can player see something?
    can_see_object: ->
        @seeable_objects = new Array
        tiles = @map.get_adjacent_tiles @posx, @posy
        for i in [0..tiles.length-1]
            o = tiles[i].get_object()
            if o != null
                @seeable_objects.push o

        # console.log "Seeable objects", @seeable_objects
        # console.log "Result", @seeable_objects.length
        @seeable_objects.length != 0

    # --- Explore nearby surroundings
    pick_random_unexplored_tile: ->
        good = false
        # TODO: have to protect against all tiles explored
        while not good
            x = get_random_int 0, @map.width-1
            y = get_random_int 0, @map.height-1
            if not @explored_tiles[x][y]
                if @map.is_tile_walkable x, y
                    return [x, y]


    explore: ->
        # Pick random unexplored tile if not already done
        if @current_path == null
            [x, y] = @pick_random_unexplored_tile()
            console.log "New target"
            console.log x, y
            tile = @map.tiles[x][y]
            @current_path = @find_path_to_target tile
            # console.log "New path", @current_path

            if not @current_path
                throw "No feasible path found, cannot move further :("

        [nx, ny] = @get_next_move()
        @move nx, ny







    # --- Main loop for a player - make and execute decision

    do_action: ->

        # TODO: has to check for new events 
        if @is_acting()
            @[@current_action]()
        else
            node = @decision.make_decision @
            console.log 'Current decision node'
            console.log node
            if node != null
                @current_action = node.action
                # try
                @[@current_action]()
                # catch err
                #     console.error err
            else
                console.log "We have no action to take. Returned node is null"

            throw 'asdf'

