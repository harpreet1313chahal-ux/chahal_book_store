class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:order_items)
  end

  def show
    @order = Order.find(params[:id])
  end
end