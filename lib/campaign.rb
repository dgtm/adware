require 'ostruct'
require 'json'
require 'net/http'
# This class is a dummy database for local records
class Campaign
  attr_accessor :id, :external_reference, :status, :ad_description

  def initialize(params)
    @id = params[:id]
    @external_reference = params[:external_reference]
    @status = params[:status]
    @ad_description = params[:ad_description]
  end

  def to_json
    {
      id: @id,
      external_reference: @external_reference,
      status: @status,
      ad_description: @ad_description
    }
  end

  class << self
    # @return[Array<OpenStruct>]
    # Returns a set of objects that are stored on the local system
    # Sample database records
    # [
    #   { id: 1, external_reference: "2", status: "paused", ad_description: "Join this job soon" },
    #   { id: 2, external_reference: "3", status: "active", ad_description: "Description for campaign 13" },
    #   { id: 4, external_reference: "", status: "active", ad_description: "Description for campaign 14" }
    # ].map { |x| OpenStruct.new(x) }
    # @TODO Use ActiveRecord and store actual values to the db
    def all
      []
    end

    # @return[Array<Hash>]
    def remote_data
      remote_response['ads']
    end

    # @return[JSON] Response from the remote API
    def remote_response
      @response ||= Net::HTTP.get(URI "http://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df")
      JSON.parse(@response)
    end
  end
end
