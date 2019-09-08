RSpec.shared_examples "response status" do |status_code|
  it { expect(subject).to have_http_status(status_code) }
end