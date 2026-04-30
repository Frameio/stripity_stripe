defmodule StripeFork.EventTest do
  use StripeFork.StripeCase, async: true

  describe "retrieve/2" do
    test "retrieves an event" do
      assert {:ok, %StripeFork.Event{}} = StripeFork.Event.retrieve("evt_123")
      assert_stripe_requested(:get, "/v1/events/evt_123")
    end
  end

  describe "list/2" do
    test "lists all events" do
      assert {:ok, %StripeFork.List{data: [%StripeFork.Event{}]}} = StripeFork.Event.list()
      assert_stripe_requested(:get, "/v1/events")
    end
  end
end
