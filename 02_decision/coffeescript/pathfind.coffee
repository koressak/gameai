@NodeRecord = class
    init: ->
        @node = null
        @connection = null
        @cost_so_far = 0
        @estimate_cost = 0

# A* algorithm to find path between two points
# Uses Dijkstra algorightm with heuristics.
@Path = class
    init: ->
        @start = null
        @end = null

    find_path: (start, end) ->
        @start = start
        @end = end
        map = g.get_map()

        path = null

        open = new Array
        closed = new Array

        sn = new NodeRecord
        sn.node = @start
        sn.cost_so_far = 0
        sn.estimate_cost = @estimate_cost @start.posx, @start.posy, @end.posx, @end.posy

        open.push sn
        current = null

        while open.length > 0
            # console.log open.concat()
            current = @get_min_node open

            if current.node.posx == @end.posx and current.node.posy == @end.posy
                break

            connections = map.get_adjacent_tiles current.node.posx, current.node.posy

            for i in [0..connections.length-1]
                unless connections[i].is_walkable()
                    continue
                node = @get_to_node connections[i]
                node_cost = current.cost_so_far + 1  # +1 - connection is length of 1
                node_estimate = @estimate_cost node.node.posx, node.node.posy, @end.posx, @end.posy

                ind = @in_node_records node, closed
                ind2 = @in_node_records node, open
                if ind != -1
                    rec = closed[ind]
                    if rec.cost_so_far <= node_cost
                        continue

                    # new way is better, removing from closed
                    closed.splice(ind, 1)
                else if ind2 != -1
                    rec = open[ind2]
                    if rec.cost_so_far <= node_cost
                        continue

                    open.splice(ind2, 1)
                else
                    newrec = node

                newrec.cost_so_far = node_cost
                newrec.estimate_cost = node_estimate
                newrec.connection = current

                open.push(newrec)

            ind = @in_node_records current, open
            open.splice(ind, 1)
            closed.push(current)

        # Yeah, we got the path
        if current.node.posx == @end.posx and current.node.posy == @end.posy
            # compile path
            path = new Array
            while not @is_equals current.node, @start
                path.push current.node
                current = current.connection
                
            return path.reverse()
        else
            return null



    is_equals: (obj1, obj2) ->
        if obj1.posx == obj2.posx and obj1.posy == obj2.posy
            return true
        else
            return false

    estimate_cost: (x1, y1, x2, y2) ->
        c1 = Math.abs(x1-x2)
        c2 = Math.abs(y1-y2)
        c1+c2

    get_to_node: (connection) ->
        node = new NodeRecord
        node.node = connection
        node

    get_min_node: (records) ->
        best = 100000000000;
        fin_id = -1
        for i in [0..records.length-1]
            r = records[i]
            if r.estimate_cost < best
                best = r.estimate_cost
                fin_id = i

        # console.log(best)
        # console.log fin_id
        records[fin_id]


    in_node_records: (node, records) ->
        if records.length == 0
            return -1

        for i in [0..records.length-1]
            r = records[i]
            if node.node.posx == r.node.posx and node.node.posy == r.node.posy
                return i

        -1
