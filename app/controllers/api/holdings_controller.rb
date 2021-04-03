module Api
  class HoldingsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      Holdings::Create.new(**holding_params).call

      render json: { ok: true }
    end

    private

    def holding_params
      params.require(:holding).permit!.to_h.symbolize_keys
    end
  end
end