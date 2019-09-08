require 'rails_helper'

RSpec.describe Api, type: :request do
  describe 'create new student' do
    context 'params fully and valid' do
      let(:params) do
        { name: 'student 1', user_id: 11}
      end

      subject do
        post '/api/v1/students',
        params: params
        response
      end

      it 'return status 200' do
        subject
        expect(response.status).to eq 201
      end

      it 'display student has been created' do
        subject
        output = JSON.parse(response.body)["student"]
        student = Student.last
        expect(output["id"]).to eq student.id
        expect(output["name"]).to eq student.name
        expect(output["user_id"]).to eq student.user_id
      end
    end

    context 'Params missing user_id' do
      let(:params) do
        { name: 'student 1' }
      end

      subject do
        post '/api/v1/students',
        params: params
        response
      end

      include_examples "response status", 400

      it 'notify error' do
        subject
        expect(JSON.parse(response.body)["error"]).to eq 'user_id is missing, user_id is empty'
      end
    end

    context 'Params missing name' do
      let(:params) do
        { user_id: 111 }
      end

      subject do
        post '/api/v1/students',
        params: params
      end

      it 'return 400 status' do
        subject
        expect(response.status).to eq 400
      end

      it 'notify error' do
        subject
        expect(JSON.parse(response.body)["error"]).to eq 'name is missing, name is empty'
      end
    end
  end
end
