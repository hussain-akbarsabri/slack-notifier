require 'httparty'
require 'webrick'

class SlackNotifier < WEBrick::HTTPServlet::AbstractServlet
  WEBHOOK_URL = 'https://hooks.slack.com/services/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'.freeze

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
    HTTParty.post(WEBHOOK_URL, body: { text: message }.to_json)
  end
end
