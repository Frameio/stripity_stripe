defmodule StripeFork.BalanceTest do
  use StripeFork.StripeCase, async: true

  test "is listable" do
    assert {:ok, %StripeFork.List{data: balances}} = StripeFork.Balance.list()
    assert_stripe_requested(:get, "/v1/balance/history")
    assert is_list(balances)
    assert %StripeFork.BalanceTransaction{} = hd(balances)
  end

  test "transaction is retrievable" do
    assert {:ok, %StripeFork.BalanceTransaction{}} = StripeFork.Balance.retrieve_transaction("b_123")
    assert_stripe_requested(:get, "/v1/balance/history/#{"b_123"}")
  end

  test "is retrievable" do
    assert {:ok, %StripeFork.Balance{}} = StripeFork.Balance.retrieve()
    assert_stripe_requested(:get, "/v1/balance")
  end
end
