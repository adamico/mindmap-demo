module NodesHelper
  def edges_for(json, node)
    json.set! node.name, children_hash(node)
  end

  def get_nodes_for(json, node)
    json.set! node.name, data_hash(node)
    node.children.each do |child|
      get_nodes_for(json, child) if child.depth < 3
    end
  end

  def data_hash(node)
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
    data_hash
  end

  def children_hash(node)
    the_hash = {}
    node.children.each do |child|
      the_hash[child.name] = {}
    end
    the_hash
  end
end
