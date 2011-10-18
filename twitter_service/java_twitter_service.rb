require 'java'

class TweetListener
  include Java::twitter4j.StatusListener

  def initialize(queue)
    @queue = queue
    @count = 0
  end

  def on_deletion_notice(notice)
  end

  def on_status(status)
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

  def on_exception(error)
    puts "Something bad happened: #{error}"
  end
end

class JavaTwitterService
  def initialize(options = {})
    @keywords = options['keywords']
    @queue = TorqueBox::Messaging::Queue.new(options['queue'])
    @count = 0
  end

  def start
    puts "Starting new TwitterService!"

    cb = Java::twitter4j.conf.ConfigurationBuilder.new
    cb.setDebugEnabled(true)
    cb.setOAuthConsumerKey(ENV['CONSUMER_KEY']).setOAuthConsumerSecret(ENV['CONSUMER_SECRET']).setOAuthAccessToken(ENV['TOKEN']).setOAuthAccessTokenSecret(ENV['TOKEN_SECRET'])

    @twitter_stream = Java::twitter4j.TwitterStreamFactory.new(cb.build).get_instance

    @thread = Thread.new { run }
  end

  def stop
    puts "Stopping Twitter client..."
    @twitter_stream.shutdown
  end

  def run
    puts "Starting Twitter client..."

    @twitter_stream.add_listener(TweetListener.new(@queue))
    @twitter_stream.filter(Java::twitter4j.FilterQuery.new(0, nil, @keywords.to_a.to_java(:string)))
  end
end

