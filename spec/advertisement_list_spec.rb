require "spec_helper"
require_relative "../lib/adware"
describe AdvertisementList do
  describe "Comparisons" do
    let(:local_ads) do
      [
        Advertisement.new(reference_id: 1, status: "active", description: "It is active!" ),
        Advertisement.new(reference_id: 2, status: "active", description: "It is active!" ),
        Advertisement.new(reference_id: 3, status: "paused", description: "It is paused!" )
      ]
    end
    it "has no differences" do
      remote_ads = [
        Advertisement.new(reference_id: 1, status: "active", description: "It is active!" ),
        Advertisement.new(reference_id: 2, status: "active", description: "It is active!" ),
        Advertisement.new(reference_id: 3, status: "paused", description: "It is paused!" )
      ]
      list = AdvertisementList.new(local_ads, remote_ads)
      list.compare
      expect(list.differences).to be_empty
    end

  end
end
