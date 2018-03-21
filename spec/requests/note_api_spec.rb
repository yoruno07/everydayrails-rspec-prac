require 'rails_helper'

RSpec.describe "NoteApis", type: :request do
  # プロジェクトに関連したノートを読み出すこと
  it "load a project's task" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, :with_notes,
              name: "Sample Project",
              owner: user)

    get api_notes_path, params: {
      user_email: user.email,
      user_token: user.authentication_token,
      project_id: project.id
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 5
    note_id = json[0]["id"]

    get api_note_path(note_id), params: {
      user_email: user.email,
      user_token: user.authentication_token,
      project_id: project.id
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["message"]).to eq "My important note"
  end
end
