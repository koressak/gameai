@COND_ALWAYS_TRUE = 'aw'

@DecisionTreeNode = class
    # Needs to have a conditions (array of function callbacks to player functions)
    # Needs to have an action - callback to player function of an action that needs to be taken
    init: ->
        @action = null 
        @condition = null
        @children = new Array

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
        # if @left == null && @right == null
        if @children.length == 0
            return null

        for child in @children
            if child.compare_conditions player
                return child

        # if @left.compare_conditions player
        #     return @left

        # if @right.compare_conditions player
        #     return @right

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

        # fight
        is_fighting = @gen_new_node 'is_fighting', null
        is_health_good = @gen_new_node 'is_health_good', 'attack'
        attack = @gen_always_true 'attack'
        fsee_player = @gen_new_node 'is_object_player', null
        fsee = @gen_new_node 'can_see_object', null
        can_flee = @gen_new_node 'can_flee', 'flee'
        pursue = @gen_always_true 'pursue'

        # Exploring
        search_player = @gen_always_true 'search_player'

        # on low health - needs healing
        need_healing = @gen_new_node 'need_healing', 'find_health'

        # what to do when see an object
        see_powerup = @gen_new_node 'is_object_consumable', 'consume_object'
        see_player = @gen_new_node 'is_object_player', null
        see = @gen_new_node 'can_see_object', null


        can_attack = @gen_new_node 'can_attack', 'attack'


        # --- Connection of the tree
        see_player.children.push can_attack, can_flee, attack
        see.children.push see_player, see_powerup

        # Fighting subtree

        # is_fighting
        fsee_player.children.push is_health_good, can_flee, attack
        fsee.children.push fsee_player, search_player 
        is_fighting.children.push fsee, pursue

        # Set first root action
        # root.children.push is_fighting, see, explore
        root.children.push is_fighting, see, need_healing, search_player

        # Finally create a tree object
        tree = new DecisionTree
        tree.set_root root
        tree

