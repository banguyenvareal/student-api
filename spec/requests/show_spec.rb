require 'rails_helper'

RSpec.describe Api, type: :request do

  describe "get" do
    let!(:student) { create(:student) }

    context 'student not exist' do
      subject do
        get "/api/v1/students/#{student.id + 1}"
        response
      end

      it 'returns a status by id' do
        subject
        expect(response.status).to eq 404
      end
    end

    context 'student exist' do
      subject do
        get "/api/v1/students/#{student.id}"
        response
      end
      it 'return a status 200' do
        subject
        expect(response.status).to eq 200
      end

      include_examples 'response json'
    end
  end
end
