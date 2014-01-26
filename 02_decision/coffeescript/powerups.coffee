@PowerUp = class _PowerUp extends @GameObject
    init: ->
        @bonus = 0  # amount of bonus
        @timeout = 0  # Timeout for 20 sec
        @type = ''

    pick_up: (player) ->
        if @type != ''
            player.add_bonus @
            @remove_from_game()


@SpeedPowerUp = class _SpeedPowerUp extends @PowerUp
    init: ->
        @bonus = 1  # amount of bonus
        @timeout = 20  # Timeout for 20 sec
        @type = 'speed'
        @image = 'images/powerups/speed.png'
        @load_image()


@HealthPowerUp = class _HealthPowerUp extends @PowerUp
    init: ->
        @bonus = 20  # amount of bonus
        @timeout = 1  # Timeout for 20 sec
        @type = 'health'
        @image = 'images/powerups/health.png'
        @load_image()
 