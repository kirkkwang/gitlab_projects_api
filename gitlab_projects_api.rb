require_relative 'csv_creator'
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

headers = ['PROJECT NAME', 'VISIBILITY', 'MEMBERS']
project_names = []
visibilities = []
member_lists = []
projects.flatten.sort_by { |project| project[:name] }.each do |project|
  response = HTTParty.get("http://gitlab.com/api/v4/projects/#{project[:id]}/members/all?per_page=100", headers: { Authorization: "Bearer #{token}" })
  project_name = project[:name].gsub('-', ' ').gsub('_', ' ').split(/(\W)/).map(&:capitalize).join
  visibility = project[:visibility]
  member_list = response.parsed_response.map { |r| r['name'] }.join('; ')
  project_names << project_name
  visibilities << visibility
  member_lists << member_list

  puts "#{headers[0].underline}: #{project_name.yellow}",
    "#{headers[1].underline}: #{visibility == 'private' ? visibility.red : visibility == 'public' ? visibility.green : visibility.light_black }",
    "#{headers[2].underline}: #{member_list.cyan}"
end

data = project_names.zip(visibilities, member_lists)

puts 'Creating CSV...'

create_csv(headers, data)
