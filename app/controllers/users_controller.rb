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
      @@i = 0
      @@question_ids = Question.all.collect(&:id).first(20).shuffle.sample(15)
      @@qwinix = Question.all.collect(&:id).last(5)
      redirect_to start_user_path(@user)
    else
      render 'index'
    end
  end

  def start
    @user = User.find(params[:id])
  end

  def show
    @@i += 1
    @qn = @@i
    @user = User.find(params[:id])
    if @qn < 15
      @question = Question.find @@question_ids.pop
      @choices = Qchoice.where(question_id: @question.id)
    elsif @qn >= 15 && @qn < 20
      @question = Question.find @@qwinix.pop
      @choices = Qchoice.where(question_id: @question.id)
    else
      redirect_to result_user_path
    end
  end

  def check_quiz
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
    end
    respond_to do |format|
      format.js { redirect_to user_path}
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
