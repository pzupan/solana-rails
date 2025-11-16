require 'faye/websocket'
require 'httpx'
require 'json'
require 'thread'

require_relative 'base'
require_relative 'http_methods'
require_relative 'transaction_methods'
require_relative 'websocket_methods'
#require_relative 'token/http_methods'

module SolanaRails
  class Client

    include HttpMethods
    #include Token::HttpMethods
    include TransactionMethods
    include WebsocketMethods

    BASE_URL = 'api.mainnet-beta.solana.com'

    # mainnet-beta, testnet or devnet
    def initialize(api_url=BASE_URL)
      @api_url = api_url
    end

    private
    
    def request_http(method, params = nil, &block)
      body = {
        jsonrpc: '2.0',
        method: method,
        id: 1
      }
      body[:params] = params if params

      HTTPX.post("https://#{@api_url}", json: body).then do |response|
        handle_response_http(response, &block)
      rescue => e
        context.fail!(error: "HTTP request failed: #{e}")
      end
    end

    def handle_response_http(response, &block)
      if response.try(:error).present?
        context.fail!(error: response.error.try(:message))
      elsif response.status == 200
        body = JSON.parse(response.body)
        if block_given?
          yield body
        else
          if (result = body['result']).present?
            if (value = result['value']).present?
              value
            else
              result
            end
          else
            body
          end
        end
      else
        context.fail!(error: 'Unknown failure at handle_response')
      end
    end

    def request_ws(method, params = nil, &block)
      result_queue = Queue.new
      EM.run do
        ws = Faye::WebSocket::Client.new("wss://#{@api_url}")

        ws.on :open do |event|
          body = {
            jsonrpc: '2.0',
            method: method,
            id: 1
          }
          body[:params] = params if params

          ws.send(body.to_json)
        end

        ws.on :message do |event|
          response = JSON.parse(event.data)
          if block_given?
            yield response['result']
          else
            result_queue.push(response['result'])
          end
          ws.close
        end

        ws.on :close do |event|
          ws = nil
          EM.stop
        end

        ws.on :error do |event|
          puts "WebSocket error: #{event.message}"
          result_queue.push(nil)
          ws = nil
          EM.stop
        end
      end
      result_queue.pop unless block_given?
    end
  end
end
