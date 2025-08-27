defmodule StripeFork.ExternalAccountTest do
  use StripeFork.StripeCase, async: true

  describe "create/2" do
    test "creates a bank account for an account" do
      {:ok, _} = StripeFork.ExternalAccount.create(%{account: "acct_123", token: "tok_stripetestbank"})
      assert_stripe_requested(:post, "/v1/accounts/acct_123/external_accounts")
    end

    test "creates a card for an account" do
      {:ok, _} = StripeFork.ExternalAccount.create(%{account: "acct_123", token: "tok_amex"})
      assert_stripe_requested(:post, "/v1/accounts/acct_123/external_accounts")
    end
  end

  describe "retrieve/2" do
    test "retrieves a bank account" do
      {:ok, _} = StripeFork.ExternalAccount.retrieve("ba_123", %{account: "acct_123"})
      assert_stripe_requested(:get, "/v1/accounts/acct_123/external_accounts/ba_123")
    end

    test "retrieves a card" do
      {:ok, _} = StripeFork.ExternalAccount.retrieve("card_123", %{account: "acct_123"})
      assert_stripe_requested(:get, "/v1/accounts/acct_123/external_accounts/card_123")
    end
  end

  describe "update/2" do
    test "updates a bank account" do
      {:ok, _} = StripeFork.ExternalAccount.update("ba_123", %{account: "acct_123"})
      assert_stripe_requested(:post, "/v1/accounts/acct_123/external_accounts/ba_123")
    end

    test "updates a card" do
      {:ok, _} = StripeFork.ExternalAccount.update("card_123", %{account: "acct_123"})
      assert_stripe_requested(:post, "/v1/accounts/acct_123/external_accounts/card_123")
    end
  end

  describe "delete/2" do
    test "deletes a bank account" do
      {:ok, _} = StripeFork.ExternalAccount.delete("ba_123", %{account: "acct_123"})
      assert_stripe_requested(:delete, "/v1/accounts/acct_123/external_accounts/ba_123")
    end

    test "deletes a card" do
      {:ok, _} = StripeFork.ExternalAccount.delete("card_123", %{account: "acct_123"})
      assert_stripe_requested(:delete, "/v1/accounts/acct_123/external_accounts/card_123")
    end
  end

  describe "list/3" do
    @tag :skip
    test "lists all bank accounts for an account" do
      {:ok, %StripeFork.List{data: bank_accounts}} = StripeFork.ExternalAccount.list(:bank_account, %{account: "acct_123"})
      assert_stripe_requested(:get, "/v1/accounts/acct_123/external_accounts?object=bank_account")
      assert is_list(bank_accounts)
    end

    @tag :skip
    test "lists all cards for an account" do
      {:ok, %StripeFork.List{data: cards}} = StripeFork.ExternalAccount.list(:card, %{account: "acct_123"})
      assert_stripe_requested(:get, "/v1/accounts/acct_123/external_accounts?object=card")
      assert is_list(cards)
    end
  end
end
