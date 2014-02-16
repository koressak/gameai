@PowerUp = class _PowerUp extends @GameObject
    init: ->
        @bonus = 0  # amount of bonus
        @timeout = 0  # Timeout 
        @type = ''

    consume: (player) ->
        player[@type] += @bonus
        console.log "Removing powerup from game", @
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
        @timeout = 5  # Timeout frame steps 
        @type = 'speed'
        @image = 'images/powerups/speed.png'
        @load_image()

    consume: (player) ->
        player[@type] += @bonus
        player.active_bonuses.push @
        console.log "Removing powerup from game", @
        @remove_from_game()

    do_timeout: (player) ->
        player[@type] -= @bonus
        console.log "Bonus timeout", @


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
 