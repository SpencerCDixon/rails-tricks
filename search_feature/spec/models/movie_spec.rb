require "rails_helper"

describe Movie do
  describe ".search" do
    before :each do
      @troll = FactoryGirl.create(:movie, title: "Troll 2")
      @room = FactoryGirl.create(:movie, title: "The Room")
      @troll_hunter = FactoryGirl.create(:movie, title: "Troll Hunter")
    end

    it "searches by title" do
      results = Movie.search("Room")

      expect(results).to include(@room)
      expect(results).to_not include(@troll)
      expect(results).to_not include(@troll_hunter)
    end
  end
end
