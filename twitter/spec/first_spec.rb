require 'torquespec'
require 'open-uri'

# The twitter consumption service 
service = <<-END.gsub(/^ {4}/,'')
    application:
      root: #{File.dirname(__FILE__)}/../../twitter_service
    queues:
      tweets:
END

# The application's user interface
frontend = <<-END.gsub(/^ {4}/,'')
    application:
      root: #{File.dirname(__FILE__)}/..
END

# A remote group nested within a local on
describe "end-to-end testing" do 

  # Deploy our apps
  deploy service, frontend

  # Runs locally
  it "web tests" do
    response = open("http://localhost:8080/tweets") {|f| f.read}
    response.should include( "Last 20 tweets" ) 
  end

  remote_describe "in-container tests" do
    require 'torquebox-core'
    include TorqueBox::Injectors

    # Runs remotely (in-container)
    it "should be running remotely" do
      inject('deployment-unit').should_not be_nil
      inject('service-registry').should_not be_nil
      TorqueBox::ServiceRegistry.lookup("jboss.messaging.jms.manager").should_not be_nil
      # inject( Java::pl.goldmann.confitura.beans.TweetReader ).should_not be_nil
    end
  end

end
