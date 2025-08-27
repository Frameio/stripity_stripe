defmodule StripeFork.FileUploadTest do
  use StripeFork.StripeCase, async: true

  describe "create/2" do
    @tag :skip
    test "creates a file" do
      assert {:ok, %StripeFork.FileUpload{}} = StripeFork.FileUpload.create(%{
        file: "@/path/to/a/file.jpg",
        purpose: "dispute_evidence"
      })
      assert_stripe_requested :post, "/v1/files"
    end
  end

  describe "retrieve/2" do
    test "retrieves an file" do
      assert {:ok, %StripeFork.FileUpload{}} = StripeFork.FileUpload.retrieve("file_123")
      assert_stripe_requested :get, "/v1/files/file_123"
    end
  end

  describe "list/2" do
    test "lists all files" do
      assert {:ok, %StripeFork.List{data: [%StripeFork.FileUpload{}]}} = StripeFork.FileUpload.list()
      assert_stripe_requested :get, "/v1/files"
    end
  end
end
