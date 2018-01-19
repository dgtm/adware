class AdvertisementList
  attr_accessor :differences

  def initialize(local_ads = [], remote_ads = [])
    @differences = []
    @local_ads = local_ads
    @remote_ads = remote_ads
  end

  def compare
    # Local ads that have no remote counterparts
    @dangling_local_references = @local_ads.map(&:reference_id) - @remote_ads.map(&:reference_id)
    # Remote ads that have no local counterparts
    @dangling_remote_references = @remote_ads.map(&:reference_id) - @local_ads.map(&:reference_id)

    available_local_ads = @local_ads.map(&:reference_id) - @dangling_local_references

    available_local_ads.each do |ad|
      local_ad = @local_ads.find{|l| l.reference_id == ad }
      remote_ad = @remote_ads.find{|l| l.reference_id == ad }
      @differences << {
        reference_id: local_ad.reference_id,
        differences: local_ad.differences
      } unless local_ad == remote_ad
    end
  end

end
