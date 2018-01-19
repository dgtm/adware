require "spec_helper"
require_relative "../lib/adware"
describe Advertisement do
  describe "Comparisons" do
    let(:ad_one) { Advertisement.new(reference_id: 1, status: "active", description: "It is active!" ) }

    it "has no differences" do
      ad_two = Advertisement.new(reference_id: 1, status: "active", description: "It is active!" )
      expect(ad_one == ad_two).to be true
      expect(ad_one.differences).to be_empty
    end

    it "has differences with status" do
      ad_two = Advertisement.new(reference_id: 1, status: "passive", description: "It is active!" )
      expect(ad_one == ad_two).to be false
      expect(ad_one.differences).to eq([{
        status: {
         one: "active",
         another: "passive"
       }
      }])
    end

    it "has differences with status and description" do
      ad_two = Advertisement.new(reference_id: 1, status: "passive", description: "It is passive!" )
      ad_one.compare(ad_two)
      expect(ad_one.differences).to eq([
        {
          status: {
             one: "active",
             another: "passive"
           }
         },
         {
           description: {
            one: "It is active!",
            another: "It is passive!"
          }
        }
      ])
    end
  end

end
