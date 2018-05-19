require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:project) {
    FactoryBot.create(:project,
      name: "Default Project",
      owner: user)
  }

  # ユーザーは新しいプロジェクトを作成する
  scenario "user create a new project" do
    login_as user, scope: :user
    visit root_path

    expect {
      click_link "New Project"
      fill_in_name "Test Project"
      fill_in_description "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  # ユーザーがプロジェクトを編集する
  scenario "user edit a project" do
    login_as user, scope: :user
    visit root_path

    click_link "Default Project"
    click_link "Edit"
    fill_in_name "Edited Project"
    fill_in_description "Test Description"
    click_button "Update Project"

    aggregate_failures do
      expect(project.reload.name).to eq "Edited Project"
      expect(project.reload.description).to eq "Test Description"
    end
  end

  def fill_in_name(with)
    fill_in "Name", with: with
  end

  def fill_in_description(with)
    fill_in "Description", with: with
  end

  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    login_as user, scope: :user

    visit project_path(project)
    expect(page).to_not have_content "Completed"
    click_button "Complete"

    expect(project.reload.completed?).to be true
    expect(page).to \
      have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
end
