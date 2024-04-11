# frozen_string_literal: true

module Test
  class Utils
    def self.generate_token(safebox_id)
      Safebox.find(safebox_id).generate_token_for(:open)
    end
  end
end
