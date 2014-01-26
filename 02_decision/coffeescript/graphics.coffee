@sketchProcess = (processing) ->
    p = processing
    f = p.loadFont('Arial')
    running = true

    processing.setup = () ->
        p.size window.board_width, window.board_height
        p.background 200
        window.game_objects = new Array()

    processing.draw = () ->
        if not g.game_finished
            g.game_loop()
            map = g.get_map()
            map.draw()
        else
            p.textFont(f, 40)
            map = g.get_map()
            centerx = Math.floor((map.width*tile_width) / 2)
            centery = Math.floor((map.height*tile_height)/2)
            p.textAlign(p.CENTER)
            p.text("GAME WON", centerx, centery)


    processing.keyPressed = () ->
        # player = g.get_player(0)

        # console.log p.keyCode
        if p.keyCode == 32
            running = !running
            if running
                p.loop()
            else
                p.noLoop()

        # if p.key.code == p.CODED
        #     if p.keyCode == p.UP
        #         player.move(0,-1)
        #     else if p.keyCode == p.DOWN
        #         player.move(0, 1)
        #     else if p.keyCode == p.LEFT
        #         player.move(-1, 0)
        #     else if p.keyCode == p.RIGHT
        #         player.move(1, 0)




