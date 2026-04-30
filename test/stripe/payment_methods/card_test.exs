defmodule StripeFork.CardTest do
  use StripeFork.StripeCase, async: true

  describe "create/2" do
    test "creates a card for a customer" do
      assert {:ok, _} = StripeFork.Card.create(%{customer: "cus_123", source: "tok_amex"})
      assert_stripe_requested(:post, "/v1/customers/cus_123/sources")
    end
  end

  describe "retrieve/2" do
    test "retrieves a card" do
      assert {:ok, _} = StripeFork.Card.retrieve("card_123", %{customer: "cus_123"})
      assert_stripe_requested(:get, "/v1/customers/cus_123/sources/card_123")
    end
  end

  describe "update/2" do
    test "updates a card" do
      assert {:ok, _} = StripeFork.Card.update("card_123", %{customer: "cus_123"})
      assert_stripe_requested(:post, "/v1/customers/cus_123/sources/card_123")
    end
  end

  describe "delete/2" do
    test "deletes a card" do
      assert {:ok, _} = StripeFork.Card.delete("card_123", %{customer: "cus_123"})
      assert_stripe_requested(:delete, "/v1/customers/cus_123/sources/card_123")
    end
  end

  describe "list/2" do
    test "lists all cards" do
      assert {:ok, %StripeFork.List{data: cards}} = StripeFork.Card.list(%{customer: "cus_123"})
      assert_stripe_requested(:get, "/v1/customers/cus_123/sources?object=card")
      assert is_list(cards)
    end
  end
end
