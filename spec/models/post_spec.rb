require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:topic) { create(:topic) }
  let(:user) { create(:user) }
  let(:post) { create(:post, topic: topic, user: user) }
  let(:favorite) { Favorite.create!(post: post, user: user) }
  
  it {is_expected.to have_many(:comments) }
  it {is_expected.to have_many(:votes) }
  it {is_expected.to have_many(:favorites) }
  
  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:user) }
  
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:topic) }
  it { is_expected.to validate_presence_of(:user) }
  
  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }
  
  describe "attributes" do
    it "has title, body and user attributes" do
      expect(post).to have_attributes(title: post.title, body: post.body, user: post.user) 
    end
  end
  
  describe "favorited scope filter" do
    it "returns a list of posts that the user has favorited" do
      user.favorites << favorite
      expect(Post.favorited(user).count).to eq(2)
      
      another_user = create(:user)  
      another_post = create(:post, topic: topic, user: another_user)
      another_favorite = Favorite.create(post: another_post, user: another_user)
      user.favorites << another_favorite
      
      expect(Post.favorited(user).count).to eq(3)
    end
      
    it "does not return posts that were not favorited" do
      user.favorites << favorite
      expect(Post.favorited(user).count).to eq(2)
        
      another_user = create(:user)
      another_post = create(:post, user: another_user)
      another_favorite = Favorite.create(post: another_post, user: another_user)
      another_user.favorites << another_favorite
      
      expect(Post.favorited(user).count).to eq(2)
    end
  end
  
  describe "voting" do
    before do
      3.times {post.votes.create!(value: 1) }
      2.times {post.votes.create!(value: -1) }
      @up_votes = post.votes.where(value: 1).count 
      @down_votes = post.votes.where(value: -1).count 
    end
    
    describe "#up_votes" do
      it "counts the number of votes with value = 1" do
        expect(post.up_votes).to eq(@up_votes)
      end
    end
    
    describe "#down_votes" do
      it "counts the number of votes wtih value = -1" do
        expect(post.down_votes).to eq(@down_votes)
      end
    end
    
    describe "#points" do
      it "returns the sum of all up and down votes" do
        expect(post.points).to eq(@up_votes - @down_votes)
      end
    end
    
    describe "#create_vote" do
      it "sets the post up_votes to 1" do
        post = topic.posts.new(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
        post.save
        expect(post.up_votes).to eq(1)
      end
      
      it "calls #create_vote when a post is created" do
        post = topic.posts.new(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
        expect(post).to receive(:create_vote)
        post.save
      end
      
      it "associates the vote with the post owner" do
        expect(post.votes.first.user).to eq(post.user)
      end
    end
    
    describe "#update_rank" do
      it "calculates the correct rank" do
        post.update_rank
        expect(post.rank).to eq(post.points + (post.created_at - Time.new(1970,1,1)) / 1.day.seconds)
      end
      
      it "updates the rank when an up vote is created" do
        old_rank = post.rank
        post.votes.create!(value: 1)
        expect(post.rank).to eq(old_rank + 1)
      end
      
      it "updates the rank when a down vote is created" do
        old_rank = post.rank
        post.votes.create!(value: -1)
        expect(post.rank).to eq(old_rank - 1)
      end
    end
  end
end
