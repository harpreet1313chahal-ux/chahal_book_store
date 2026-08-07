require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "order must have a valid status" do
    order = Order.new(
      status: "Invalid",
      total_price: 100
    )

    assert_not order.valid?
  end

  test "order total price cannot be negative" do
    order = Order.new(
      status: "New",
      total_price: -10
    )

    assert_not order.valid?
  end
end
