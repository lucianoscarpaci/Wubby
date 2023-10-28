require 'bundler/setup'
require 'dotenv'
require 'openai'

# Load .env file
Dotenv.load

class ChatGPT
  def initialize
    # client = OpenAI::Client.new(access_token: ENV.fetch('OPENAI_API_KEY'))
    OpenAI.configure do |c|
      c.access_token = ENV.fetch('OPENAI_KEY')
      client = OpenAI::Client.new
      puts client.models.retrieve(id: 'text-davinci-003')
    end
  end

  def turbo_response; end
end

chatbot = ChatGPT.new
