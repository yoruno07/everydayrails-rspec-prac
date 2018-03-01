require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@examplae.com",
      password: "dottle-nouveau-pavilion-tights-furze",
      )
  end

  # ユーザー、プロジェクト名があれば有効な状態であること
  it "is valid with a user, name" do
    project = Project.new(
      name: "Test Project",
      owner: @user,
      )
    expect(project).to be_valid
  end

  # プロジェクト名がなければ無効な状態であること
  it "is invalid without a name" do
    project = Project.new(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # プロジェクト名の重複テスト
  describe "project name test when user create " do
    # 同ユーザーで重複する時
    context "same user create same name of project" do
    # ユーザー単位では重複したプロジェクト名を許可しないこと
      it "does not allow duplicate project names per user" do
        @user.projects.create(
          name: "Test Project"
          )
        new_project = @user.projects.build(
          name: "Test Project",
          )
        new_project.valid?
        expect(new_project.errors[:name]).to include("has already been taken")
      end
    end

    # 別ユーザーで重複する時
    context "other user create same name of project" do
      # 二人のユーザーが同じ名前を使うことは許可すること
      it "allows two users to share a project name" do
        @user.projects.create(
          name: "Test Project",
          )
        other_user = User.create(
          first_name: "Jane",
          last_name: "Tester",
          email: "janetester@examplae.com",
          password: "dottle-nouveau-pavilion-tights-furze",
          )
        other_project = other_user.projects.build(
          name: "Test Project",
          )
        expect(other_project).to be_valid
      end
    end
  end

  # 遅延ステータス
  describe "late status" do
    # 締切日を過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュールとおりであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュールとおりであること
    it "is on time when the due date in the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
