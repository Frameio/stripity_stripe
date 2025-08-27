defmodule StripeFork.TransferReversalTest do
  use StripeFork.StripeCase, async: true

  describe "retrieve/2" do
    test "retrieves a transfer" do
      assert {:ok, %StripeFork.TransferReversal{}} = StripeFork.TransferReversal.retrieve("transf_123", "rev_123")
      assert_stripe_requested(:get, "/v1/transfers/trasnf_123/reversals/rev_123")
    end
  end

  describe "create/2" do
    test "creates a transfer" do
      params = %{
        amount: 123
      }
      assert {:ok, %StripeFork.TransferReversal{}} = StripeFork.TransferReversal.create("transf_123", params)
      assert_stripe_requested(:post, "/v1/transfers/transf_123/reversals")
    end
  end

  describe "update/2" do
    test "updates a transfer" do
      params = %{metadata: %{foo: "bar"}}
      assert {:ok, transfer} = StripeFork.TransferReversal.update("trasnf_123", "rev_123", params)
      assert_stripe_requested(:post, "/v1/transfers/#{transfer.id}/reversals/rev_123")
    end
  end

  describe "list/2" do
    test "lists all transfers" do
      assert {:ok, %StripeFork.List{data: transfers}} = StripeFork.TransferReversal.list("transf_123")
      assert_stripe_requested(:get, "/v1/transfers/transf_123/reversals")
      assert is_list(transfers)
      assert %StripeFork.TransferReversal{} = hd(transfers)
    end
  end
end
