require "adware/version"
require "advertisement"
require "advertisement_list"

module Adware
  def self.default_local_campaigns
    [
      {
        id: 1,
        external_reference: "2",
        status: "paused",
        description: "Join here soon"
      },
      {
        id: 2,
        external_reference: "3",
        status: "active",
        description: "Description for campaign 13"
      }
    ]
  end

  def self.default_remote_campaigns
    {
      ads: [
        {
          reference: "1",
          status: "enabled",
          description: "Description for campaign 11"
        },
        {
          reference: "2",
          status: "disabled",
          description: "Description for campaign 12"
        },
        {
          reference: "3",
          status: "enabled",
          description: "Description for campaign 13"
        }
      ]
    }
  end

  def compare
    # Ad.new(id: reference, status: status, description: description)
    #
    # available_campaigns = campaigns.map do |campaign|
    #   app_obj = Ad.new(id: campaign.external_reference, status: campaign.status, description: campaign.ad_description)
    #   ad_service_element = ad_service_listing.find{|l| campaign.external_reference == l[:reference] }
    #   ad_service_obj = Ad.new(ad_service_element)
    #
    #   # unless app_obj == ad_service_obj
    #   #   {
    #   #     reference_id:
    #   #   }
    #   # end
    # end
  end

  STATUS_MAPPINGS = {
    active: :enabled,
    paused: :disabled
  }
end
