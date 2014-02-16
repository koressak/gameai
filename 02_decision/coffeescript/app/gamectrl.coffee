controllers = angular.module('gai.controllers')

controllers.controller 'GameCtrl', ['$scope', '$rootScope', '$location', '$anchorScroll', ($scope, $rootScope, $location, $anchorScroll) ->
    # Base game definitions
    # window.board_width = 630
    # window.board_height = 630
    # window.tile_no_x = 21
    # window.tile_no_y = 21
    window.board_width = 300
    window.board_height = 300
    window.tile_no_x = 10
    window.tile_no_y = 10
    window.tile_width = 30
    window.tile_height = 30
    # window.rock_count = 100
    window.rock_count = 10
    window.frame_step = 300 # 300 ms as a step

    window.powerup_spawn_percent = 15

    window.max_players = 5
    window.max_targets = 5

    $scope.is_game_running = false
    $scope.game_loaded = false

    $scope.players = null
    $scope.game_log = new Array


    $scope.toggle_game = () ->
        if $scope.is_game_running
            console.log "Stopping game"
            pinst.noLoop()
            $scope.is_game_running = false
            $scope.new_event "danger", "Game stopped"
        else
            console.log "Starting game"
            $scope.new_event "success", "Game started"
            pinst.loop()
            $scope.game_loaded = true
            $scope.is_game_running = true
        # $scope.$apply()

    $scope.update_ui = () ->
        $scope.players = g.players
        $scope.$apply()

    $scope.scroll_to = (id) ->
        $location.hash(id)
        $anchorScroll()

    $scope.new_event = (status, msg) ->
        $scope.game_log.unshift
            status: status
            text: msg

    # Init visualisation
    el = document.getElementById 'gamecanvas'
    window.pinst = new Processing(el, window.sketchProcess)

    # Initialize and run game

    window.g = new window.Game
    window.g.init_game($scope)

    # Stop game at the beginning
    pinst.noLoop()

]