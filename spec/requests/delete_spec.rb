require 'rails_helper'

RSpec.describe Api, type: :request do
  describe 'delete a student' do
    let!(:student) { create(:student) }

    context 'params not enough' do
      subject do
        delete "/api/v1/students/#{ student.id }"
        response
      end

 
      include_examples "response status", 400

      it 'return error message' do
        subject
        expect( JSON.parse(response.body)["error"]).to eql('user_id, is_admin are missing, at least one parameter must be provided')
      end
    end

    context 'student not exist' do
      let(:params) do
        { user_id: student.user_id }
      end

      subject do
        allow(Student).to receive(:find_by).with(anything).and_return(nil)
        delete "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples "response status", 404

    end

    context 'student is found, params include only is_admin params has value true' do
      let(:params) do
        { user_id: student.user_id, is_admin: "true" }
      end

      subject do
        delete "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      it 'number of students decrement by 1' do
        expect{ subject }.to change(Student, :count).by(-1)
      end

      include_examples "response status", 200

      include_examples 'response json'
    end

    context 'student is found, params include only is_admin params has value false' do
      let(:params) do
        { is_admin: "false" }
      end

      subject do
        delete "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples "response status", 400
    end
    
    context 'student is found, prams include only user_id params has valid value' do
      let(:params) do
        { user_id: student.user_id }
      end

      subject do
        delete "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples 'response status', 200

      include_examples 'response json'

      it 'number of students decrement by 1' do
        expect{ subject }.to change(Student, :count).by(-1)
      end
    end

    context 'student is found, prams include only user_id params has invalid value' do
      let(:params) do
        { user_id: student.user_id + 10 }
      end

      subject do
        delete "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      include_examples 'response status', 400
    end
  end
end
