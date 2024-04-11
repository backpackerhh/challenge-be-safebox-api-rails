# frozen_string_literal: true

module Api
  module V1
    class SafeboxItemsController < ApplicationController
      def index
        safebox = Safebox.find(params[:safebox_id])

        if safebox.locked?
          raise LockedSafeboxError, safebox.id
        end

        if !safebox.valid_token?(extract_token_from_auth_header)
          raise InvalidSafeboxTokenError, safebox.id
        end

        query_validator = ParametizableQueryValidator.new(query_params, sortable_by: %i[name created_at])

        if query_validator.valid?
          data = ParametizableQuery.new.run(
            SafeboxItem.where(safebox_id: safebox.id),
            **query_validator.query_params
          )

          successful_response(
            SafeboxItemCollectionSerializer.new(
              data[:results],
              is_collection: true,
              links: ListSafeboxItemsCollectionLinks.build(safebox.id, query_params, data[:total_results_count])
            ),
            status: :ok
          )
        else
          failed_response(query_validator.errors, status: :bad_request)
        end
      end

      def create
        safebox = Safebox.find(params[:safebox_id])

        if safebox.locked?
          raise LockedSafeboxError, safebox.id
        end

        if !safebox.valid_token?(extract_token_from_auth_header)
          raise InvalidSafeboxTokenError, safebox.id
        end

        raw_safebox_item_params = body_params
        safebox_item = SafeboxItem.create!(
          id: raw_safebox_item_params.dig("data", "id"),
          safebox_id: raw_safebox_item_params.dig("data", "relationships", "safebox", "data", "id"), # use safebox.id?
          name: raw_safebox_item_params.dig("data", "attributes", "name")
        )

        successful_response(
          SafeboxItemSerializer.new(safebox_item, params: { id: safebox.id }),
          status: :created
        )
      end
    end
  end
end
