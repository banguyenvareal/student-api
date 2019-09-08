require 'rails_helper'

RSpec.describe Api, type: :request do
  describe 'update a student' do
    let!(:student) { create(:student) }
    let(:new_name) { 'new name' }

    context 'params not enough' do
      subject do
        put "/api/v1/students/#{ student.id }"
        response
      end

      include_examples "response status", 400

      it 'return error message' do
        subject
        expect( JSON.parse(response.body)["error"]).to eql('name is missing, name is empty, user_id, is_admin are missing, at least one parameter must be provided')
      end
    end

    context 'student not exist' do
      let(:params) do
        { user_id: student.user_id, name: new_name }
      end

      subject do
        allow(Student).to receive(:find_by).with(anything).and_return(nil)
        put "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples "response status", 404

    end

    context 'student is found, params include only is_admin params has value true' do
      let(:params) do
        { user_id: student.user_id, is_admin: "true", name: new_name }
      end

      subject do
        put "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples "response status", 200

      it 'receive student with updated data' do
        subject
        student.reload
        output_json = JSON.parse(response.body)["student"]
        expect(output_json["id"]).to eq student.id
        expect(output_json["name"]).to eq student.name
        expect(output_json["user_id"]).to eq student.user_id
      end
    end

    context 'student is found, params include only is_admin params has value false' do
      let(:params) do
        { is_admin: "false", name: new_name }
      end

      subject do
        put "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples "response status", 400
    end
    
    context 'student is found, prams include only user_id params has valid value' do
      let(:params) do
        { user_id: student.user_id, name: new_name }
      end

      subject do
        put "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples 'response status', 200

      it 'receive student with updated data' do
        subject
        student.reload
        output_json = JSON.parse(response.body)["student"]
        expect(output_json["id"]).to eq student.id
        expect(output_json["name"]).to eq student.name
        expect(output_json["user_id"]).to eq student.user_id
      end
    end

    context 'student is found, prams include only user_id params has invalid value' do
      let(:params) do
        { user_id: student.user_id + 10, name: new_name }
      end

      subject do
        put "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples 'response status', 400
    end
  end
end
