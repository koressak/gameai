@TERRAIN_GRASS = 'grass'
@TERRAIN_ROCK = 'rock'
@WALL_THICKNESS = 2

@MapTile = class
  init: (walk, terrain, x, y) ->
    @walkable = walk
    @terrain = terrain
    @posx = x
    @posy = y
    # @object = null
    @objects = new Array
    @explored = true
    @unexplored_image = null
    # Meaning all four walls are up. As with html borders - top, right, bottom, left
    @walls = [true, true, true, true]

  load_image: ->
#    switch @terrain
#      when window.TERRAIN_GRASS
#        @image = pinst.loadImage('images/grass.png')
#      when window.TERRAIN_ROCK
#        @image = pinst.loadImage('images/rock.png')
    @terrain_image = pinst.loadImage('images/grass.png')
    @wall_image = pinst.loadImage('images/rock.png')

    @unexplored_image = pinst.loadImage('images/unexplored.png')

  # set_object: (obj) ->
  #     @object = obj

  add_object: (obj) ->
    @objects.push obj

  get_objects: ->
    @objects

  # get_first_object: ->
  #     @object

  remove_object: (obj) ->
    ind = $.inArray(obj, @objects)
    if ind != -1
      o = @objects.splice ind, 1
      return o[0]
    null

  is_walkable: ->
    if not @walkable
      return false

    if @objects.length > 0
      # for o in @objects
      #     if o instanceof Player
      #         # console.log "Tile not walkable - Player is here"
      return false

    true

  remove_wall_in_direction: (x, y) ->
    dx = @posx - x
    dy = @posy - y

    if dy > 0
      @walls[0] = false
    if dy < 0
      @walls[2] = false
    if dx > 0
      @walls[3] = false
    if dx < 0
      @walls[1] = false

  can_get_there_from: (x, y) ->
    dx = @posx - x
    dy = @posy - y

    if dy > 0 and @walls[0]
      return false
    if dy < 0 and @walls[2]
      return false
    if dx > 0 and @walls[3]
      return false
    if dx < 0 and @walls[1]
      return false

    true

  draw: () ->
    x = @posx * tile_width
    y = @posy * tile_height
    window.pinst.image(@terrain_image, x, y, tile_width, tile_height)

    # draw walls
    if @walls[0]
      window.pinst.image(@wall_image, x, y, tile_width, WALL_THICKNESS)
    if @walls[1]
      window.pinst.image(@wall_image, x+tile_width-WALL_THICKNESS, y, WALL_THICKNESS, tile_height)
    if @walls[2]
      window.pinst.image(@wall_image, x, y+tile_height-WALL_THICKNESS, tile_width, y+tile_height)
    if @walls[3]
      window.pinst.image(@wall_image, x, y, WALL_THICKNESS, tile_height)


    # if @object != null
    for o in @objects
      o.draw()

    # If tile is unexplored we have to cover it with new layer
    if not @explored
      window.pinst.image(@unexplored_image, x, y, tile_width, tile_height)



@Map = class
  constructor: ->
    console.log "Initializing Map"

  init: (w, h) ->
    @width = w
    @height = h
    @tiles = new Array(w)
    @game_objects = new Array
    for i in [0..w - 1]
      @tiles[i] = new Array(h)

  add_tile: (x, y, tile) ->
    @tiles[x][y] = tile

  add_game_object: (obj) ->
    if $.inArray obj, @game_objects == -1
      @game_objects.push obj
      @tiles[obj.posx][obj.posy].add_object obj

  move_game_object: (obj, ox, oy, nx, ny) ->
    # Set tile explored if someone is moving to it
    @set_tile_explored nx, ny
    o = @tiles[ox][oy].remove_object obj
    # console.log "Moving game object"
    # console.log o
    if o != null
      @tiles[nx][ny].add_object o

  remove_game_object: (obj) ->
    ind = $.inArray obj, @game_objects

    if ind != -1
      o = @game_objects[ind]
      @tiles[o.posx][o.posy].remove_object obj
      @game_objects.splice ind, 1

  is_tile_walkable: (x, y) ->
    if x < 0 or x > @width - 1
      return false
    if y < 0 or y > @height - 1
      return false

    t = @tiles[x][y]
    t.is_walkable()

  is_tile_free: (x, y) ->
    if x < 0 or x > @width - 1
      return false
    if y < 0 or y > @height - 1
      return false

    # @tiles[x][y].get_objects() == null
    @tiles[x][y].get_objects().length == 0


  get_tile_objects: (x, y) ->
    if x < 0 or x > @width - 1
      return null
    if y < 0 or y > @height - 1
      return null

    @tiles[x][y].get_objects()

  set_tile_explored: (x, y) ->
    @tiles[x][y].explored = true

  get_adjacent_tiles: (x, y) ->
    tiles = new Array
    if x - 1 >= 0
      tiles.push @tiles[x - 1][y]
    if x + 1 <= @width - 1
      tiles.push @tiles[x + 1][y]

    if y - 1 >= 0
      tiles.push @tiles[x][y - 1]
    if y + 1 <= @height - 1
      tiles.push @tiles[x][y + 1]

    return tiles

  get_adjacent_walkable_tiles: (x, y) ->
    ret = new Array
    tiles = @get_adjacent_tiles(x, y)
    for t in tiles
      if t.can_get_there_from(x, y)
        ret.push t
    ret

  draw: () =>
    for x in [0..@width - 1]
      for y in [0..@height - 1]
        @tiles[x][y].draw()
#    @tiles[1][0].draw()

# for obj in @game_objects
#     obj.draw()



@MapRenderer = class
  constructor: ->
    console.log "Initializing MapRenderer"

  render: (w, h) ->
    map = new window.Map
    map.init(w, h)

    nodes = (w*h)-1
    here = [Math.floor(Math.random()*w), Math.floor(Math.random()*h)]
    path = [here]
    unvisited = new Array(w)


    # Basic initialization of a map
    for x in [0..w - 1]
      unvisited[x] = new Array(h)
      for y in [0..h - 1]
        unvisited[x][y] = true
        t = new window.MapTile
        t.init true, TERRAIN_GRASS, x, y
        map.add_tile x, y, t

    # Maze generation
    unvisited[here[0]][here[1]] = false

    while 0<nodes
      if typeof(here) == "undefined"
        break
      neighbors = new Array()
      adj = map.get_adjacent_tiles(here[0], here[1])
      for t in adj
        if unvisited[t.posx][t.posy]
          neighbors.push(t)
      if neighbors.length > 0
        nodes -= 1
        next = neighbors[Math.floor(Math.random()*neighbors.length)]
        unvisited[next.posx][next.posy] =false
        map.tiles[next.posx][next.posy].remove_wall_in_direction here[0], here[1]
        map.tiles[here[0]][here[1]].remove_wall_in_direction next.posx, next.posy
        path.push here
        here = [next.posx, next.posy]
      else
        here = path.pop()


    # Randomly remove walls to make new ways
    rem_walls_no = window.remove_walls_no
    for x in [1..rem_walls_no]
      posx = get_random_int 0, w - 1
      posy = get_random_int 0, h - 1
      t = map.tiles[posx][posy]
      t.walls = [false, false, false, false]
      n = map.get_adjacent_tiles(t.posx, t.posy)
      for neib in n
        neib.remove_wall_in_direction(t.posx, t.posy)

    for x in [0..w - 1]
      for y in [0..h - 1]
        map.tiles[x][y].load_image()

    map
