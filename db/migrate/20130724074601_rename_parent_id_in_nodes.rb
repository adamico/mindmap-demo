class RenameParentIdInNodes < ActiveRecord::Migration
  def up
    rename_column :nodes, :parent_id, :parentid
  end
  def down
    rename_column :nodes, :parentid, :parent_id
  end
end
