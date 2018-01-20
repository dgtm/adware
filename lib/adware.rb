require "adware/version"
require "advertisement"
require "campaign"
require "advertisement_list"

module Adware
  class Base
    class << self
      STATUS_MAPPINGS = {
        "enabled" => "active",
        "disabled" => "paused"
      }

      # @return [Array<Hash>]
      # Returns a list of differences that looks like
      #[{
      #  :reference_id=>"3", :differences=>[{
      #     :status => { :one=>"deleted", :another=>"active" }
      #   }]
      # }]
      def find_differences(list_of_campaigns)
        local = serialized_local_campaigns(list_of_campaigns)
        ad_list_comparator = AdvertisementList.new(local, serialized_remote_campaigns)
        ad_list_comparator.compare
        ad_list_comparator.differences
      end

      private
      # Serialize the key/values from the model before passing for comparison
      def serialized_local_campaigns(campaigns = Campaign.all)
        campaigns.map do |campaign|
          # Because ruby does not have #blank?
          reference_available = !campaign.external_reference.empty? && !campaign.external_reference.nil?
          # Use the id of the campaign if there is no external_reference_id saved in the campaign
          reference_id = reference_available ? campaign.external_reference : campaign.id.to_s
          Advertisement.new(reference_id: reference_id, status: campaign.status, description: campaign.ad_description)
        end
      end

      def serialized_remote_campaigns
        Campaign.remote_data.map do |campaign|
          status = STATUS_MAPPINGS[campaign['status']] || campaign['status']
          Advertisement.new(reference_id: campaign['reference'], status: status, description: campaign['description'])
        end
      end
    end
  end
end
