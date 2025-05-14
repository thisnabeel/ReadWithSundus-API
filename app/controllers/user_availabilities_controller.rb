class UserAvailabilitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_availabilities = current_user.user_availabilities
  end

  def new
    @user_availability = UserAvailability.new
  end

  def toggle
    day = params[:user_availability][:day]
    start_time_str = params[:user_availability][:start_time]
    end_time_str = params[:user_availability][:end_time]

    existing = current_user.user_availabilities.find_by(day: day, start_time: start_time_str.in_time_zone)
    if existing
      existing.destroy
    else
      current_user.user_availabilities.create!(
        day: day,
        start_time: start_time_str.in_time_zone,
        end_time: end_time_str.in_time_zone,
        timezone: 'America/Los_Angeles'
      )
    end

    @day = day
    @user_availabilities = current_user.user_availabilities

    respond_to do |format|
      format.turbo_stream
    end
  end




  def create
    @user_availability = current_user.user_availabilities.new(user_availability_params)
    @user_availability.timezone = 'America/Los_Angeles'

    if @user_availability.save
      day = @user_availability.day
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("availabilities_#{day}", partial: 'user_availabilities/day', locals: { day: day, user_availabilities: current_user.user_availabilities }) }
        format.html { redirect_to user_availabilities_path, notice: 'Availability was successfully created.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("error", partial: "shared/error", locals: { errors: @user_availability.errors.full_messages }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_availability = current_user.user_availabilities.find(params[:id])
    @user_availability.destroy
    redirect_to user_availabilities_path, notice: 'Availability removed successfully.'
  end

  private

  def user_availability_params
    params.require(:user_availability).permit(:day, :start_time, :end_time, :timezone)
  end
end