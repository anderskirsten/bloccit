require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  let(:advertisement) { Advertisement.create!(title: "Ad Title", body: "Ad Body", price: 5) }
  
  describe "attributes" do
     it "has a title, body and price attribute" do
        expect(advertisement).to have_attributes(title: "Ad Title", body: "Ad Body", price: 5) 
     end
  end
end
