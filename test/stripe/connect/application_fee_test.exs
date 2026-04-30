defmodule StripeFork.ApplicationFeeTest do
  use StripeFork.StripeCase, async: true

  test "is retrievable using plural endpoint" do
    assert {:ok, %StripeFork.ApplicationFee{}} = StripeFork.ApplicationFee.retrieve("acct_123")
    assert_stripe_requested(:get, "/v1/application_fees/acct_123")
  end

  test "is listable" do
    assert {:ok, %StripeFork.List{data: application_feess}} = StripeFork.ApplicationFee.list()
    assert_stripe_requested(:get, "/v1/application_fees")
    assert is_list(application_feess)
    assert %StripeFork.ApplicationFee{} = hd(application_feess)
  end
end
