if Rails.env.development?
  require 'rest-client'
end

task :mailgun => ['mailgun:before']
namespace :mailgun do
  task :before do
    unless Rails.env.development?
      puts "This rake task is designed to run in development only."
      exit
    end

    puts "Required ENV Variables:"
    %w(MAILGUN_API_KEY INCOMING_EMAIL_DOMAIN).each do |key|
      unless ENV[key]
        puts "#{key} environment variable not found. Please check .env"
        exit
      end
      puts "\t#{key}: #{ENV[key]}"
    end

    response = RestClient.get "https://api:#{ENV['MAILGUN_API_KEY']}"\
    "@api.mailgun.net/v2/routes", :params => {
      :limit => 100
    }
    data = JSON.parse(response)['items']
    puts "\nhackraise Managed Routes:"

    hackraise_route_detected = false
    data.each do |route|
      if /\[hackraise\]/.match route['description']
        puts "\t" + route['id']
        puts "\t" + route['description'] + "\n\n"
        hackraise_route_detected = true
      end
    end

    unless hackraise_route_detected
      puts "No Hackraise Managed Routes Detected. Run rake mailgun:create_route to add one."
    end
  end

  task :create_route => :before do
    puts "This task will create a new route in your mailgun account to forward
    messages to Hackraise via webhook. Check README.md for more instructions."

    print "Domain hackraise is running on (http://DOMAIN/webhooks/mailgun):  "
    domain = STDIN.gets.chomp
    if domain.length < 2
      puts "Invalid Domain"
      exit
    end

    data = Hash.new
    data[:priority] = 1
    data[:description] = "[hackraise] .*@#{ENV['INCOMING_EMAIL_DOMAIN']} ->"\
    " http://#{domain}/incoming_emails/mailgun (#{Time.now.utc.to_s})"

    data[:expression] = "match_recipient('.*@#{ENV['INCOMING_EMAIL_DOMAIN']}')"
    data[:action] = ["forward('http://#{domain}/webhooks/mailgun')", "stop()"]

    puts "Will create the following rule:"
    %w(priority description expression action).each do |key|
      puts "\t#{key.titlecase}: #{data[key.to_sym]}"
    end
    print "Are you sure? [yN]:  "
    case STDIN.gets.chomp
    when 'y', 'yes'
      puts RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}"\
      "@api.mailgun.net/v2/routes", data
    else
      puts "No"
      exit
    end
  end
end
