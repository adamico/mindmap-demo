#json.array!(@root.children) do |node|
  #json.extract! node, :name
#end
json.edges do
  build_tree_for(json, @root)
end

json.nodes do
  get_nodes_for(json, @root)
end
