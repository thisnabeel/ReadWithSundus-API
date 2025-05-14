class EnrollmentRequestsController < ApplicationController

  def index 
    guardians = User.where("roles @> ?", '["guardian"]')
    guardians_with_students = guardians.map do |guardian|
      {
        guardian: guardian,
        students: guardian.students
      }
    end
    render json: guardians_with_students
  end

  def new
    @guardian = User.new(roles: ['guardian'])
    @guardian.children.build(roles: ['student'])
  end

  def create
    guardian_data = params.require(:guardian).permit(
      :first_name, :last_name, :phone_number, :email, :password, :password_confirmation, :birthday
    )

    children_data = params.require(:children).map do |child|
      child.permit(:first_name, :last_name, :birthday)
    end

    @guardian = User.new(guardian_data.merge(roles: ['guardian']))

  
    if @guardian.save
      children_status = true
      students = []
      children_data.each do |child|
        student = Student.new(child.merge(guardian_id: @guardian.id))
        unless student.save
          render json: { errors: "Student Not Saved!"}
          return
        end
        students << student
      end
      render json: { message: 'Enrollment request created successfully', guardian: @guardian, students: students }, status: :created
    else
      render json: { errors: @guardian.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def add_child
    @child = User.new(roles: ['student'])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @guardian = User.find_by(id: params[:id])

    if @guardian
      @guardian.destroy
      render json: { message: 'Guardian deleted successfully' }, status: :ok
    else
      render json: { error: 'Guardian not found' }, status: :not_found
    end
  end

  private

  def guardian_params
    params.require(:guardian).permit(
      :email, :password, :password_confirmation, :birthday, :phone_number
    )
  end
end
