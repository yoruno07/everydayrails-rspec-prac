require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { FactoryBot.create(:project) }

  # プロジェクトと名前があれば有効な状態であること
  it "is valid with a project and name" do
    task = Task.new(
      project: project,
      name: "Test task",
      )
    expect(task).to be_valid
  end

  # プロジェクトがなければ無効な状態であること
  it { is_expected.to validate_presence_of :project }

  # 名前がなければ無効な状態であること
  it { is_expected.to validate_presence_of :name }

end
