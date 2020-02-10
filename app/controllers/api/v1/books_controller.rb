class Api::V1::BooksController < ApplicationController
  include History
  before_action :set_book, only: [:show, :update, :destroy, :checkout, :checkin]
  before_action :authenticate_user!, only: [:create, :update, :destroy, :checkout, :checkin]

  def create
    @book = Book.new(book_params)
    authorize @book

    if @book.save
        render json: {
            message: "Book created successfully.",
            data: @book
        }, status: :ok
    else
        render json: {
            message: "Something went wrong.",
            errors: @book.errors
        }, status: :unprocessable_entity
    end
  end

  def show
    render json: {
        message: "Book found.",
        data: @book.as_json(methods: :status)
    }, status: :ok
  end

  def update
    if @book.update(book_params)
        render json: {
            message: "Book updated.",
            data: @book
        }, status: :ok
    else
        render json: {
            message: "Something went wrong.",
            errors: @book.errors
        }, status: :unprocessable_entity
    end
  end

  def destroy
    if @book.destroy
        render json: {
            message: "Book deleted.",
            data: @book
        }, status: :ok
    else
        render json: {
            message: "Something went wrong.",
            errors: @book.errors
        }, status: :unprocessable_entity
    end
  end

  def index
    @books = paginate(Book.all.order(created_at: :desc))
    if @books.present?
        render json: {
            message: "Books found.",
            data: @books.as_json(methods: :status)
        }, status: :ok
    else
        render json: {
            message: "No book found.",
            data: nil
        }, status: :ok
    end
  end

  def search
    @books = Book.all

    title = params['title']
    author = params['author']
    genre = params['genre']
    published_year = params['published_year']

    @books = @books.search_by_title(title) if title.present?
    @books = @books.search_by_author(author) if author.present?
    @books = @books.search_by_genre(genre) if genre.present?
    @books = @books.where(published_year: published_year) if published_year.present?

    @books = paginate( @books)
    if @books.present?
        render json: {
            message: "Books found.",
            data: @books
        }, status: :ok
    else
        render json: {
            message: "No book found.",
            data: nil
        }, status: :ok
    end
  end

  def checkout
    if @book.status == 'AVAILABLE'
      @transaction = Transaction.new(
                        user_id: current_user.id,
                        book_id: @book.id,
                        checkout_timestamp: Time.now,
                        due_timestamp: Time.now+7.days
                      )
    else
      return render json: {
        message: "Book not yet check in!"
      }, status: :unprocessable_entity
    end

    if @transaction.save
      render json: {
        message: "Book checked out successfully.",
        data: @transaction
      }, status: :ok
    else
      render json: {
        message: "Something went wrong.",
        error: @transaction.errors
      }, status: :unprocessable_entity
    end

  end

  def checkin
    @transaction = Transaction.find_by(book_id: @book.id, checkin_timestamp: nil)

    if @transaction && @transaction.update(checkin_timestamp: Time.now)
      if @transaction.checkin_timestamp > @transaction.due_timestamp
        overdue_time = (@transaction.checkin_timestamp - @transaction.due_timestamp / 1.hour).round
        render json: {
          message: "Book is overdue for #{overdue_time} hour(s).",
          data: @transaction
        }, status: :ok
      else
        render json: {
          message: "Book checked in successfully.",
          data: @transaction
        }, status: :ok
      end
    elsif @book.status == "AVAILABLE"
      render json: {
        message: "Books not yet checked out.",
      }, status: :unprocessable_entity
    else
      render json: {
        message: "Something went wrong.",
        error: @transaction ? @transaction.errors : nil
      }, status: :unprocessable_entity
    end
  end

  protected

  def book_params
    permitted_params = [:title, :author, :published_year, :serial_number, :genre]
    params.require(:book).permit(permitted_params)
  end

  def set_book
    @book = Book.find(params[:id])
    authorize @book
  end

end
