defmodule StripeFork.RecipientTest do
  use StripeFork.StripeCase, async: true

  test "is retrievable using plural endpoint" do
    assert {:ok, %StripeFork.Recipient{}} = StripeFork.Recipient.retrieve("recip_123")
    assert_stripe_requested(:get, "/v1/recipients/recip_123")
  end

  test "is creatable" do
    assert {:ok, %StripeFork.Recipient{}} = StripeFork.Recipient.create(%{name: "scooter", type: "standard"})
    assert_stripe_requested(:post, "/v1/recipients")
  end

  test "is updateable" do
    assert {:ok, %StripeFork.Recipient{id: id}} =
             StripeFork.Recipient.update("recip_123", %{metadata: %{foo: "bar"}})

    assert_stripe_requested(:post, "/v1/recipients/#{id}")
  end

  test "is deletable" do
    assert {:ok, %StripeFork.Recipient{}} = StripeFork.Recipient.delete("recip_123")
    assert_stripe_requested(:delete, "/v1/recipients/recip_123")
  end

  test "is listable" do
    assert {:ok, %StripeFork.List{data: recipients}} = StripeFork.Recipient.list()
    assert_stripe_requested(:get, "/v1/recipients")
    assert is_list(recipients)
    assert %StripeFork.Recipient{} = hd(recipients)
  end
end
