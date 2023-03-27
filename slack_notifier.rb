require 'httparty'
require 'webrick'
require 'yaml'

class SlackNotifier < WEBrick::HTTPServlet::AbstractServlet
  ENV = YAML.load_file('env.yml')

  def do_POST(request, response)
    unless request.body
      response.body = 'Payload is not present in params'
      response.status = 422
      return
    end

    begin
      params = JSON.parse(request.body)
    rescue JSON::ParserError => exception
      response.body = "Failed to parse JSON payload: #{exception.message}"
      response.status = 400
      return
    end
    
    if spam_notification?(params)
      send_slack_notification(params)
      response.body = 'A slack notification has been sent.'
    else
      response.body = 'The payload does not match the desired criteria.'
    end

    response.status = 200
  end

  private

  def spam_notification?(params)
    params['Type'].to_s.downcase == 'spamnotification'
  end

  def send_slack_notification(params)
    message = "New spam notification received!\nEmail: #{ params['Email'] }"
    HTTParty.post(ENV['WEBHOOK_URL'], body: { text: message }.to_json)
  end
end
