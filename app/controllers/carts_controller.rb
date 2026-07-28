class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
    @items = Product.where(id: @cart.keys)
  end

def checkout
  @cart = session[:cart] || {}
  @items = Product.where(id: @cart.keys)

  # Remove products that no longer exist
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

  subtotal = 0

session[:cart].each do |product_id, quantity|
  product = Product.find(product_id)
  subtotal += product.price * quantity
end

gst = subtotal * province.gst.to_f
pst = subtotal * province.pst.to_f
hst = subtotal * province.hst.to_f

tax_amount = gst + pst + hst

order = Order.create(
  user: user,
  order_date: Date.today,
  shipping_address: params[:address],
  status: "New",

  gst_rate: province.gst,
  pst_rate: province.pst,
  hst_rate: province.hst,
  tax_amount: tax_amount,

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

    order.update(total_price: total + tax_amount)

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
