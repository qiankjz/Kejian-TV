# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mongo::Voter do
  before :all do
    @post1 = Post.create!(:title => 'post_1')
    @post2 = Post.create!(:title => 'post_2')

    @user1 = User.create!
    @user2 = User.create!
  end
  
  context "just created" do
    it 'validates' do
      Post.voted_by(@user1).should be_empty
      Post.up_voted_by(@user1).should be_empty
      Post.down_voted_by(@user1).should be_empty
      @user1.voted?(@post1).should be_false
      @user1.voted?(@post2).should be_false
      
      Post.voted_by(@user2).should be_empty
      Post.up_voted_by(@user2).should be_empty
      Post.down_voted_by(@user2).should be_empty
      @user2.voted?(@post1).should be_false
      @user2.voted?(@post2).should be_false
    end
    
    it 'revote has no effect' do      
      @user2.vote(:revote => true, :votee => @post2, :value => :down)
      @post2.reload
      
      @post2.votes_count.should == 0
      @post2.votes_point.should == 0
    end
  end
  
  context 'user1 vote up post1 the first time' do
    before :all do    
      @user1.vote(:revote => '', :votee_id => @post1.id, :votee_class => Post, :value => :up)
      @post1.reload
    end
    
    it 'validates' do
      @post1.votes_count.should == 1
      @post1.votes_point.should == 1

      @user1.vote_value(@post1).should == :up
      @user2.vote_value(:votee_class => Post, :votee_id => @post1.id).should be_nil
      
      @user1.should be_voted(@post1)
      @user2.should_not be_voted(:votee_class => Post, :votee_id => @post1.id)
      
      Post.voted_by(@user1).to_a.should == [ @post1 ]
      Post.up_voted_by(@user1).to_a.should == [ @post1 ]
      Post.down_voted_by(@user1).to_a.should be_empty
      Post.voted_by(@user2).to_a.should be_empty
      
      User.up_voted_for(@post1).to_a.should == [ @user1 ]
      User.down_voted_for(@post1).to_a.should be_empty
      User.voted_for(@post1).to_a.should == [ @user1 ]
    end
    
    it 'user1 vote post1 has no effect' do
      @user1.vote(:votee => @post1, :value => :up)
      @post1.reload
      
      @post1.votes_count.should == 1
      @post1.votes_point.should == 1
      
      @post1.vote_value(@user1.id).should == :up
    end
  end
  
  context 'user2 vote down post1 the first time' do
    before :all do
      @user2.vote(:votee => @post1, :value => :down)
      @post1.reload
    end
    
    it 'validates' do
      @post1.votes_count.should == 2
      @post1.votes_point.should == 0
      
      @user1.vote_value(@post1).should == :up
      @user2.vote_value(@post1).should == :down

      Post.voted_by(@user1).to_a.should == [ @post1 ]
      Post.voted_by(@user2).to_a.should == [ @post1 ]
      Post.up_voted_by(@user2).to_a.should be_empty
      Post.down_voted_by(@user2).to_a.should == [ @post1 ]

      User.up_voted_for(@post1).to_a.should == [ @user1 ]
      User.down_voted_for(@post1).to_a.should == [ @user2 ]
      User.voted_for(@post1).to_a.should == [ @user1, @user2 ]
    end
  end
  
  context 'user1 change vote on post1 from up to down' do
    before :all do
      @user1.vote(:votee => @post1, :value => :down)
      @post1.reload
    end
    
    it 'validates' do
      @post1.votes_count.should == 2
      @post1.votes_point.should == -2

      @user1.vote_value(@post1).should == :down
      @user2.vote_value(@post1).should == :down

      Post.voted_by(@user1).to_a.should == [ @post1 ]
      Post.voted_by(@user2).to_a.should == [ @post1 ]
    end
  end
  
  context 'user1 vote down post2 the first time' do
    before :all do
      @user1.vote(:new => 'abc', :votee => @post2, :value => :down)
      @post2.reload
    end
    
    it 'validates' do
      @post2.votes_count.should == 1
      @post2.votes_point.should == -1
      
      @user1.vote_value(@post2).should == :down
      @user2.vote_value(@post2).should be_nil

      Post.voted_by(@user1).to_a.should == [ @post1, @post2 ]
    end
  end
  
  context 'user1 change vote on post2 from down to up' do
    before :all do
      @user1.vote(:revote => 'abc', :votee => @post2, :value => :up)
      @post2.reload
    end
    
    it 'validates' do
      @post2.votes_count.should == 1
      @post2.votes_point.should == 1
      
      @user1.vote_value(@post2).should == :up
      @user2.vote_value(@post2).should be_nil

      Post.voted_by(@user1).size.should == 2
      Post.voted_by(@user1).should be_include @post1
      Post.voted_by(@user1).should be_include @post2
    end
  end  
end
