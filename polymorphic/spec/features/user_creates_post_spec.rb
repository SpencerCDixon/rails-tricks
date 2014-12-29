require 'rails_helper'

feature 'User can create a post' do
  scenario 'successfully' do
    user = FactoryGirl.create(:user)
    sign_in_as(user)

    visit root_path
    click_on 'New post'

    fill_in 'Title', with: 'Polymorphic Associations are cool!'
    fill_in 'Description', with: 'There pretty cool to learn about'
    click_on 'Create post'

    expect(page).to have_content( 'Polymorphic Associations are cool!' )
    expect(page).to have_content( 'There pretty cool to learn about' )
    expect(page).to have_content( 'Post successfully created' )
  end

  scenario 'visitor cannot create post' do
    visit root_path
    expect(page).to_not have_content('New post')
  end
end
