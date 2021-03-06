require 'spec_helper'

describe Game do

  context "validations" do

    it { should validate_presence_of(:scheduled_for) }
    it { should have_many(:records) }
    it { should belong_to(:winner) }
    it { should have_many(:players) }
    
  end
  
  context "date handlers" do

    before(:each) do
      @upcoming_game = Factory(:game, :scheduled_for => Time.now + 1.week, :active => true)
      @last_game = Factory(:game, :scheduled_for => Time.now - 1.week, :active => true)
      @older_game = Factory(:game, :scheduled_for => Time.now - 2.weeks, :active => true)
      @cancelled_game = Factory(:game, :scheduled_for => Time.now - 3.weeks, :active => false)
    end

    it "should fetch the latest game" do 
      Game.last_played.should == @last_game
    end
    
    it "should fetch the upcoming game" do
      Game.upcoming.should == @upcoming_game
    end

    it "should fetch all previously played games, in date order" do
      Game.previous.should == [@last_game, @older_game, @cancelled_game]
    end
  end
  
  context "rankings" do 
    before(:each) do
      @last_game = Factory(:game, :scheduled_for => Time.now - 1.week, :active => true)
      @last_game.records << Factory(:record, :place => 5, :user => Factory(:user, :id => 1), :game => @last_game)
      @last_game.records << Factory(:record, :place => 4, :user => Factory(:user, :id => 2), :game => @last_game)
      @last_game.records << Factory(:record, :place => 3, :user => Factory(:user, :id => 3), :game => @last_game)
      @last_game.records << Factory(:record, :place => 2, :user => Factory(:user, :id => 4), :game => @last_game)
      @last_game.records << Factory(:record, :place => 1, :user => Factory(:user, :id => 5), :game => @last_game)
    end
    
    it "should rank players given placed rankings" do
      @last_game.players.ranked.map(&:id).should == [5,4,3,2,1]
    end
  end

end
