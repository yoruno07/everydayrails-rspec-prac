require 'rails_helper'

RSpec.feature "ResetPasswords", type: :feature do
  include ActiveJob::TestHelper
  let(:user) { FactoryBot.create(:user) }

  # パスワードリセットのメールが送信される
  scenario "user get password reset mail" do
    visit root_path
    click_link "Sign in"
    click_link "Forgot your password?"

    perform_enqueued_jobs do
      fill_in "Email", with: user.email
      click_button "Send me reset password instructions"

      expect(page).to \
        have_content "You will receive an email with instructions on how to reset your password in a few minutes."
      expect(current_path).to eq new_user_session_path
    end

    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq [user.email]
      expect(mail.body).to match "Hello #{user.email}"
      expect(mail.body).to match "change your password."
    end
  end
end
