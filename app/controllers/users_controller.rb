class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # UserMailer.welcome_email(@user).deliver_now
      login(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update!(user_params)
    render :show
  end

  def show
    if current_user
      render :show
    else
      redirect_to(new_session_url)
    end

  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :profile_photo, :header_photo)
  end

end
