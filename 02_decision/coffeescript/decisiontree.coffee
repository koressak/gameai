@COND_ALWAYS_TRUE = 'aw'

@DecisionTreeNode = class
    # Needs to have a conditions (array of function callbacks to player functions)
    # Needs to have an action - callback to player function of an action that needs to be taken
    init: ->
        @action = null 
        @condition = null
        @left = null
        @right = null

    set_action: (action) ->
        @action = action

    set_condition: (cond) ->
        @condition = cond

    compare_conditions: (player) ->
        # Run the condition function and see if it's true/false
        if @condition == COND_ALWAYS_TRUE
            return true
        player[@condition]()

    get_next_node: (player) ->
        # Decide where to go next or null

        # We have nowhere else to go, returning
        if @left == null && @right == null
            return null

        if @left.compare_conditions player
            return @left

        if @right.compare_conditions player
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
            # console.log "Tree, current node"
            # console.log current
            if current.action != null
                return current

            nnode = current.get_next_node player
            if nnode == null
                return nnode
            else
                current = nnode


@DecisionBuilder = class

    gen_new_node: (condition, action) ->
        node = new DecisionTreeNode
        node.init()
        node.action = action
        node.condition = condition
        node

    gen_always_true: (action) ->
        @gen_new_node COND_ALWAYS_TRUE, action

    generate_tree: () ->
        # Create the tree to cover all the actions
        root = @gen_new_node null, null

        explore = @gen_always_true 'explore'

        # what to do when see an object
        see_powerup = @gen_new_node 'is_object_consumable', 'consume_object'
        see = @gen_new_node 'can_see_object', null

        see.left = see_powerup
        see.right = explore

        root.left = see
        root.right = explore


        # Finally create a tree object
        tree = new DecisionTree
        tree.set_root root
        tree

