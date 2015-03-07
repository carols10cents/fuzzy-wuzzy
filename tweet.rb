require 'twitter'
require_relative 'fuzzer'

rust_to_tweet = nil
loop do
  fw = FuzzyWuzzy.new
  rust_to_tweet = fw.generate_rust
  characters = rust_to_tweet.length
  break if characters > 100 && characters < 140
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_SECRET']
end

client.update(rust_to_tweet)
