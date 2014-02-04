(function() {
  this.COND_ALWAYS_TRUE = 'aw';

  this.DecisionTreeNode = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.action = null;
      this.condition = null;
      this.left = null;
      return this.right = null;
    };

    _Class.prototype.set_action = function(action) {
      return this.action = action;
    };

    _Class.prototype.set_condition = function(cond) {
      return this.condition = cond;
    };

    _Class.prototype.compare_conditions = function(player) {
      if (this.condition === COND_ALWAYS_TRUE) {
        return true;
      }
      return player[this.condition]();
    };

    _Class.prototype.get_next_node = function(player) {
      if (this.left === null && this.right === null) {
        return null;
      }
      if (this.left.compare_conditions(player)) {
        return this.left;
      }
      if (this.right.compare_conditions(player)) {
        return this.right;
      }
      return null;
    };

    return _Class;

  })();

  this.DecisionTree = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      return this.root = null;
    };

    _Class.prototype.set_root = function(node) {
      return this.root = node;
    };

    _Class.prototype.make_decision = function(player) {
      var current, nnode;
      if (this.root === null) {
        return null;
      }
      current = this.root;
      while (true) {
        if (current.action !== null) {
          return current;
        }
        nnode = current.get_next_node(player);
        if (nnode === null) {
          return nnode;
        } else {
          current = nnode;
        }
      }
    };

    return _Class;

  })();

  this.DecisionBuilder = (function() {
    function _Class() {}

    _Class.prototype.gen_new_node = function(action, condition) {
      var node;
      node = new DecisionTreeNode;
      node.init();
      node.action = action;
      node.condition = condition;
      return node;
    };

    _Class.prototype.gen_always_true = function(action) {
      return this.gen_new_node(action, COND_ALWAYS_TRUE);
    };

    _Class.prototype.generate_tree = function() {
      var explore, root, see, tree;
      root = this.gen_new_node(null, null);
      see = this.gen_new_node(null, 'can_see_object');
      explore = this.gen_always_true('explore');
      root.left = see;
      root.right = explore;
      tree = new DecisionTree;
      tree.set_root(root);
      return tree;
    };

    return _Class;

  })();

}).call(this);
