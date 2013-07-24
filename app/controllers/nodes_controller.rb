class NodesController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        root = Node.find(params[:parent_id]) rescue nil
        nodes = root ? root.children : Node.roots

        node_hashes = nodes.map do |node|
          node_hash = { attr: {id: node.id, name: node.name } }

          node_hash
        end

        render json: node_hashes
      end
    end
  end
end
