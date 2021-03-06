require "#{File.dirname(__FILE__)}/../../twitter/spec/spec_helper"
require 'torquebox-core'

remote_describe "tweet consumption testing" do 
  
  # Necessary for injection in examples
  include TorqueBox::Injectors

  # Deploy our apps
  deploy <<-END.gsub(/^ {4}/,'')
    application:
      root: #{File.dirname(__FILE__)}/..
    queues:
      tweets:
    environment:
      USERNAME: "#{ENV['USERNAME']}"
      PASSWORD: "#{ENV['PASSWORD']}"
  END

  it "should receive a message generated by the service" do
    queue = inject_queue('tweets')
    message = queue.receive(:timeout => 30000)
    message.should_not be_nil
    puts "", message.inspect, ""
  end

end

