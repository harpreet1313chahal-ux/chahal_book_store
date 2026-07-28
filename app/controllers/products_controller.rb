class ProductsController < ApplicationController

  def index
    @categories = Category.all
    @products = Product.all

    if params[:search].present?
      @products = @products.where(
        "LOWER(title) LIKE ? OR LOWER(description) LIKE ?",
        "%#{params[:search].downcase}%",
        "%#{params[:search].downcase}%"
      )
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 3.days.ago)
    elsif params[:filter] == "updated"
      @products = @products.where("updated_at >= ?", 3.days.ago)
                           .where("created_at < ?", 3.days.ago)
    end

    @products = @products.page(params[:page]).per(20)
  end

  def show
    @product = Product.find(params[:id])
  end

end