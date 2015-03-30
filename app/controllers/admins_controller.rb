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

def index
  @admin = User.all
end

def show
  @admin=User.find_by_id(params[:id])
  @users = User.all
end

def individual_result
  @admin=User.find_by_id(params[:id])
  @u = User.find_by_email(params[:individual_result][:email])
end

def destroy
  session[:user_id] = nil
  redirect_to root_path
end
end
