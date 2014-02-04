@PowerUp = class _PowerUp extends @GameObject
    init: ->
        @bonus = 0  # amount of bonus
        @timeout = 0  # Timeout 
        @type = ''

    consume: (player) ->
        player[@type] += @bonus
        console.log "Removing powerup from game", @
        @remove_from_game()

    do_timeout: ->
        true


@SpeedPowerUp = class _SpeedPowerUp extends @PowerUp
    init: ->
        @bonus = 1  # amount of bonus
        @timeout = 3  # Timeout for 20 frame steps 
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


 