class BookController < ApplicationController
  before_action :authenticate_user!, only:[:new_give,:give_confirmation,:send_offer,:create]

  def search_results
  end

  def send_offer
  end

  def offer_success
  end

  def give_confirmation
  end

  def new_give
    @book = Book.new
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to root_path
    else
      redirect_to book_new_give_path
    end
  end

private

  def book_params #ストロングパラメーター
    params.require(:book).permit(:name, :image, :isbn)
  end



end
