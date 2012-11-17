namespace "engine" do
 desc "Symlinks an engine gem into a local project for development productivity purposes"
 task :symlink, :gem_name do |t, args|
   gem_name = args[:gem_name]
   gem_file_path = `bundle exec gem which #{gem_name}`
   gem_file_path_match = gem_file_path.match(/(.*)\/lib.*/)
   gem_path = gem_file_path_match[1]
   system "rm -rf #{gem_path}"
   project_gem_path = File.expand_path("#{Rails.root}/../#{gem_name}", __FILE__)
   system "ln -s #{project_gem_path} #{gem_path}"
   puts "Symlinking Complete: #{gem_path} now points to #{project_gem_path}"
 end
end
