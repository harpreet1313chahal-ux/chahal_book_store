class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:order_items, :products).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
  end
end