require 'faye/websocket'
require 'httpx'
require 'json'
require 'thread'

require_relative 'base'
require_relative 'http_methods'
require_relative 'transaction_methods'
require_relative 'websocket_methods'
require_relative 'token/http_methods'

module SolanaRails
  class Client

    include HttpMethods
    include Token::HttpMethods
    include TransactionMethods
    include WebsocketMethods

    # mainnet-beta, testnet or devnet
    def initialize(api_network='mainnet-beta')
      @api_network = api_network
    end

    private
    
    def request_http(method, params = nil, &block)
      body = {
        jsonrpc: '2.0',
        method: method,
        id: 1
      }
      body[:params] = params if params

      HTTPX.post("https://api.#{@api_network}.solana.com", json: body).then do |response|
        handle_response_http(response, &block)
      rescue => e
        puts "HTTP request failed: #{e}"
      end
    end

    def handle_response_http(response, &block)
      if response.status == 200
        result = JSON.parse(response.body)
        if block_given?
          yield result
        else
          result
        end
      else
        raise "Request failed"
      end
    end

    def request_ws(method, params = nil, &block)
      result_queue = Queue.new
      EM.run do
        ws = Faye::WebSocket::Client.new("wss://api.#{@api_network}.solana.com")

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
