@sketchProcess = (processing) ->
    p = processing

    processing.setup = () ->
        p.size window.board_width, window.board_height
        p.background 200
        window.game_objects = new Array()

    processing.draw = () ->
        objects = window.game_objects
        for o in objects
            o.draw()



