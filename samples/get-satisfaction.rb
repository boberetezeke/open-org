require "rubygems"
gem "ruby-satisfaction"
require "satisfaction"

puts "Open-Org products"
puts "--------------------------------"

Satisfaction.new.companies.get("open-org").products.page(1).items.each do |product|
  puts "product name: #{product.name}"
end
puts

puts "Open-Org topics"
puts "--------------------------------"
Satisfaction.new.companies.get("open-org").topics.page(1).items.each do |topic|
  puts "topic subject: #{topic.subject}"
end
puts

puts "Open-Org topics for open-org-website"
puts "--------------------------------"

Satisfaction.new.companies.get("open-org").products.get("open-org_open_org_website").topics.page(1).items.each do |topic|
  puts "topic subject: #{topic.subject}"
end
puts
