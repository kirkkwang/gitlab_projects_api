require 'csv'

def create_csv(headers, data)
  filename = 'gitlab_projects.csv'
  CSV.open(filename, 'wb') do |csv|
    csv << headers

    data.each do |col|
      csv << col
    end
  end
  
  puts "\n#{filename} created!\n".green
end