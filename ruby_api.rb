require 'bundler'
Bundler.require

token = '' # enter your Gitlab access token
group_id = 1050736 # Notch8 Group ID

stop = false
page = 1
projects_parsed_responses = []
until stop do 
  puts "Checking page #{page}...".light_blue
  response = HTTParty.get("http://gitlab.com/api/v4/groups/#{group_id}/projects?per_page=100&page=#{page}", headers: { Authorization: "Bearer #{token}" })
  stop = true if response.count < 100
  projects_parsed_responses << response.parsed_response
  page += 1
end

projects = projects_parsed_responses.flatten.map { |project| { id: project['id'], name: project['name'], visibility: project['visibility'] } }

puts "\n#{projects.count} projects found.\n".green

projects.flatten.sort_by { |project| project[:name] }.each do |project|
  response = HTTParty.get("http://gitlab.com/api/v4/projects/#{project[:id]}/members/all?per_page=100", headers: { Authorization: "Bearer #{token}" })

  if response.parsed_response['message'] == '401 Unauthorized'
    puts "Looks like you don't have permissions, please enter a token!\n".red
    exit
  end

  members = response.parsed_response.map { |r| r['name'] }.join('; ')
  puts "#{'PROJECT'.underline}: #{project[:name].gsub('-', ' ').gsub('_', ' ').split(/(\W)/).map(&:capitalize).join.yellow}",
    "#{'VISIBILITY'.underline}: #{project[:visibility] == 'private' ? project[:visibility].red : project[:visibility] == 'public' ? project[:visibility].green : project[:visibility].light_black }",
    "#{'MEMBERS'.underline}: #{members.cyan}"
end
