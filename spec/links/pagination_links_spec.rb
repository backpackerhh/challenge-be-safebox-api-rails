# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaginationLinks, type: :link do
  describe "without explicit pagination query params" do
    it "generates expected links" do
      links = described_class.build(
        url_lambda: ->(params) { api_v1_safebox_safebox_items_url(123, params) },
        query_params: {},
        total_count: 1
      )

      expect(links).to eq(
        {
          "first" => api_v1_safebox_safebox_items_url(123, "page[number]" => 1),
          "next" => nil,
          "prev" => nil,
          "last" => api_v1_safebox_safebox_items_url(123, "page[number]" => 1)
        }
      )
    end
  end

  describe "with explicit pagination query params" do
    it "generates expected links for given page size" do
      links = described_class.build(
        url_lambda: ->(params) { api_v1_safebox_safebox_items_url(123, params) },
        query_params: { page: { size: 2 } },
        total_count: 5
      )

      expect(links).to eq(
        {
          "first" => api_v1_safebox_safebox_items_url(123, "page[number]" => 1, "page[size]" => 2),
          "next" => api_v1_safebox_safebox_items_url(123, "page[number]" => 2, "page[size]" => 2),
          "prev" => nil,
          "last" => api_v1_safebox_safebox_items_url(123, "page[number]" => 3, "page[size]" => 2)
        }
      )
    end

    it "generates expected links for given page number" do
      links = described_class.build(
        url_lambda: ->(params) { api_v1_safebox_safebox_items_url(123, params) },
        query_params: { page: { number: 3 } },
        total_count: 50
      )

      expect(links).to eq(
        {
          "first" => api_v1_safebox_safebox_items_url(123, "page[number]" => 1),
          "next" => api_v1_safebox_safebox_items_url(123, "page[number]" => 4),
          "prev" => api_v1_safebox_safebox_items_url(123, "page[number]" => 2),
          "last" => api_v1_safebox_safebox_items_url(123, "page[number]" => 5)
        }
      )
    end

    it "generates expected links for given page number and size" do
      links = described_class.build(
        url_lambda: ->(params) { api_v1_safebox_safebox_items_url(123, params) },
        query_params: { page: { number: 2, size: 2 } },
        total_count: 5
      )

      expect(links).to eq(
        {
          "first" => api_v1_safebox_safebox_items_url(123, "page[number]" => 1, "page[size]" => 2),
          "next" => api_v1_safebox_safebox_items_url(123, "page[number]" => 3, "page[size]" => 2),
          "prev" => api_v1_safebox_safebox_items_url(123, "page[number]" => 1, "page[size]" => 2),
          "last" => api_v1_safebox_safebox_items_url(123, "page[number]" => 3, "page[size]" => 2)
        }
      )
    end

    it "generates expected links for a page number out of bounds" do
      links = described_class.build(
        url_lambda: ->(params) { api_v1_safebox_safebox_items_url(123, params) },
        query_params: { page: { number: 4, size: 2 } },
        total_count: 5
      )

      expect(links).to eq(
        {
          "first" => api_v1_safebox_safebox_items_url(123, "page[number]" => 1, "page[size]" => 2),
          "next" => nil,
          "prev" => nil,
          "last" => api_v1_safebox_safebox_items_url(123, "page[number]" => 3, "page[size]" => 2)
        }
      )
    end
  end
end
