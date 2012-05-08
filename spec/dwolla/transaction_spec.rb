require 'spec_helper'

describe Dwolla::Transaction do
  describe "send transaction" do
    context "to a dwolla account" do
      before do
        @origin = double(:oauth_token => '1')
        @destination = '2'
        @destination_type = "dwolla"
        @payload = { :amount => 200,
                     :pin => '1234',
                     :destinationId => '2',
                     :destinationType => 'dwolla',
                     :notes => "Sending a transaction",
                     :oauth_token => '1' }

        stub_post('/transactions/send').with(:body => MultiJson.dump(@payload)).to_return(
          :body => fixture('send_transaction.json'))
      end
      it "should request the correct resource" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :destination => @destination,
                                              :destination_type => @destination_type,
                                              :description => "Sending a transaction", 
                                              :type => :send,
                                              :amount => 200,
                                              :pin => '1234')
        transaction.execute

        a_post('/transactions/send').
          with(:body => MultiJson.dump(@payload)).should have_been_made
      end

      it "should fetch the id if transaction succesfull" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :destination => @destination,
                                              :destination_type => @destination_type,
                                              :description => "Sending a transaction",
                                              :type => :send,
                                              :amount => 200,
                                              :pin => '1234')

        transaction.execute.should == 12345
        transaction.id.should == 12345
      end 
    end
    
    context "to an email address" do
      before do
        @origin = double(:oauth_token => '1')
        @destination = "user@example.com"
        @destination_type = "email"
        @payload = { :amount => 200,
                     :pin => '1234',
                     :destinationId => 'user@example.com',
                     :destinationType => 'email',
                     :notes => "Sending a transaction",
                     :oauth_token => '1' }
        stub_post('/transactions/send').with(:body => MultiJson.dump(@payload)).to_return(
                       :body => fixture('send_transaction.json'))
      end
      it "should request the correct resource" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :destination => @destination,
                                              :destination_type => @destination_type,
                                              :description => "Sending a transaction",
                                              :type => :send,
                                              :amount => 200,
                                              :pin => '1234')
                                              
        transaction.execute

        a_post('/transactions/send').
          with(:body => MultiJson.dump(@payload)).should have_been_made
      end

      it "should fetch the id if transaction succesfull" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :destination => @destination,
                                              :destination_type => @destination_type,
                                              :description => "Sending a transaction",
                                              :type => :send,
                                              :amount => 200,
                                              :pin => '1234')

        transaction.execute.should == 12345
        transaction.id.should == 12345
      end
    end

  end

  describe "request transaction" do
    context "from a dwolla account" do
      before do
        @origin = double(:oauth_token => '1')
        @source = '2'
        @source_type = 'dwolla'
        @payload = { :amount => 200,
                     :pin => '1234',
                     :sourceId => '2',
                     :sourceType => 'dwolla',
                     :notes => "Sending a transaction",
                     :oauth_token => '1' }

        stub_post('/transactions/request').with(:body => MultiJson.dump(@payload)).to_return(
          :body => fixture('request_transaction.json'))
      end

      it "should request the correct resource" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :source => @source,
                                              :source_type => @source_type,
                                              :description => "Sending a transaction",
                                              :type => :request,
                                              :amount => 200,
                                              :pin => '1234')
        transaction.execute

        a_post('/transactions/request').
          with(:body => MultiJson.dump(@payload)).should have_been_made
      end

      it "should fetch the id if transaction succesfull" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :source => @source,
                                              :source_type => @source_type,
                                              :description => "Sending a transaction",
                                              :type => :request,
                                              :amount => 200,
                                              :pin => '1234')

        transaction.execute.should == 12345
        transaction.id.should == 12345
      end
    end
    context "from an email address" do
      before do
        @origin = double(:oauth_token => '1')
        @source = 'user@example.com'
        @source_type = "email"
        @payload = { :amount => 200,
                     :pin => '1234',
                     :sourceId => 'user@example.com',
                     :sourceType => 'email',
                     :notes => "Sending a transaction",
                     :oauth_token => '1' }

        stub_post('/transactions/request').with(:body => MultiJson.dump(@payload)).to_return(
          :body => fixture('request_transaction.json'))
      end

      it "should request the correct resource" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :source => @source,
                                              :source_type => @source_type,
                                              :description => "Sending a transaction",
                                              :type => :request,
                                              :amount => 200,
                                              :pin => '1234')
        transaction.execute

        a_post('/transactions/request').
          with(:body => MultiJson.dump(@payload)).should have_been_made
      end

      it "should fetch the id if transaction succesfull" do
        transaction = Dwolla::Transaction.new(:origin => @origin,
                                              :source => @source,
                                              :source_type => @source_type,
                                              :description => "Sending a transaction",
                                              :type => :request,
                                              :amount => 200,
                                              :pin => '1234')

        transaction.execute.should == 12345
        transaction.id.should == 12345
      end      
    end
  end
end
