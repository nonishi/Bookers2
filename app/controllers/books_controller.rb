class BooksController < ApplicationController
  before_action :authenticate_user!
  impressionist :actions => [:show]

  def index
    @book = Book.new
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorites).sort {|a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    }
    if params[:sort].present?
      case params[:sort]
      when 'new'
        @books = Book.all.order(created_at: 'DESC')
      when 'old'
        @books = Book.all.order(created_at: 'ASC')
      when 'high'
        @books = Book.all.order(rate: 'DESC')
      end
    end
  end

  def create
    book = Book.new(book_params)
    book.user_id = current_user.id
    if book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(book)
    else
      @book = book
      @books = Book.all
      render :index
    end
  end

  def show
    @book = Book.find(params[:id])
    impressionist(@book, nil, unique: [:session_hash.to_s])
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end
  end

  def update
    book = Book.find(params[:id])
    if book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(book)
    else
      @book = book
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end
end
