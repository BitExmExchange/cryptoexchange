require "byebug"

module Cryptoexchange::Exchanges
  module Jex
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::Jex::Market::API_URL}"
        
        def fetch
          output = super
          adapt(output)
        end

        def adapt(output)
          market_pairs = []
          output.map do |pair, ticker|
            if !derivative(pair)
              base, target = pair.split('/')
              puts base, target
              market_pairs << Cryptoexchange::Models::MarketPair.new(
                base: base.upcase,
                target: target.upcase,
                market: Jex::Market::NAME
              )
            end
          end
          market_pairs
        end

        def derivative(pair)
          etf = /(ETF)/ =~ pair
          option = /(PUT|CALL)/ =~ pair
          unknown = /(周)/ =~ pair
          if etf && !pair.include?("/")
            true
          elsif unknown && !pair.include?("/")
            true  
          elsif option && pair.count("/") > 1
            true
          elsif option
            true
          else
            false
          end
        end

      end
    end
  end
end
