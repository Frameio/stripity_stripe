defmodule StripeFork.PayoutTest do
  use StripeFork.StripeCase, async: true

  describe "create/2" do
    test "creates a card for a customer" do
      params = %{amount: 100, currency: "USD", source_type: "card"}
      assert {:ok, %StripeFork.Payout{}} = StripeFork.Payout.create(params)
      assert_stripe_requested(:post, "/v1/payouts")
    end
  end

  describe "retrieve/2" do
    test "retrieves a card" do
      assert {:ok, %StripeFork.Payout{}} = StripeFork.Payout.retrieve("py_123")
      assert_stripe_requested(:get, "/v1/payouts/py_123")
    end
  end

  describe "update/2" do
    test "updates a card" do
      assert {:ok, %StripeFork.Payout{}} = StripeFork.Payout.update("py_123", %{metadata: %{foo: "bar"}})
      assert_stripe_requested(:post, "/v1/payouts/py_123")
    end
  end

  describe "list/2" do
    test "lists all cards" do
      assert {:ok, %StripeFork.List{data: payouts}} = StripeFork.Payout.list()
      assert_stripe_requested(:get, "/v1/payouts")
      assert is_list(payouts)
      assert %StripeFork.Payout{} = hd(payouts)
    end
  end

  describe "cancel/1" do
    test "cancels a payout" do
      assert {:ok, %StripeFork.Payout{}} = StripeFork.Payout.cancel("py_123")
      assert_stripe_requested(:get, "/v1/payouts/cancel")
    end
  end
end
