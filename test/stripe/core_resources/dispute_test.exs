defmodule StripeFork.DisputeTest do
  use StripeFork.StripeCase, async: true

  test "is retrievable" do
    assert {:ok, %StripeFork.Dispute{}} = StripeFork.Dispute.retrieve("cus_123")
    assert_stripe_requested(:get, "/v1/disputes/cus_123")
  end

  test "is updateable" do
    params = %{metadata: %{key: "value"}}
    assert {:ok, %StripeFork.Dispute{}} = StripeFork.Dispute.update("cus_123", params)
    assert_stripe_requested(:post, "/v1/disputes/cus_123")
  end

  test "is closeable" do
    {:ok, dispute} = StripeFork.Dispute.retrieve("cus_123")
    assert {:ok, %StripeFork.Dispute{}} = StripeFork.Dispute.close(dispute)
    assert_stripe_requested(:post, "/v1/disputes/#{dispute.id}/close")
  end

  test "is listable" do
    assert {:ok, %StripeFork.List{data: disputes}} = StripeFork.Dispute.list()
    assert_stripe_requested(:get, "/v1/disputes")
    assert is_list(disputes)
    assert %StripeFork.Dispute{} = hd(disputes)
  end
end
