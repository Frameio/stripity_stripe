defmodule StripeFork.ChargeTest do
  use StripeFork.StripeCase, async: true

  test "is listable" do
    assert {:ok, %StripeFork.List{data: charges}} = StripeFork.Charge.list()
    assert_stripe_requested(:get, "/v1/charges")
    assert is_list(charges)
    assert %StripeFork.Charge{} = hd(charges)
  end

  test "is retrievable" do
    assert {:ok, %StripeFork.Charge{}} = StripeFork.Charge.retrieve("ch_123")
    assert_stripe_requested(:get, "/v1/charges/ch_123")
  end

  test "is creatable" do
    params = %{amount: 100, currency: "USD", source: "src_123"}
    assert {:ok, %StripeFork.Charge{}} = StripeFork.Charge.create(params)
    assert_stripe_requested(:post, "/v1/charges")
  end

  test "is updateable" do
    assert {:ok, %StripeFork.Charge{}} = StripeFork.Charge.update("ch_123", %{metadata: %{foo: "bar"}})
    assert_stripe_requested(:post, "/v1/charges/ch_123")
  end

  test "is captureable" do
    {:ok, %StripeFork.Charge{} = charge} = StripeFork.Charge.retrieve("ch_123")
    assert {:ok, %StripeFork.Charge{}} = StripeFork.Charge.capture(charge, %{amount: 1000})
    assert_stripe_requested(:post, "/v1/charges/ch_123/capture")
  end

  test "is retrievable with expansions opts" do
    opts = [expand: ["balance_transaction"]]
    assert {:ok, %StripeFork.Charge{}} = StripeFork.Charge.retrieve("ch_123", opts)

    assert_stripe_requested(:get, "/v1/charges/ch_123")
  end
end
