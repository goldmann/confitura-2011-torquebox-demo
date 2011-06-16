require 'spec_helper'
require 'open-uri'

# A remote group nested within a local on
describe "end-to-end testing" do 

  # Deploy our apps
  deploy <<-END.gsub(/^ {4}/,'')
    application:
      root: #{File.dirname(__FILE__)}/..
    queues:
      tweets:
  END

  # Runs locally
  it "web tests" do
    response = open("http://localhost:8080/tweets") {|f| f.read}
    response.should include( "Last 20 tweets" ) 
  end

  # Runs locally using capybara DSL
  it "should work" do
    visit "/tweets"
    page.should have_content( "Last 20 tweets" )
    puts "", page.source, ""
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
