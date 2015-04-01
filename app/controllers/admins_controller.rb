class AdminsController < ApplicationController
  layout 'plain'
  before_filter :admin_login, except: [:index,:check_admin]
  def check_admin
    @user = User.find_by_email(params[:email])
    if @user.present? && (@user.has_role? :Admin)
     session[:user_id] = @user.id
     redirect_to admin_path(@user)
   else
    redirect_to root_path
  end
end
def result_email
    @user = User.find_by_email(params[:individual_result][:email])
    respond_to do |format|
      format.json { render :json => !!@user }
    end
  end

def show
  @admin=User.find_by_id(params[:id])
  @users = User.all
end

def individual_result
  @admin=User.find_by_id(params[:id])
  if params[:user_id].present?
    @u=User.find_by_id(params[:user_id])
  else
    @u = User.find_by_email(params[:individual_result][:email])
  end
end

def destroy
  session[:user_id] = nil
  redirect_to admins_path
end
end
