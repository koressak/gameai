// Generated by CoffeeScript 1.6.3
(function() {
  var controllers;

  controllers = angular.module('gai.controllers');

  controllers.controller('GameCtrl', [
    '$scope', '$rootScope', '$location', '$anchorScroll', function($scope, $rootScope, $location, $anchorScroll) {
      var el;
      window.board_width = 450;
      window.board_height = 390;
      window.tile_no_x = 15;
      window.tile_no_y = 13;
      window.tile_width = 30;
      window.tile_height = 30;
      window.remove_walls_no = 10;
      window.frame_step = 300;
      window.powerup_spawn_percent = 15;
      window.winning_score = 5;
      window.max_players = 5;
      $scope.is_game_running = false;
      $scope.game_loaded = false;
      $scope.winning_score = winning_score;
      $scope.players = null;
      $scope.game_log = new Array;
      $scope.toggle_game = function() {
        if ($scope.is_game_running) {
          console.log("Stopping game");
          pinst.noLoop();
          $scope.is_game_running = false;
          return $scope.new_event("info", "Game stopped");
        } else {
          console.log("Starting game");
          $scope.new_event("info", "Game started");
          pinst.loop();
          $scope.game_loaded = true;
          return $scope.is_game_running = true;
        }
      };
      $scope.update_ui = function() {
        $scope.players = g.players;
        return $scope.$apply();
      };
      $scope.scroll_to = function(id) {
        $location.hash(id);
        return $anchorScroll();
      };
      $scope.new_event = function(status, msg) {
        return $scope.game_log.unshift({
          status: status,
          text: msg
        });
      };
      el = document.getElementById('gamecanvas');
      window.pinst = new Processing(el, window.sketchProcess);
      window.g = new window.Game;
      window.g.init_game($scope);
      return pinst.noLoop();
    }
  ]);

}).call(this);
