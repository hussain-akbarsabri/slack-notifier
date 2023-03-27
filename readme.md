# SlackNotifier
  An endpoint to recieve a json payload. If payload matches a desired criteria, it sends a slack alert.

# Gems
  - httparty
  - webrick
  - yaml

# System dependencies
  - Ruby 2.7.7

# Setup Instructions
  - Unzip/clone the project
  - Set your WEBHOOK_URL in env.yml
  - Run 'ruby main.rb' in project terminal
  - Send a POST request with payload
  - go to http://localhost:8000/
