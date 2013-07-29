module NodesHelper
  def build_tree_for(json, node)
    edge_for(json, node)
    node.children.each do |child|
      edge_for(json, child)
    end
  end

  def get_nodes_for(json, node)
    if node.depth < 3
      data_hash = {color: "#b2b19d", depth: node.depth}
      if node.children.any?
        data_hash[:shape] = "dot"
        if node.depth <= 1
          data_hash[:alpha] = 1
        else
          data_hash[:alpha] = 0
        end
      else
        data_hash[:alpha] = 0
      end
      json.set! node.name, data_hash
      node.children.each do |child|
        get_nodes_for(json, child)
      end
    end
  end

  def edge_for(json, node)
    json.set! node.name, children_hash(node)
  end

  def children_hash(node)
    the_hash = {}
    node.children.each do |child|
      the_hash[child.name] = children_hash(child)
    end
    the_hash
  end
end
