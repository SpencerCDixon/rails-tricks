require 'rails_helper'

feature 'User can comment on a post' do
  scenario 'successfully' do
    user = FactoryGirl.create(:user)
    sign_in_as(user)

    post = FactoryGirl.create(:post)
    visit root_path
    click_on post.title

    expect(page).to have_content(post.title)
    expect(page).to have_content(post.description)

    fill_in 'Body', with: 'This is a pretty sweet post'
    click_on 'Create comment'

    expect(page).to have_content('This is a pretty sweet post')
  end
end
