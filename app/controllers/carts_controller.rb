class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @items = Product.find(@cart.keys)
  end

  def checkout
    @cart = session[:cart] || {}
    @items = Product.find(@cart.keys)

    @subtotal = 0

    @items.each do |product|
      @subtotal += product.price * @cart[product.id.to_s]
    end

    case params[:province]
    when "Alberta"
      @gst = @subtotal * 0.05
      @pst = 0
    when "Manitoba"
      @gst = @subtotal * 0.05
      @pst = @subtotal * 0.07
    when "Ontario"
      @gst = 0
      @pst = @subtotal * 0.13
    else
      @gst = @subtotal * 0.05
      @pst = 0
    end

    @total = @subtotal + @gst + @pst
  end

    def place_order
    session[:cart] ||= {}

    user = User.first

    order = Order.create(
      user: user,
      order_date: Date.today,
      shipping_address: params[:address],
      status: "Pending",
      total_price: 0
    )

    total = 0

    session[:cart].each do |product_id, quantity|
      product = Product.find(product_id)

      subtotal = product.price * quantity

      OrderItem.create(
        order: order,
        product: product,
        quantity: quantity,
        unit_price: product.price,
        subtotal: subtotal
      )

      total += subtotal
    end

    order.update(total_price: total)

    session[:cart] = {}

    redirect_to orders_path, notice: "Order placed successfully!"
  end

  def add
    session[:cart] ||= {}

    product_id = params[:id].to_s

    if session[:cart][product_id]
      session[:cart][product_id] += 1
    else
      session[:cart][product_id] = 1
    end

    redirect_to cart_path, notice: "Product added to cart."
  end

  def update
    session[:cart][params[:id]] = params[:quantity].to_i
    redirect_to cart_path
  end

  def remove
    session[:cart].delete(params[:id])
    redirect_to cart_path
  end
end
