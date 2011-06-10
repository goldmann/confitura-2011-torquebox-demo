require 'rubygems'
require 'tweetstream'

class JavaTwitterService
  def initialize(options = {})
    @keywords = options['keywords']
    @queue = TorqueBox::Messaging::Queue.new(options['queue'])
    @count = 0
  end

  def start
    puts "Starting new TwitterService!"

    @client = TweetStream::Client.new(ENV['USERNAME'], ENV['PASSWORD'])
    @client.on_error { |message| puts "Twitter error: #{message}" }
    @client.on_delete { |status_id, user_id| Tweet.delete(status_id) }

    @thread = Thread.new { run }
  end

  def stop
    @done = true
    @thread.join
  end

  def run
    puts "Starting Twitter client..."

    @client.track(*@keywords) do |status|

      if @done
        puts "Stopping Twitter client..."
        @client.stop
        return
      end

      puts "Current Java tweets received: #{@count}" if @count % 10 == 0

      @queue.publish({
        :id => status.id,
        :message => status.text,
        :username => status.user.screen_name
      },
      :properties => {
        'language' => (status.text =~ /java/ ? 'java' : 'other')
      })

      @count += 1

    end  

  end
end
