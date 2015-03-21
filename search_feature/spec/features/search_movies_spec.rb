require "rails_helper"

feature "search movies" do
  scenario "fill in search form and view results" do
    troll = FactoryGirl.create(:movie, title: "Troll 2")
    room = FactoryGirl.create(:movie, title: "The Room")
    rat_race = FactoryGirl.create(:movie, title: "Rat Race")
    troll_hunter = FactoryGirl.create(:movie, title: "Troll Hunter")

    visit "/movies"
    fill_in "Search", with: "Troll"
    click_button "Search Movies"

    expect(page).to have_link("Troll 2", href: movie_path(troll))
    expect(page).to have_link("Troll Hunter", href: movie_path(troll_hunter))
    expect(page).to_not have_content("The Room")
    expect(page).to_not have_content("Rat Race")
  end
end
