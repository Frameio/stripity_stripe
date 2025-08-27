defmodule StripeFork.BalanceTransactionTest do
  use StripeFork.StripeCase, async: true

  test "is retrievable" do
    assert {:ok, %StripeFork.BalanceTransaction{}} = StripeFork.BalanceTransaction.retrieve("txn_123")
    assert_stripe_requested(:get, "/v1/balance/history/txn_123")
  end

  test "is listable" do
    assert {:ok, %StripeFork.List{data: txns}} = StripeFork.BalanceTransaction.all()
    assert_stripe_requested(:get, "/v1/balance/history")
    assert is_list(txns)
    assert %StripeFork.BalanceTransaction{} = hd(txns)
  end
end
