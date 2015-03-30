class AdminsController < ApplicationController
  layout 'plain'
  def check_admin
    @user = User.find_by_email(params[:email])
    if @user.present? && (@user.has_role? :Admin)
     session[:user_id] = @user.id
     redirect_to admin_path(@user)
   else
    redirect_to root_path
  end
end

def show
  @users = User.all
end

def all_result
  @users = User.all
end

def individual_result
  @u = User.find_by_email(params[:individual_result][:email])
end

def destroy
  session[:user_id] = nil
  redirect_to root_path
end
end
