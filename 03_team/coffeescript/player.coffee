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

@MAX_PURSUE_LENGTH = 10


@Player = class _Player extends @MovableGameObject
    init: ->
        @image = 'images/soldier.png'
        # @image = 'images/got_damaged.png'
        @load_image()

        dbuilder = new DecisionBuilder
        @decision = dbuilder.generate_tree()
        # console.log @decision

        @name = ''
        @number = -1
        @score = 0
        @sight_radius = 1

        # When dies, respawn in framesteps
        @respawn_timeout = 0

        # Save game map
        @map = g.get_map()

        # Known powerup locations
        @powerup_locations = new Array

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

        @last_target = null
        @pursue_length = 0
        @retreat_tile = null

        # anim
        @animation = null

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
            o = tiles[i].get_objects()
            # console.log o, o.length
            if o.length > 0
                @seeable_objects = @seeable_objects.concat o
                # console.log "seeable objects ", @seeable_objects

        # console.log "Seeable objects", @seeable_objects
        # console.log "Result", @seeable_objects.length
        @seeable_objects.length != 0

    is_object_consumable: ->
        # If the seeable object is consumable (powerup)
        # For starters - we pick just the first one we see
        # console.log "Not consuming: ", @seeable_objects
        for obj in @seeable_objects
            if obj instanceof PowerUp
                return true
        # obj = @seeable_objects[0]
        # console.log "First object ", obj
        # console.log 'Is consumable', obj instanceof PowerUp
        # obj instanceof PowerUp
        false

    is_object_player: ->
        for obj in @seeable_objects
            if obj instanceof Player
                return true
        # console.log 'Is Player'
        # console.log obj
        # console.log obj instanceof Player
        # obj instanceof Player
        false

    # --- Attack and flee
    is_fighting: ->
        @state == PSTATE_ATTACK

    can_attack: ->
        # Player can attack if his health is above critical
        if (@health+@armor) > CRITICAL_HEALTH
            return true
        false

    is_health_good: ->
        # TODO: measure intensity of loosing healh in a fight
        if (@health+@armor) > CRITICAL_HEALTH
            return true
        false

    need_healing: ->
        # TODO: measure intensity of loosing healh in a fight
        if @health <= CRITICAL_HEALTH
            # console.log "Player needs healing"
            return true
        false

    attack: ->
        @state = PSTATE_ATTACK

        target = null
        # if @last_target
        #     target = @last_target
        # else
        for obj in @seeable_objects
            if obj instanceof Player
                target = obj
                break

        @last_target = target
        # console.log @name + ": attacking"
        # console.log "Inflicting damage: " + @damage
        target.get_damaged @damage

        if target.health <= 0
            # increment score
            @score += 1
            # remove object from game
            # obj.remove_animation()
            g.player_death target
            @last_target = null

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

        # add damaged animation
        anim = new Animation 'images/got_damaged.png', 1
        @add_animation anim

    pursue: ->
        # Pursue last target if it got out of sight
        # TODO: very, very, very cheaty
        # console.log "Pursuing...", @last_target
        if @last_target != null
            nx = @last_target.posx - @posx
            ny = @last_target.posy - @posy
            @move nx, ny

            # If we exceed number of pursue tiles, we get back to search
            # won't be chasing that idiot for ever ;)
            @pursue_length += 1
            if @pursue_length >= MAX_PURSUE_LENGTH
                # console.log "Stopping pursue due to length"
                @state = PSTATE_EXPLORE
                @pursue_length = 0
                @last_target = null

        else
            # console.log "Getting back to explore"
            @state = PSTATE_EXPLORE
            @pursue_length = 0
            @last_target = null

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
        @clear_current_goal()
        @state = PSTATE_FLEE
        # console.log @name, "Fleeing"
        nx = @retreat_tile.posx - @posx
        ny = @retreat_tile.posy - @posy
        @move nx, ny

    # -- Try to find and get the consumable object
    find_health: ->
        # TODO: when power up is not active, we will be still no one place
        know = false
        x = -1
        y = -1
        for loc in @powerup_locations
            if loc.type == 'health'
                know = true
                x = loc.x
                y = loc.y

        if know
            tile = @map.tiles[x][y]
            @current_path = @find_path_to_target tile

            if not @current_path
                @search_player()
            else
                @continue_moving()
        else
            @search_player()


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
                return
                # throw "No feasible path found, cannot move further :("

        @continue_moving()

    continue_moving: ->
        if @current_path != null
            [nx, ny] = @get_next_move()
            @move nx, ny


    # --- Interact with nearby objects
    consume_object: ->
        # Consume nearby object (powerup in this case)
        obj = null
        for o in @seeable_objects
            if o instanceof PowerUp
                obj = o
                break;
        ind = $.inArray obj, @seeable_objects
        if ind != -1
            @seeable_objects.splice ind, 1
        # obj = @seeable_objects.splice(0,1)[0]

        # Check for known location of this object
        if $.inArray obj.type, @powerup_locations == -1
            # console.log "Adding ", obj.type, " to known locations!!"
            @powerup_locations.push 
                    type: obj.type
                    x: obj.posx 
                    y: obj.posy
            # console.log @powerup_locations

        # consume it's power
        obj.pre_consume @
        obj.consume @
        obj.post_consume @
        # move to it's place
        # @move obj.posx-@posx, obj.posy-@posy


    # --- Main loop for a player - make and execute decision

    do_action: ->

        # TODO: has to check for new events 

        # Process expiry of bonuses
        @process_bonuses()

        for i in [1..@speed]
            node = @decision.make_decision @
            # console.log "Player", @number, 'Current decision node'
            # console.log node
            if node != null
                @current_action = node.action
                # TODO: enable the try/catch
                # try
                @[@current_action]()
                # catch err
                #     console.error err
            else
                console.log "Player", @number, " We have no action to take. Returned node is null"


