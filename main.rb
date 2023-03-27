require './slack_notifier'

server = WEBrick::HTTPServer.new(Port: 8000)
server.mount '', SlackNotifier
server.start
