#json.array!(@root.children) do |node|
  #json.extract! node, :name
#end
json.edges do
  edges_for json, @root
  @root.children.each do |node|
    edges_for(json, node)
  end
end

json.nodes do
  get_nodes_for(json, @root)
end
