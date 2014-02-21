@PowerUpSpawner = class _PwrUpSpwn extends @GameObject
    init: (pwr_cls) ->
        @active = false
        @respawn_time = 20 # Frame steps
        @time_to_respawn = 0
        @power_class = pwr_cls

    frame: ->
        # If has some probability - spawn again
        unless @active
            @time_to_respawn -= 1
            if @time_to_respawn <= 0
                @unhide()
                @active = true
                @spawn_power_up()

    consumed: ->
        @active = false
        @time_to_respawn = @respawn_time
        @hide()

    spawn_power_up: ->
        pwr = new @power_class 
        pwr.init()
        pwr.posx = @posx
        pwr.posy = @posy
        pwr.spawner = @
        pwr.add_to_game()


@PowerUp = class _PowerUp extends @GameObject
    init: ->
        @bonus = 0  # amount of bonus
        @timeout = 0  # Timeout 
        @type = ''
        @spawner = null

    consume: (player) ->
        player[@type] += @bonus
        # console.log "Removing powerup from game", @
        @spawner.consumed()
        @remove_from_game()

    pre_consume: (player) ->
        1

    post_consume: (player) ->
        1 

    do_timeout: ->
        true


@SpeedPowerUp = class _SpeedPowerUp extends @PowerUp
    init: ->
        @bonus = 1  # amount of bonus
        @timeout = 10  # Timeout frame steps 
        @type = 'speed'
        @image = 'images/powerups/speed.png'
        @load_image()

    consume: (player) ->
        player[@type] += @bonus
        player.active_bonuses.push @
        # console.log "Removing powerup from game", @
        @spawner.consumed()
        @remove_from_game()

    do_timeout: (player) ->
        player[@type] -= @bonus
        # console.log "Bonus timeout", @


@HealthPowerUp = class _HealthPowerUp extends @PowerUp
    init: ->
        @bonus = 20  # amount of bonus
        @timeout = 0  # instantly used 
        @type = 'health'
        @image = 'images/powerups/health.png'
        @load_image()

    post_consume: (player) ->
        if player[@type] > MAX_HEALTH
            player[@type] = MAX_HEALTH


@FirepowerPowerUp = class _FirepowerPowerUp extends @PowerUp
    init: ->
        @bonus = 2  # amount of bonus
        @timeout = 0  # instantly used 
        @type = 'damage'
        @image = 'images/powerups/firepower.png'
        @load_image()

@ArmorPowerUp = class _ArmorPowerUp extends @PowerUp
    init: ->
        @bonus = 5  # amount of bonus
        @timeout = 0  # instantly used 
        @type = 'armor'
        @image = 'images/powerups/defend.png'
        @load_image()
 