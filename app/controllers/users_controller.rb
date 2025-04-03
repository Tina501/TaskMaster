class UsersController < ApplicationController
  def search
    @users = User.where.not(id: current_user.id)
                 .where("email ILIKE ?", "%#{params[:q]}%")
                 .limit(10)
                 .select(:id, :email)

    render json: @users
  end
end
