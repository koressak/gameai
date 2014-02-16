# Main definition for angular app
angular.module('gai', ['ngRoute', 'gai.controllers'])
    .config(['$routeProvider', ($routeProvider) ->
        $routeProvider
            .when('/', {templateUrl: 'partials/game.html', controller: 'GameCtrl' })
            .otherwise({redirectTo: '/'})
            ])

angular.module 'gai.controllers', []