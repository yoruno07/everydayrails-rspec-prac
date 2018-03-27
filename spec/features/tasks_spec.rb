require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    FactoryBot.create(:project,
      name: "RSpec tutorial",
      owner: user)
  }
  let!(:task) { project.tasks.create!(name: "Finish RSpec tutorial") }

  # ユーザーがタスクの状態を切り替える
  scenario "user toggles a task", js: true do
    login_as user, scope: :user
    go_to_project "RSpec tutorial"
    complete_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"

    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish RSpec tutorial"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css "label.completed", text: name
      expect(task.reload).to_not be_completed
    end
  end

  # ユーザーがタスクを追加する
  scenario "user add tasks" do
    user = FactoryBot.create(:user)
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "New Project"
    fill_in "Name", with: "test project"
    fill_in "Description", with: "to rpec test"
    click_button "Create Project"

    expect {
      visit root_path
      click_link "test project"
      click_link "Add Task"
      fill_in "Name", with: "test task"
      click_button "Create Task"
    }.to change(Task, :count).by(1)
  end
end
