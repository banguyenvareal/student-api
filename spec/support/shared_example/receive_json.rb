RSpec.shared_examples "response json" do
  it do
    subject
    output_json = JSON.parse(response.body)["student"]
    expect(output_json["id"]).to eq student.id
    expect(output_json["name"]).to eq student.name
    expect(output_json["user_id"]).to eq student.user_id
  end
end
