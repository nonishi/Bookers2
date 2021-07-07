class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @book = Book.new
    @users = User.all
  end

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books.page(params[:page])
    @today_books = @books.where(created_at: Time.current.all_day)
    @yesterday_books = @books.where(created_at: 1.day.ago.all_day)
    @this_week_books = @books.where(created_at: 6.day.ago.at_beginning_of_day...Time.current.at_end_of_day)
    @last_week_books = @books.where(created_at: 13.day.ago.at_beginning_of_day...1.week.ago.at_end_of_day)
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(user)
    else
      @user = user
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
