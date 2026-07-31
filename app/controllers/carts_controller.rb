class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @items = Product.where(id: @cart.keys)
  end

  def checkout
    @cart = session[:cart] || {}
    @items = Product.where(id: @cart.keys)

    @cart.select! { |id, _| @items.any? { |product| product.id.to_s == id } }
    session[:cart] = @cart

    @subtotal = 0

    @items.each do |product|
      @subtotal += product.price * @cart[product.id.to_s]
    end

    if params[:province_id].present?
      province = Province.find_by(id: params[:province_id])

      @gst = @subtotal * province.gst.to_f
      @pst = @subtotal * province.pst.to_f
      @hst = @subtotal * province.hst.to_f
    else
      @gst = 0
      @pst = 0
      @hst = 0
    end

    @total = @subtotal + @gst + @pst + @hst
  end

  def place_order
    session[:cart] ||= {}

    user = User.find_by(id: session[:user_id])

    unless user
      redirect_to login_path, alert: "Please log in before placing an order."
      return
    end

    province = Province.find_by(id: params[:province_id])

    unless province
      redirect_to checkout_cart_path, alert: "Please select a province."
      return
    end

    subtotal = 0

    session[:cart].each do |product_id, quantity|
      product = Product.find(product_id)
      subtotal += product.price * quantity
    end

    gst = subtotal * province.gst.to_f
    pst = subtotal * province.pst.to_f
    hst = subtotal * province.hst.to_f

    tax_amount = gst + pst + hst
    total_price = subtotal + tax_amount

    order = Order.create!(
      user: user,
      order_date: Date.today,
      shipping_address: params[:address],
      status: "New",
      gst_rate: province.gst,
      pst_rate: province.pst,
      hst_rate: province.hst,
      tax_amount: tax_amount,
      total_price: total_price
    )

    session[:cart].each do |product_id, quantity|
      product = Product.find(product_id)

      OrderItem.create!(
        order: order,
        product: product,
        quantity: quantity,
        unit_price: product.price,
        subtotal: product.price * quantity
      )
    end

    session[:cart] = {}

    redirect_to orders_path, notice: "Order placed successfully!"
  end

def create_checkout_session
  session[:cart] ||= {}

  if session[:cart].empty?
    redirect_to cart_path, alert: "Your cart is empty."
    return
  end

  line_items = []

  session[:cart].each do |product_id, quantity|
    product = Product.find(product_id)

    line_items << {
      price_data: {
        currency: "cad",
        product_data: {
          name: product.title
        },
        unit_amount: (product.price * 100).to_i
      },
      quantity: quantity.to_i
    }
  end

  session = Stripe::Checkout::Session.create(
    payment_method_types: [ "card" ],
    mode: "payment",
    line_items: line_items,
    success_url: success_cart_url,
    cancel_url: checkout_cart_url
  )

  redirect_to session.url, allow_other_host: true
end

  def success
    Rails.logger.info session[:cart].inspect

  user = User.find(session[:user_id])
  province = Province.first

  subtotal = 0

  session[:cart].each do |product_id, quantity|
    product = Product.find(product_id)
    subtotal += product.price * quantity
  end

  gst = subtotal * province.gst.to_f
  pst = subtotal * province.pst.to_f
  hst = subtotal * province.hst.to_f

  tax_amount = gst + pst + hst
  total_price = subtotal + tax_amount

  order = Order.create!(
    user: user,
    order_date: Date.today,
    shipping_address: "Paid with Stripe",
    status: "Paid",
    gst_rate: province.gst,
    pst_rate: province.pst,
    hst_rate: province.hst,
    tax_amount: tax_amount,
    total_price: total_price
  )

  session[:cart].each do |product_id, quantity|
    product = Product.find(product_id)

    OrderItem.create!(
      order: order,
      product: product,
      quantity: quantity,
      unit_price: product.price,
      subtotal: product.price * quantity
    )
  end

  session[:cart] = {}

  redirect_to orders_path, notice: "Payment completed successfully!"
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
