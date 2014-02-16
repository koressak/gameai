controllers = angular.module('gai.controllers')

controllers.controller 'GameCtrl', ['$scope', '$rootScope', '$location', '$anchorScroll', ($scope, $rootScope, $location, $anchorScroll) ->
    # Base game definitions
    window.board_width = 630
    window.board_height = 630
    window.tile_no_x = 21
    window.tile_no_y = 21
    window.tile_width = 30
    window.tile_height = 30
    window.rock_count = 100
    window.frame_step = 300 # 300 ms as a step

    window.powerup_spawn_percent = 15

    window.max_players = 5
    window.max_targets = 5

    window.stats = $("#gamestats")

    # window.board_width = 150
    # window.board_height = 150
    # window.tile_no_x = 5
    # window.tile_no_y = 5
    # window.tile_width = 30
    # window.tile_height = 30
    # window.rock_count = 1

    # Init visualisation
    el = document.getElementById 'gamecanvas'
    window.pinst = new Processing(el, window.sketchProcess)

    # Initialize and run game
    window.g = new window.Game
    window.g.init_game()

    # Stop game at the beginning
    pinst.noLoop()
    $scope.is_game_running = false

    $scope.toggle_game = () ->
        if $scope.is_game_running
            pinst.noLoop()
            $scope.is_game_running = false
        else
            pinst.loop()
            $scope.is_game_running = true
        # $scope.$apply()



    $scope.scroll_to = (id) ->
        $location.hash(id)
        $anchorScroll()


]