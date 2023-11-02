require 'bundler/setup'
require 'dotenv'
require 'openai'
require 'emoji'
require 'discordrb'

# Load .env file
Dotenv.load

class ChatGPT
  def initialize
    initialize_openai
    initialize_discord
    initialize_emoji
  end

  def initialize_openai
    OpenAI.configure do |c|
      c.access_token = ENV.fetch('OPENAI_KEY')
    end
    @client = OpenAI::Client.new
  end

  def initialize_discord
    @wubby = Discordrb::Bot.new token: ENV.fetch('DISCORD_TOKEN')
  end

  def initialize_emoji
    @emoji = Emoji::Index.new
  end

  def chat_response
    retry_count = 0
    max_retries = 9999
    # client = OpenAI::Client.new
    # @client
    emojis = "In your response include emojis.\n"
    while retry_count <= max_retries
      begin
        response = @client.completions(
          parameters: {
            model: 'gpt-3.5-turbo-instruct',
            prompt: 'You are a friendly companion that cares deeply about my well-being and strives to make my life more enjoyable and fulfilling.\nFriend: You are an amazing companion!' + emojis,
            max_tokens: 4040
          }
        )
        puts(response['choices'].map { |c| c['text'] })
        break
      rescue OpenAI::Error, StandardError => e
        puts "API request [InvalidRequestError] failed
          with error: #{e}"
        smiley = @emoji.find_by_moji('heart')
        return chat_response(prompt: smiley)
      end
      retry_count += 1
    end
  end

  def turbo_response
    retry_count = 0
    max_retries = 9999

    while retry_count <= max_retries
      begin
        response = @client.chat(
          parameters: {
            model: 'gpt-3.5-turbo-0301',
            messages: [{ role: 'user', content: 'What is <> in react?' }],
            temperature: 1,
            max_tokens: 4040
          }
        )
        puts response.dig('choices', 0, 'message', 'content')
        break
      rescue OpenAI::Error, StandardError => e
        puts "API request [InvalidRequestError] failed
          with error: #{e}"
        smiley = @emoji.find_by_moji('heart')
        return chat_response(prompt: smiley)
      end
      retry_count += 1
    end
  end

  def hello_emoji
    # puts 'Hello ' + Emoji.emoji_encode(':wave:')
    puts(@emoji.find_by_moji('heart'))
    puts('Hey')
  end

  def discord_bot
    @wubby.run
  end
end

chatbot = ChatGPT.new
# chatbot.discord_bot
chatbot.chat_response
chatbot.turbo_response
chatbot.hello_emoji
