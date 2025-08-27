defmodule StripeFork.CustomerTest do
  use StripeFork.StripeCase, async: true

  test "is creatable" do
    assert {:ok, %StripeFork.Customer{}} = StripeFork.Customer.create(%{})
    assert_stripe_requested(:post, "/v1/customers")
  end

  test "is retrievable" do
    assert {:ok, %StripeFork.Customer{}} = StripeFork.Customer.retrieve("cus_123")
    assert_stripe_requested(:get, "/v1/customers/cus_123")
  end

  test "is updateable" do
    params = %{metadata: %{key: "value"}}
    assert {:ok, %StripeFork.Customer{}} = StripeFork.Customer.update("cus_123", params)
    assert_stripe_requested(:post, "/v1/customers/cus_123")
  end

  test "is deletable" do
    {:ok, customer} = StripeFork.Customer.retrieve("cus_123")
    assert {:ok, %StripeFork.Customer{}} = StripeFork.Customer.delete(customer)
    assert_stripe_requested(:delete, "/v1/customers/#{customer.id}")
  end

  test "is listable" do
    assert {:ok, %StripeFork.List{data: customers}} = StripeFork.Customer.list()
    assert_stripe_requested(:get, "/v1/customers")
    assert is_list(customers)
    assert %StripeFork.Customer{} = hd(customers)
  end

  describe "delete_discount/2" do
    test "deletes a customer's discount" do
      {:ok, customer} = StripeFork.Customer.retrieve("sub_123")
      assert {:ok, _} = StripeFork.Customer.delete_discount("sub_123")
      assert_stripe_requested(:delete, "/v1/customers/#{customer.id}/discount")
    end
  end
end
