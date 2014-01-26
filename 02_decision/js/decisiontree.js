(function() {
  this.DecisionTreeNode = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.action = null;
      this.conditions = new Array;
      this.left = null;
      return this.right = null;
    };

    _Class.prototype.set_action = function(action) {
      return this.action = action;
    };

    _Class.prototype.add_condition = function(cond) {
      return this.conditions.push(cond);
    };

    _Class.prototype.compare_conditions = function(player) {
      var cond, result, _i, _len, _ref;
      result = False;
      _ref = this.conditions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cond = _ref[_i];
        result &= cond(player);
      }
      return result;
    };

    _Class.prototype.get_next_node = function(player) {
      if (this.left === null && this.right === null) {
        return null;
      }
      if (this.left.compare_conditions(player)) {
        return this.left;
      } else if (this.right.compare_conditions(player)) {
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
        nnode = current.get_next_node(player);
        if (nnode === null) {
          return current;
        } else {
          current = nnode;
        }
      }
    };

    return _Class;

  })();

  this.DecisionBuilder = (function() {
    function _Class() {}

    _Class.prototype.generate_tree = function() {
      var node, tree;
      node = new DecisionTreeNode;
      tree = new DecisionTree;
      tree.set_root(node);
      return tree;
    };

    return _Class;

  })();

}).call(this);
