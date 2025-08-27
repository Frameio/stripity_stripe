defmodule StripeFork.AccountTest do
  use StripeFork.StripeCase, async: true

  test "is retrievable using singular endpoint" do
    assert {:ok, %StripeFork.Account{}} = StripeFork.Account.retrieve()
    assert_stripe_requested(:get, "/v1/account")
  end

  test "is retrievable using plural endpoint" do
    assert {:ok, %StripeFork.Account{}} = StripeFork.Account.retrieve("acct_123")
    assert_stripe_requested(:get, "/v1/accounts/acct_123")
  end

  test "is creatable" do
    assert {:ok, %StripeFork.Account{}} = StripeFork.Account.create(%{metadata: %{}, type: "standard"})
    assert_stripe_requested(:post, "/v1/accounts")
  end

  test "is updateable" do
    assert {:ok, %StripeFork.Account{id: id}} =
             StripeFork.Account.update("acct_123", %{metadata: %{foo: "bar"}})

    assert_stripe_requested(:post, "/v1/accounts/#{id}")
  end

  test "is deletable" do
    assert {:ok, %StripeFork.Account{}} = StripeFork.Account.delete("acct_123")
    assert_stripe_requested(:delete, "/v1/accounts/acct_123")
  end

  test "is listable" do
    assert {:ok, %StripeFork.List{data: accounts}} = StripeFork.Account.list()
    assert_stripe_requested(:get, "/v1/accounts")
    assert is_list(accounts)
    assert %StripeFork.Account{} = hd(accounts)
  end

  test "is rejectable" do
    {:ok, account} = StripeFork.Account.create(%{metadata: %{}, type: "standard"})

    assert {:ok, %StripeFork.Account{} = rejected_account} =
             StripeFork.Account.reject(account, "terms_of_service")

    assert_stripe_requested(:post, "/v1/accounts/#{account.id}/reject")
    assert account.id == rejected_account.id
    refute rejected_account.transfers_enabled
    refute rejected_account.charges_enabled
  end

  test "can create a login link" do
    assert {:ok, _login_link} = StripeFork.Account.create_login_link("acct_123", %{})
    assert_stripe_requested(:post, "/v1/accounts/acct_123/login_links")
  end
end
