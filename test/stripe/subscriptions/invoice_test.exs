defmodule StripeFork.InvoiceTest do
  use StripeFork.StripeCase, async: true

  describe "create/2" do
    test "creates an invoice" do
      assert {:ok, %StripeFork.Invoice{}} = StripeFork.Invoice.create(%{customer: "cus_123"})
      assert_stripe_requested(:post, "/v1/invoices")
    end
  end

  describe "retrieve/2" do
    test "retrieves an invoice" do
      assert {:ok, %StripeFork.Invoice{}} = StripeFork.Invoice.retrieve("in_123")
      assert_stripe_requested(:get, "/v1/invoices/in_123")
    end
  end

  describe "upcoming/2" do
    test "retrieves an upcoming invoice for a customer" do
      params = %{customer: "cus_123", subscription: "sub_123"}
      assert {:ok, %StripeFork.Invoice{}} = StripeFork.Invoice.upcoming(params)

      assert_stripe_requested(
        :get,
        "/v1/invoices/upcoming",
        query: %{customer: "cust_123", subscription: "sub_123"}
      )
    end

    test "retrieves an upcoming invoice for a customer with items" do
      items = [%{plan: "gold", quantity: 2}]
      params = %{customer: "cus_123", subscription_items: items}
      assert {:ok, %StripeFork.Invoice{}} = StripeFork.Invoice.upcoming(params)

      assert_stripe_requested(
        :get,
        "/v1/invoices/upcoming",
        query: %{
          :customer => "cust_123",
          :"susbscription_items[][plan]" => "gold",
          :"subscription_items[][quantity]" => 2
        }
      )
    end

    test "can be called with an empty string" do
      params = %{coupon: "", customer: "cus_123"}
      assert {:ok, %StripeFork.Invoice{}} = StripeFork.Invoice.upcoming(params)

      assert_stripe_requested(
        :get,
        "/v1/invoices/upcoming",
        query: %{customer: "cus_123", coupon: ""}
      )
    end
  end

  describe "update/2" do
    test "updates an invoice" do
      params = %{metadata: %{key: "value"}}
      assert {:ok, %StripeFork.Invoice{}} = StripeFork.Invoice.update("in_123", params)
      assert_stripe_requested(:post, "/v1/invoices/in_123")
    end
  end

  describe "pay/3" do
    test "pays an invoice" do
      {:ok, invoice} = StripeFork.Invoice.retrieve("in_123")
      assert {:ok, %StripeFork.Invoice{} = _paid_invoice} = StripeFork.Invoice.pay(invoice, %{})
      assert_stripe_requested(:post, "/v1/invoices/#{invoice.id}/pay")
    end

    test "pays an invoice with a specific source" do
      {:ok, invoice} = StripeFork.Invoice.retrieve("in_123")
      params = %{source: "src_123"}
      assert {:ok, %StripeFork.Invoice{} = _paid_invoice} = StripeFork.Invoice.pay(invoice, params)

      assert_stripe_requested(:post, "/v1/invoices/#{invoice.id}/pay", body: %{source: "src_123"})
    end
  end

  describe "list/2" do
    test "lists all invoices" do
      assert {:ok, %StripeFork.List{data: invoices}} = StripeFork.Invoice.list()
      assert_stripe_requested(:get, "/v1/invoices")
      assert is_list(invoices)
      assert %StripeFork.Invoice{} = hd(invoices)
    end
  end
end
