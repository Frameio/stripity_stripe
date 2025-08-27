defmodule StripeFork.RefundTest do
  use StripeFork.StripeCase, async: true

  test "is listable" do
    assert {:ok, %StripeFork.List{data: refunds}} = StripeFork.Refund.list()
    assert_stripe_requested(:get, "/v1/refunds")
    assert is_list(refunds)
    assert %StripeFork.Refund{} = hd(refunds)
  end

  test "is retrievable" do
    assert {:ok, %StripeFork.Refund{}} = StripeFork.Refund.retrieve("re_123")
    assert_stripe_requested(:get, "/v1/refunds/re_123")
  end

  test "is creatable" do
    assert {:ok, %StripeFork.Refund{}} = StripeFork.Refund.create(%{charge: "ch_123"})
    assert_stripe_requested(:post, "/v1/refunds")
  end

  test "is updateable" do
    assert {:ok, refund} = StripeFork.Refund.update("re_123", %{metadata: %{foo: "bar"}})
    assert_stripe_requested(:post, "/v1/refunds/#{refund.id}")
  end
end
