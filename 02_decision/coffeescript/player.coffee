@SIGHT_UP = 0
@SIGHT_RIGHT = 1
@SIGHT_DOWN = 2
@SIGHT_LEFT = 3

@PSTATE_DEATH = -1
@PSTATE_EXPLORE = 0
@PSTATE_ATTACK = 1
@PSTATE_FLEE = 2

@MAX_HEALTH = 100
@CRITICAL_HEALTH = 25


@Player = class _Player extends @MovableGameObject
    init: ->
        @image = 'images/soldier.png'
        @load_image()

        dbuilder = new DecisionBuilder
        @decision = dbuilder.generate_tree()
        # console.log @decision

        @name = ''
        @score = 0
        @sight_radius = 1

        # When dies, respawn in framesteps
        @respawn_timeout = 0

        # Save game map
        @map = g.get_map()

        # Init personal explored tile arrays
        @explored_tiles = new Array(@map.width)
        for i in [0..@map.width-1]
            @explored_tiles[i] = new Array(@map.height)
            for u in [0..@map.height-1]
                @explored_tiles[i][u] = false

        @set_initial_state()

    set_initial_state: ->
        # Initial state
        @health = MAX_HEALTH
        @armor = 0
        @damage = 5
        @speed = 1
        # @direction = SIGHT_LEFT

        # Decision variables
        @state = PSTATE_EXPLORE
        @current_action = null
        @current_goal = null
        @current_path = null
        @seeable_objects = new Array
        @active_bonuses = new Array

        # @attack_target = null
        @retreat_tile = null

    set_state: (state) ->
        @state = state

    get_next_move: () ->

        step = @current_path.splice(0,1)
        if step.length > 0
            @explored_tiles[step[0].posx][step[0].posy] = true
            return [step[0].posx-@posx, step[0].posy-@posy]
        else
            @current_path = null
            # @current_target = null

        [0,0]

    find_path_to_target: (obj) ->
        # A* algorithm implementation
        p = new Path
        path = p.find_path @, obj
        path


    process_bonuses: ->
        new_bonuses = new Array

        if @active_bonuses.length > 0
            for i in [0..@active_bonuses.length-1]
                o = @active_bonuses[i]
                o.timeout -= 1
                if o.timeout == 0
                    o.do_timeout @
                else
                    new_bonuses.push o

        @active_bonuses = new_bonuses



    # --------- Target cond and decision -----------
    is_acting: ->
        @current_action != null

    has_goal: ->
        @current_goal != null

    get_goal: ->
        1

    set_goal: (obj) ->
        @current_path = null
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

    is_object_consumable: ->
        # If the seeable object is consumable (powerup)
        # For starters - we pick just the first one we see
        obj = @seeable_objects[0]
        # console.log 'Is consumable'
        # console.log obj
        # console.log obj instanceof PowerUp
        obj instanceof PowerUp

    is_object_player: ->
        obj = @seeable_objects[0]
        # console.log 'Is Player'
        # console.log obj
        # console.log obj instanceof Player
        obj instanceof Player

    # --- Attack and flee
    is_fighting: ->
        @state == PSTATE_ATTACK

    can_attack: ->
        # Player can attack if his health is above critical
        if @health > CRITICAL_HEALTH
            return true
        false

    is_health_good: ->
        # TODO: measure intensity of loosing healh in a fight
        if @health > CRITICAL_HEALTH
            return true
        false

    attack: ->
        @state = PSTATE_ATTACK

        obj = @seeable_objects[0]
        # console.log @name + ": attacking"
        # console.log "Inflicting damage: " + @damage
        obj.get_damaged @damage

        if obj.health <= 0
            # increment score
            @score += 1
            # remove object from game
            g.player_death obj

            if @score == winning_score
                g.player_won @


    get_damaged: (dmg) ->
        # console.log @name + ": got injured for " + dmg
        if dmg > @armor
            res = Math.abs @armor-dmg
            @armor = 0
            @health -= res
        else
            @armor -= dmg

    can_flee: ->
        # Get adjacent tiles and see, if there is a way to retreat
        map = g.get_map()
        tiles = map.get_adjacent_tiles @posx, @posy

        # console.log "Can flee?"
        # console.log tiles
        for t in tiles
            if t.is_walkable()
                @retreat_tile = t
                # console.log "Retreat tile: ", @retreat_tile
                return true
        false

    flee: ->
        @state = PSTATE_FLEE
        # console.log @name, "Fleeing"
        nx = @retreat_tile.posx - @posx
        ny = @retreat_tile.posy - @posy
        @move nx, ny


    # --- Explore nearby surroundings
    pick_random_tile: ->
        good = false
        # TODO: have to protect against all tiles explored
        while not good
            x = get_random_int 0, @map.width-1
            y = get_random_int 0, @map.height-1
            # if not @explored_tiles[x][y]
            if @map.is_tile_walkable x, y
                return [x, y]


    search_player: ->
        # Pick random tile to search for the player
        @state = PSTATE_EXPLORE

        if @current_path == null
            [x, y] = @pick_random_tile()
            # console.log "New target"
            # console.log x, y
            tile = @map.tiles[x][y]
            @current_path = @find_path_to_target tile
            # console.log "New path", @current_path

            if not @current_path
                throw "No feasible path found, cannot move further :("

        [nx, ny] = @get_next_move()
        @move nx, ny


    # --- Interact with nearby objects
    consume_object: ->
        # Consume nearby object (powerup in this case)
        obj = @seeable_objects.splice(0,1)[0]

        # consume it's power
        obj.pre_consume @
        obj.consume @
        obj.post_consume @
        # move to it's place
        @move obj.posx-@posx, obj.posy-@posy


    # --- Main loop for a player - make and execute decision

    do_action: ->

        # TODO: has to check for new events 

        # Process expiry of bonuses
        @process_bonuses()

        for i in [1..@speed]
            node = @decision.make_decision @
            # console.log 'Current decision node'
            # console.log node
            if node != null
                @current_action = node.action
                # TODO: enable the try/catch
                try
                    @[@current_action]()
                catch err
                    console.error err
            else
                console.log "We have no action to take. Returned node is null"


