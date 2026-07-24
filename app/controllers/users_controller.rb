class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully!"
    else
  puts "========== USER ERRORS =========="
  puts @user.errors.full_messages
  puts "================================="
  render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :address,
      :city,
      :province_id,
      :postal_code,
      :phone
    )
  end
end
