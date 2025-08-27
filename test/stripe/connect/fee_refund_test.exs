defmodule StripeFork.FeeRefundTest do
  use StripeFork.StripeCase, async: true

  describe "retrieve/2" do
    test "retrieves a transfer" do
      assert {:ok, %StripeFork.FeeRefund{}} = StripeFork.FeeRefund.retrieve("transf_123", "rev_123")
      assert_stripe_requested(:get, "/v1/appliction_fees/trasnf_123/reversals/rev_123")
    end
  end

  describe "create/2" do
    test "creates a transfer" do
      params = %{
        amount: 123
      }

      assert {:ok, %StripeFork.FeeRefund{}} = StripeFork.FeeRefund.create("transf_123", params)
      assert_stripe_requested(:post, "/v1/appliction_fees/transf_123/reversals")
    end
  end

  describe "update/2" do
    test "updates a transfer" do
      params = %{metadata: %{foo: "bar"}}
      assert {:ok, transfer} = StripeFork.FeeRefund.update("trasnf_123", "rev_123", params)
      assert_stripe_requested(:post, "/v1/appliction_fees/#{transfer.id}/reversals/rev_123")
    end
  end

  describe "list/2" do
    test "lists all appliction_fees refunds" do
      assert {:ok, %StripeFork.List{data: appliction_fees}} = StripeFork.FeeRefund.list("transf_123")
      assert_stripe_requested(:get, "/v1/appliction_fees/transf_123/reversals")
      assert is_list(appliction_fees)
      assert %StripeFork.FeeRefund{} = hd(appliction_fees)
    end
  end
end
