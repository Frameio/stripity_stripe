defmodule StripeFork.CountrySpecTest do
  use StripeFork.StripeCase, async: true

  describe "retrieve/2" do
    test "retrieves a country spec" do
      assert {:ok, %StripeFork.CountrySpec{}} = StripeFork.CountrySpec.retrieve("US")
      assert_stripe_requested(:get, "/v1/country_specs/US")
    end
  end

  describe "list/2" do
    test "lists all country specs" do
      assert {:ok, %StripeFork.List{data: country_specs}} = StripeFork.CountrySpec.list()
      assert_stripe_requested(:get, "/v1/country_specs")
      assert is_list(country_specs)
      assert %StripeFork.CountrySpec{} = hd(country_specs)
    end
  end
end
