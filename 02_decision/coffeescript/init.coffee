@init_app = () ->
    angular.bootstrap(document, ['gai'])

@get_random_int = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min;
