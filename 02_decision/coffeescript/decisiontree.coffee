@DecisionTreeNode = class
    init: ->
        @action = null 
        @conditions = new Array
        @left = null
        @right = null

    set_action: (action) ->
        @action = action

    add_condition: (cond) ->
        @conditions.push cond

    compare_conditions: (player) ->
        result = False
        # Compare all conditions on player 
        for cond in @conditions
            result &= cond player

        # if player is good to go this way, return true
        return result

    get_next_node: (player) ->
        # Decide where to go next or null

        # We have nowhere else to go, returning
        if @left == null && @right == null
            return null

        if @left.compare_conditions player
            return @left
        else if @right.compare_conditions player
            return @right

        null



@DecisionTree = class
    init: ->
        @root = null

    set_root: (node) ->
        @root = node

    make_decision: (player) ->
        if @root == null
            return null

        current = @root

        while true
            nnode = current.get_next_node player
            if nnode == null
                return current
            else
                current = nnode


@DecisionBuilder = class
    generate_tree: () ->
        node = new DecisionTreeNode
        tree = new DecisionTree
        tree.set_root node
        tree

