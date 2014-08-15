// Generated by CoffeeScript 1.6.3
(function() {
  this.COND_ALWAYS_TRUE = 'aw';

  this.DecisionTreeNode = (function() {
    function _Class() {}

    _Class.prototype.init = function() {
      this.action = null;
      this.condition = null;
      return this.children = new Array;
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
      var child, _i, _len, _ref;
      if (this.children.length === 0) {
        return null;
      }
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        if (child.compare_conditions(player)) {
          return child;
        }
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

    _Class.prototype.gen_new_node = function(condition, action) {
      var node;
      node = new DecisionTreeNode;
      node.init();
      node.action = action;
      node.condition = condition;
      return node;
    };

    _Class.prototype.gen_always_true = function(action) {
      return this.gen_new_node(COND_ALWAYS_TRUE, action);
    };

    _Class.prototype.generate_tree = function() {
      var attack, can_attack, can_flee, fsee, fsee_player, is_fighting, is_health_good, need_healing, pursue, root, search_player, see, see_player, see_powerup, tree;
      root = this.gen_new_node(null, null);
      is_fighting = this.gen_new_node('is_fighting', null);
      is_health_good = this.gen_new_node('is_health_good', 'attack');
      attack = this.gen_always_true('attack');
      fsee_player = this.gen_new_node('is_object_player', null);
      fsee = this.gen_new_node('can_see_object', null);
      can_flee = this.gen_new_node('can_flee', 'flee');
      pursue = this.gen_always_true('pursue');
      search_player = this.gen_always_true('search_player');
      need_healing = this.gen_new_node('need_healing', 'find_health');
      see_powerup = this.gen_new_node('is_object_consumable', 'consume_object');
      see_player = this.gen_new_node('is_object_player', null);
      see = this.gen_new_node('can_see_object', null);
      can_attack = this.gen_new_node('can_attack', 'attack');
      see_player.children.push(can_attack, can_flee, attack);
      see.children.push(see_player, see_powerup, search_player);
      fsee_player.children.push(is_health_good, can_flee, attack);
      fsee.children.push(fsee_player, search_player);
      is_fighting.children.push(fsee, pursue);
      root.children.push(is_fighting, see, need_healing, search_player);
      tree = new DecisionTree;
      tree.set_root(root);
      return tree;
    };

    return _Class;

  })();

}).call(this);