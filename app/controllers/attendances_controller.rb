class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user.includes(:attendances)
    @attendances = @user.attendances
  end
end
