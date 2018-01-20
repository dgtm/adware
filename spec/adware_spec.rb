require "spec_helper"
require_relative "../lib/adware"

describe Adware::Base do
  describe "Finding discrepancies" do
    let(:sample_response) do
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
      }.to_json
    end

    before do
      # Since we have only one get call throughout the app
      allow(Net::HTTP).to receive(:get).and_return(sample_response)
    end

    it "has no local campaigns" do
      campaigns = [
        { id: 1, external_reference: "2", status: "paused", ad_description: "Description for campaign 12" },
        { id: 2, external_reference: "3", status: "active", ad_description: "Description for campaign 13" },
        { id: 4, external_reference: "", status: "active", ad_description: "Description for campaign 11" }
      ].map { |x| OpenStruct.new(x) }

      expect(Adware::Base.find_differences(campaigns)).to eq([
        {
          :reference_id => "4",
          :differences => [{:base=>["Object not found in remote"]}]
        },
        {
          :reference_id => "1",
          :differences => [{:base=>["Object not found in local"]}]
        }
      ])
    end

    it "with different description" do
      campaigns = [
        { id: 1, external_reference: "2", status: "paused", ad_description: "Description for campaign 12" },
        { id: 2, external_reference: "3", status: "active", ad_description: "Description for campaign 13" },
        { id: 3, external_reference: "1", status: "active", ad_description: "Description for campaign 14" }
      ].map { |x| OpenStruct.new(x) }

      expect(Adware::Base.find_differences(campaigns)).to eq([{
        :reference_id => "1",
        :differences => [{
          :description =>
            {:one=>"Description for campaign 14", :another=>"Description for campaign 11"}
        }]
      }])
    end

    it "with the same campaigns in local and remote" do
      campaigns = [
        { id: 1, external_reference: "2", status: "paused", ad_description: "Description for campaign 12" },
        { id: 2, external_reference: "3", status: "active", ad_description: "Description for campaign 13" },
        { id: 3, external_reference: "1", status: "active", ad_description: "Description for campaign 11" }
      ].map { |x| OpenStruct.new(x) }

      expect(Adware::Base.find_differences(campaigns)).to eq([])
    end

    it "with the same campaigns in local and remote" do
      campaigns = [
        { id: 1, external_reference: "2", status: "paused", ad_description: "Description for campaign 12" },
        { id: 2, external_reference: "3", status: "active", ad_description: "Description for campaign 13" },
        { id: 3, external_reference: "1", status: "active", ad_description: "Description for campaign 11" }
      ].map { |x| OpenStruct.new(x) }

      expect(Adware::Base.find_differences(campaigns)).to eq([])
    end

    it "with campaigns deleted in local" do
      campaigns = [
        { id: 1, external_reference: "2", status: "paused", ad_description: "Description for campaign 12" },
        { id: 2, external_reference: "3", status: "deleted", ad_description: "Description for campaign 13" },
        { id: 3, external_reference: "1", status: "active", ad_description: "Description for campaign 11" }
      ].map { |x| OpenStruct.new(x) }

      expect(Adware::Base.find_differences(campaigns)).to eq(
        [{
          :reference_id=>"3", :differences=>[{
            :status => { :one=>"deleted", :another=>"active" }
          }]
        }]
      )
    end

    it "with no campaigns in local" do
      campaigns = []
      expect(Adware::Base.find_differences(campaigns)).to eq(
        [
          {
            :reference_id=> "1",
            :differences=>[{:base=>["Object not found in local"]}]
          },
          {
            :reference_id=> "2",
            :differences=>[{:base=>["Object not found in local"]}]
          },
          {
            :reference_id=> "3",
            :differences=>[{:base=>["Object not found in local"]}]
          }
      ])
    end
  end
end
