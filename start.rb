require 'bundler/setup'
require 'dotenv'
require 'openai'

# Load .env file
Dotenv.load

class ChatGPT
  def initialize
    OpenAI.configure do |c|
      c.access_token = ENV.fetch('OPENAI_KEY')
      @client = OpenAI::Client.new
      #puts client.models.retrieve(id: 'text-davinci-003')
      #puts client.models.retrieve(id: 'gpt-3.5-turbo-0301')
    end
  end

  def chat_response
    retry_count = 0
    max_retries = 9999
    #client = OpenAI::Client.new
    #@client
    while retry_count <= max_retries
      begin
        response = @client.completions(
          parameters: {
            model: 'text-davinci-003',
            prompt: 'what is 4 + 7?',
            max_tokens: 4000,
          }
        )
        puts response["choices"].map { |c| c["text"] }
        break
      rescue OpenAI::Error => e
        retry_count += 1
      end
    end
  end
end

chatbot = ChatGPT.new
chatbot.chat_response
