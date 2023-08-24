task default: %w[list_commands]

command_files = Dir["commands/*.rb"]
files_to_commands = command_files.zip(
  command_files.map { |f| f.sub("commands/", "").sub(".rb", "") }
).to_h

desc "Show all available commands."
task :list_commands do
  puts "Available commands: \n\t* #{files_to_commands.values.join("\n\t* ")}"
end

namespace :run do
  files_to_commands.each do |(filename, command)|
    desc "Run command file at #{filename}"
    task command do
      ruby filename
    end
  end
end
