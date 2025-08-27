defmodule StripeFork.SubscriptionTest do
  use StripeFork.StripeCase, async: true

  describe "retrieve/2" do
    test "retrieves a subscription" do
      assert {:ok, %StripeFork.Subscription{}} = StripeFork.Subscription.retrieve("sub_123")
      assert_stripe_requested(:get, "/v1/subscriptions/sub_123")
    end
  end

  describe "create/2" do
    test "creates a subscription" do
      params = %{
        application_fee_percent: 5,
        customer: "cus_123",
        items: [
          %{
            plan: "ruby-express-932",
            quantity: 1
          }
        ]
      }

      assert {:ok, %StripeFork.Subscription{}} =
               StripeFork.Subscription.create(params, connect_account: "acct_123")

      assert_stripe_requested(:post, "/v1/subscriptions")
    end

    test "fails with source param [since 2018-08-23]" do
      params = %{
        customer: "cus_123",
        source: "tok_123",
        items: [
          %{
            plan: "ruby-express-932",
            quantity: 1
          }
        ]
      }

      assert {:error, %StripeFork.Error{}} = StripeFork.Subscription.create(params)

      assert_stripe_requested(:post, "/v1/subscriptions")
    end
  end

  describe "update/2" do
    test "updates a subscription" do
      params = %{metadata: %{foo: "bar"}}
      assert {:ok, subscription} = StripeFork.Subscription.update("sub_123", params)
      assert_stripe_requested(:post, "/v1/subscriptions/#{subscription.id}")
    end

    test "fails with source param [since 2018-08-23]" do
      params = %{source: "tok_124", metadata: %{foo: "bar"}}
      assert {:error, %StripeFork.Error{}} = StripeFork.Subscription.update("sub_123", params)
      assert_stripe_requested(:post, "/v1/subscriptions/sub_123")
    end
  end

  describe "delete/1" do
    test "deletes a subscription" do
      assert {:ok, %StripeFork.Subscription{} = subscription} = StripeFork.Subscription.delete("sub_123")
      assert_stripe_requested(:delete, "/v1/subscriptions/#{subscription.id}")
    end
  end

  describe "delete/2" do
    test "deletes a subscription when second argument is a list" do
      assert {:ok, %StripeFork.Subscription{} = subscription} =
               StripeFork.Subscription.delete("sub_123", [])

      assert_stripe_requested(:delete, "/v1/subscriptions/#{subscription.id}")
    end

    test "with `at_period_end` is deprecated [since 2018-08-23]" do
      assert {:ok, %StripeFork.Subscription{} = subscription} =
               StripeFork.Subscription.delete("sub_123", %{at_period_end: true})

      assert subscription.cancel_at_period_end

      # The deprecated function acts as a facade for `cancel_at_period_end: true`.
      assert_stripe_requested(:update, "/v1/subscriptions/#{subscription.id}")
    end
  end

  describe "delete/3" do
    test "with `at_period_end` is deprecated [since 2018-08-23]" do
      assert {:ok, %StripeFork.Subscription{cancel_at_period_end: true}} =
               StripeFork.Subscription.delete("sub_123", %{at_period_end: true}, [])

      # The deprecated function acts as a facade for `cancel_at_period_end: true`.
      assert_stripe_requested(:update, "/v1/subscriptions/sub_123")
    end
  end

  describe "list/2" do
    test "lists all subscriptions" do
      assert {:ok, %StripeFork.List{data: subscriptions}} = StripeFork.Subscription.list()
      assert_stripe_requested(:get, "/v1/subscriptions")
      assert is_list(subscriptions)
      assert %StripeFork.Subscription{} = hd(subscriptions)
    end
  end

  describe "delete_discount/2" do
    test "deletes a subscription's discount" do
      {:ok, subscription} = StripeFork.Subscription.retrieve("sub_123")
      assert {:ok, _} = StripeFork.Subscription.delete_discount("sub_123")
      assert_stripe_requested(:delete, "/v1/subscriptions/#{subscription.id}/discount")
    end
  end
end
