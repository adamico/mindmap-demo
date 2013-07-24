# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "csv"

puts "importing nodes"
CSV.foreach("nodes.csv", headers: true) do |row|
  node = Node.find_or_create_by!(oldid: row['oldid'])
  node.name = row['name']
  node.parentid = row['parent_id']
  node.save!
end

puts "create tree"
Node.all.each do |node|
  parent = Node.where(oldid: node.parentid).first
  if parent
    node.parent = parent
    node.save!
  end
end
