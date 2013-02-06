require "rubygems"
gem "pivotal-tracker"
require "pivotal_tracker"
require "yaml"

API_TOKEN = "bbe57fa2f5479b1c897f3694314360be"

config = File.open("config.yml") {|f| YAML::load(f)}
puts "config = #{config.inspect}"

PivotalTracker::Client.token(config['pivotal']['username'], config['pivotal']['password'])
PivotalTracker::Client.token = config['pivotal']['api_token']

puts "All projects"

@projects = PivotalTracker::Project.all
puts "projects = #{@projects.map{|p| p.name}.join(', ')}"
