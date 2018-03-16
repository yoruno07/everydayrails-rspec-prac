require 'rails_helper'

RSpec.feature "Users", type: :feature do
  # ユーザーが名前を変更する
  scenario "change user name" do
    user = FactoryBot.create(:user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "#{user.name}"
    fill_in "First name", with: 'aaa'
    fill_in "Last name", with: 'bbb'
    fill_in "Current password", with: user.password
    click_button "Update"

    expect(user.reload.first_name).to eq "aaa"
    expect(user.reload.last_name).to eq "bbb"
  end
end
