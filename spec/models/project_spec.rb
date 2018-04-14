require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    @user = FactoryBot.create(:user)
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

  # たくさんのメモが付いていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # プロジェクト名の重複テスト
  describe "project name test when user create " do
    # ユーザー単位では重複したプロジェクト名を許可しないこと
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
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
