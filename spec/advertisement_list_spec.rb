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
    let(:matching_remote_ads) do
      [
        Advertisement.new(reference_id: 1, status: "active", description: "It is active!" ),
        Advertisement.new(reference_id: 2, status: "active", description: "It is active!" ),
        Advertisement.new(reference_id: 3, status: "paused", description: "It is paused!" )
      ]

    end
    it "with no differences" do
      list = AdvertisementList.new(local_ads, matching_remote_ads)
      list.compare
      expect(list.differences).to be_empty
    end

    it "with remote references not in local" do
      remote_ads = [*matching_remote_ads,
        Advertisement.new(reference_id: 4, status: "active", description: "Reference number 4" )
      ]
      list = AdvertisementList.new(local_ads, remote_ads)
      list.compare
      expect(list.differences).to eq([
        {
          reference_id: 4,
          differences: [{
            base: ["Object not found in local"]
          }]
        }])
    end

    it "with locally deleted references" do
      remote_ads = [*local_ads,
        Advertisement.new(reference_id: 4, status: "deleted", description: "Reference number 4" )
      ]

      list = AdvertisementList.new(local_ads, remote_ads)
      list.compare
      expect(list.differences).to eq([
        {
          reference_id: 4,
          differences: [{
            base: ["Object not found in local"]
          }]
        }])
    end

    it "with local references not in remote" do
      new_ads = [
        Advertisement.new(reference_id: 4, status: "active", description: "Reference number 4" ),
        Advertisement.new(reference_id: 5, status: "active", description: "Reference number 5" )
      ]
      list = AdvertisementList.new(local_ads.push(new_ads).flatten, matching_remote_ads)
      list.compare
      expect(list.differences).to eq([
        {
          reference_id: 4,
          differences: [{
            base: ["Object not found in remote"]
          }]
        },
        {
          reference_id: 5,
          differences: [{
            base: ["Object not found in remote"]
          }]
        }
        ])
    end

  end
end
