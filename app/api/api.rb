class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  
  helpers do
    params :control_params do
      at_least_one_of :user_id, :is_admin
    end

    def delete_student(student, params)
      if params[:is_admin] == "true" || params[:user_id].to_i == student.user_id
        student.destroy!
      else
        status 400
      end
    end

    def update_student(student, params)
      if params[:is_admin] == "true" || params[:user_id].to_i == student.user_id
        student.update({ name: params[:name] })
        student
      else
        status 400
      end
    end
  end

  resource :students do
    desc 'List students'

    get do
      return status(204) if Student.all.empty?

      Student.all
    end

    desc 'Create a new stuent'

    params do
      requires :name, type: String, allow_blank: false
      requires :user_id, type: Integer, allow_blank: false
    end

    post do
      Student.create({
        name: params[:name],
        user_id: params[:user_id]
      })
    end

    desc 'delete a student'

    params do
      requires :id, type: String
      use :control_params
    end

    delete ':id' do

      # return status(400) if params.count > 3


      student = Student.find_by(id: params[:id])
      return status(404) unless student

      if params.has_key?(:user_id) && params.has_key?(:is_admin)
        delete_student(student, {user_id: params[:user_id], is_admin: params[:is_admin] })
      else
        return delete_student(student, { user_id: params[:user_id] }) if params.has_key?(:user_id)

        return delete_student(student, { is_admin: params[:is_admin] }) if params.has_key?(:is_admin)
      end
    end

    desc 'update a student'

    params do
      requires :id, type: String
      requires :name, type: String, allow_blank: false
      use :control_params
    end

    put ':id' do
      # return status(400) if params.count > 4

      student = Student.find_by(id: params[:id])
      return status(404) unless student

      if params.has_key?(:user_id) && params.has_key?(:is_admin)
        update_student(student, {user_id: params[:user_id], is_admin: params[:is_admin], name: params[:name] })
      else
        return update_student(student, { user_id: params[:user_id], name: params[:name] }) if params.has_key?(:user_id)

        return update_student(student, { is_admin: params[:is_admin], name: params[:name] }) if params.has_key?(:is_admin)
      end
    end

    desc 'show a student'

    params do
      requires :id, type: String
    end

    get ':id' do
      student = Student.find_by(id: params[:id])
      return student if student

      status(404)
    end
  end
end
