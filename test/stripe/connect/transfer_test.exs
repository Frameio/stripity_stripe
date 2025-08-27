defmodule StripeFork.TransferTest do
  use StripeFork.StripeCase, async: true

  describe "retrieve/2" do
    test "retrieves a transfer" do
      assert {:ok, %StripeFork.Transfer{}} = StripeFork.Transfer.retrieve("sub_123")
      assert_stripe_requested(:get, "/v1/transfers/sub_123")
    end
  end

  describe "create/2" do
    test "creates a transfer" do
      params = %{
        amount: 123,
        currency: "curr_123",
        destination: "dest_123"
      }
      assert {:ok, %StripeFork.Transfer{}} = StripeFork.Transfer.create(params)
      assert_stripe_requested(:post, "/v1/transfers")
    end
  end

  describe "update/2" do
    test "updates a transfer" do
      params = %{metadata: %{foo: "bar"}}
      assert {:ok, transfer} = StripeFork.Transfer.update("sub_123", params)
      assert_stripe_requested(:post, "/v1/transfers/#{transfer.id}")
    end
  end

  describe "list/2" do
    test "lists all transfers" do
      assert {:ok, %StripeFork.List{data: transfers}} = StripeFork.Transfer.list()
      assert_stripe_requested(:get, "/v1/transfers")
      assert is_list(transfers)
      assert %StripeFork.Transfer{} = hd(transfers)
    end
  end
end
