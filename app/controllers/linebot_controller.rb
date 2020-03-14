class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client

    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["733936fd7268b280dbd69cfd772c6c7c"]
      config.channel_token = ENV["1bb36fb6-b78d-476d-a9ce-54db075bea2a"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
        end
      end
    }

    head :ok
  end
end
