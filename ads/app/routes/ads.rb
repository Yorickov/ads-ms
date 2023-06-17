# frozen_string_literal: true

class App
  hash_branch 'ads' do |r|
    r.on 'v1' do
      r.get do
        page = params[:page].presence || 1
        ads = Ad.reverse_order(:updated_at)
                .paginate(page.to_i, Config.app.page_size)

        AdSerializer.new(ads.all, links: pagination_links(ads)).serializable_hash.to_json
      end

      r.post do
        ad_params = validate_with!(AdParamsContract)
        result = Ads::CreateService.call(
          ad: ad_params[:ad],
          user_id: params[:user_id]
        )

        if result.success?
          response.status = 201
          AdSerializer.new(result.ad).serializable_hash.to_json
        else
          response.status = 422
          error_response(result.ad).to_json
        end
      end
    end
  end
end
