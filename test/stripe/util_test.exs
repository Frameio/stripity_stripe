defmodule StripeFork.UtilTest do
  use ExUnit.Case

  import StripeFork.Util

  describe "object_name_to_module/1" do
    test "converts all object names to their proper modules" do
      assert object_name_to_module("account") == StripeFork.Account
      assert object_name_to_module("application_fee") == StripeFork.ApplicationFee
      assert object_name_to_module("fee_refund") == StripeFork.FeeRefund
      assert object_name_to_module("bank_account") == StripeFork.BankAccount
      assert object_name_to_module("card") == StripeFork.Card
      assert object_name_to_module("coupon") == StripeFork.Coupon
      assert object_name_to_module("customer") == StripeFork.Customer
      assert object_name_to_module("dispute") == StripeFork.Dispute
      assert object_name_to_module("event") == StripeFork.Event
      assert object_name_to_module("external_account") == StripeFork.ExternalAccount
      assert object_name_to_module("file_upload") == StripeFork.FileUpload
      assert object_name_to_module("invoice") == StripeFork.Invoice
      assert object_name_to_module("invoiceitem") == StripeFork.Invoiceitem
      assert object_name_to_module("line_item") == StripeFork.LineItem
      assert object_name_to_module("list") == StripeFork.List
      assert object_name_to_module("order") == StripeFork.Order
      assert object_name_to_module("order_return") == StripeFork.OrderReturn
      assert object_name_to_module("plan") == StripeFork.Plan
      assert object_name_to_module("product") == StripeFork.Product
      assert object_name_to_module("refund") == StripeFork.Refund
      assert object_name_to_module("subscription") == StripeFork.Subscription
      assert object_name_to_module("subscription_item") == StripeFork.SubscriptionItem
      assert object_name_to_module("sku") == StripeFork.Sku
      assert object_name_to_module("transfer") == StripeFork.Transfer
      assert object_name_to_module("transfer_reversal") == StripeFork.TransferReversal
      assert object_name_to_module("token") == StripeFork.Token
    end
  end

  describe "multipart_key/1" do
    test "handle all multipart keys" do
      assert multipart_key(:file) == :file
      assert multipart_key(:foo) == "foo"
      assert multipart_key("foo") == "foo"
    end
  end
end
