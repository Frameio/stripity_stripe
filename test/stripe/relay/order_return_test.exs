defmodule StripeFork.OrderReturnTest do
  use StripeFork.StripeCase, async: true

  describe "retrieve/2" do
    test "retrieves an order return" do
      assert {:ok, %StripeFork.OrderReturn{}} = StripeFork.OrderReturn.retrieve("orret_123")
      assert_stripe_requested(:get, "/v1/order_returns/orret_123")
    end
  end

  describe "list/2" do
    test "lists all order returns" do
      assert {:ok, %StripeFork.List{data: order_returns}} = StripeFork.OrderReturn.list()
      assert_stripe_requested(:get, "/v1/order_returns")
      assert is_list(order_returns)
      assert %StripeFork.OrderReturn{} = hd(order_returns)
    end
  end
end
