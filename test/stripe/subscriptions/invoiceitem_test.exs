defmodule StripeFork.InvoiceitemTest do
  use StripeFork.StripeCase, async: true

  describe "create/2" do
    test "creates an invoice" do
      assert {:ok, %StripeFork.Invoiceitem{}} = StripeFork.Invoiceitem.create(%{customer: "cus_123", currency: "usd"})
      assert_stripe_requested(:post, "/v1/invoiceitems")
    end
  end

  describe "retrieve/2" do
    test "retrieves an invoice" do
      assert {:ok, %StripeFork.Invoiceitem{}} = StripeFork.Invoiceitem.retrieve("in_1234")
      assert_stripe_requested(:get, "/v1/invoiceitems/in_1234")
    end
  end

  describe "update/2" do
    test "updates an invoice" do
      params = %{metadata: %{key: "value"}}
      assert {:ok, %StripeFork.Invoiceitem{}} = StripeFork.Invoiceitem.update("in_1234", params)
      assert_stripe_requested(:post, "/v1/invoiceitems/in_1234")
    end
  end

  describe "list/2" do
    test "lists all invoiceitems" do
      assert {:ok, %StripeFork.List{data: invoiceitems}} = StripeFork.Invoiceitem.list()
      assert_stripe_requested(:get, "/v1/invoiceitems")
      assert is_list(invoiceitems)
      assert %StripeFork.Invoiceitem{} = hd(invoiceitems)
    end
  end
end
