class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :create]
  def check_email
    @user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      format.json { render :json => !@user  }
    end
  end

  def index
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to start_user_path(@user)
    else
      render 'index'
    end
  end

  def start
    @user = User.find(params[:id])
    @question_ids = Question.all.collect(&:id).first(20).shuffle.sample(16)
    @qwinix = Question.all.collect(&:id).last(21)
  end

  def show
    @user = User.find(params[:id])
    @i = Uanswer.where(user_id: @user.id).count
    @i += 1
    @question_ids = params[:question_ids]
    @qwinix_ids = params[:qwinix_ids]
    if @i <=15
      @question = Question.find_by_id(@question_ids[@i])
      @choices = Qchoice.where(question_id: @question.id)
    elsif @i > 15 && @i <= 20
      @question = Question.find_by_id(@qwinix_ids[@i])
      @choices = Qchoice.where(question_id: @question.id)
    else
      redirect_to result_user_path
    end
  end

  def check_quiz
    @question_ids = params[:question_ids]
    @qwinix_ids = params[:qwinix_ids]
    if params[:uanswer].present?
      @uanswer = Uanswer.new(params.require(:uanswer).permit(:choosen_answer))
      @uanswer.question_id = params[:question_id]
      @uanswer.user_id = params[:user_id]
      @q= Question.find params[:question_id]
      if @q.answer_id == @uanswer.choosen_answer
        @uanswer.result = true
      else
        @uanswer.result = false
      end
      @uanswer.save
    else
      @uanswer = Uanswer.new
      @uanswer.question_id = params[:question_id]
      @uanswer.user_id = params[:user_id]
      @uanswer.save
    end
    respond_to do |format|
      format.js { redirect_to user_path(question_ids:@question_ids, qwinix_ids: @qwinix)}
    end
  end

  def result
    session[:user_id] = nil
    @user = User.find(params[:id])
    @result = Uanswer.where(user_id: params[:id]).where(result: true).count
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :email, :designation, :organization)
  end
end
