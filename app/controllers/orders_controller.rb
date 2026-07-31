class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:order_items, :products).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(status: params[:order][:status])
      redirect_to orders_path, notice: "Order status updated successfully."
    else
      redirect_to orders_path, alert: "Unable to update order status."
    end
  end
end
