# frozen_string_literal: true

module SharedContext
  module Infrastructure
    class PaginationLinks
      def self.build(...)
        new(...).build
      end

      attr_reader :url_lambda, :query_params, :page_number, :last_page_number

      private_class_method :new

      def initialize(url_lambda:, query_params:, total_count:)
        @url_lambda = url_lambda
        @query_params = query_params
        @page_number = (query_params.dig(:page, :number) || PaginationValidator::DEFAULT_PAGE_NUMBER).to_i
        page_size = (query_params.dig(:page, :size) || PaginationValidator::DEFAULT_PAGE_SIZE).to_i
        @last_page_number = (total_count.to_f / page_size).ceil
      end

      def build
        {
          "first" => first_page_link,
          "next" => next_page_link,
          "prev" => previous_page_link,
          "last" => last_page_link
        }
      end

      def first_page_link
        pagination_link(1)
      end

      def next_page_link
        return if page_number >= last_page_number

        pagination_link(page_number + 1)
      end

      def previous_page_link
        return if page_number == 1
        return if page_number > last_page_number

        pagination_link(page_number - 1)
      end

      def last_page_link
        pagination_link(last_page_number)
      end

      def pagination_link(page)
        params = {
          **query_params,
          page: {
            **(query_params[:page] || {}),
            number: page
          }
        }

        url_lambda.call(params)
      end
    end
  end
end
