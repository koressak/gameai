#
# Main Game class handling the game dynamics
# 
@Game = class
    constructor: ->
        console.log "Initialization of Game"

    init_game: ->
        @mrender = new window.MapRenderer
        @map = @mrender.render tile_no_x, tile_no_y

        window.game_objects.push(@map)

