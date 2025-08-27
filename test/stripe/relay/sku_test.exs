defmodule StripeFork.SkuTest do
  use StripeFork.StripeCase, async: true

  test "is creatable" do
    inventory = %{type: "finite", quantity: 500}
    assert {:ok, %StripeFork.Sku{}} = StripeFork.Sku.create(%{currency: "USD", product: "prod_123", price: 100, inventory: inventory})
    assert_stripe_requested(:post, "/v1/skus")
  end

  test "is retrievable" do
    assert {:ok, %StripeFork.Sku{}} = StripeFork.Sku.retrieve("sku_123")
    assert_stripe_requested(:get, "/v1/skus/sku_123")
  end

  test "is updateable" do
    params = %{metadata: %{key: "value"}}
    assert {:ok, %StripeFork.Sku{}} = StripeFork.Sku.update("sku_123", params)
    assert_stripe_requested(:post, "/v1/skus/sku_123")
  end

  test "is updateable via active attribute" do
    params = %{active: false}
    assert {:ok, %StripeFork.Sku{}} = StripeFork.Sku.update("sku_123", params)
    assert_stripe_requested(:post, "/v1/skus/sku_123")
  end

  test "is deletable" do
    assert {:ok, %StripeFork.Sku{}} = StripeFork.Sku.delete("sku_123")
    assert_stripe_requested(:delete, "/v1/skus/sku_123/delete")
  end

  test "is listable" do
    assert {:ok, %StripeFork.List{data: skus}} = StripeFork.Sku.list()
    assert_stripe_requested(:get, "/v1/skus")
    assert is_list(skus)
    assert %StripeFork.Sku{} = hd(skus)
  end

  test "is listable with params" do
    params = %{active: false, in_stock: false}
    assert {:ok, %StripeFork.List{data: _skus}} = StripeFork.Sku.list(params)
    assert_stripe_requested(:get, "/v1/skus")
  end
end
