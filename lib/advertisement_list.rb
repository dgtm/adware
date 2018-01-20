class AdvertisementList
  attr_accessor :differences

  def initialize(local_ads = [], remote_ads = [])
    @differences = []
    @local_ads = local_ads
    @remote_ads = remote_ads
  end

  def compare
    calculate_dangling_differences
    available_local_ads.each do |local_ad|
      remote_ad = @remote_ads.find{|l| l.reference_id == local_ad.reference_id }
      @differences << {
        reference_id: local_ad.reference_id,
        differences: local_ad.differences
      } unless local_ad == remote_ad
    end
  end

  private
  # Remote ads that have no local counterparts
  def dangling_remote_records
    @remote_ads.select{|record| !@local_ads.map(&:reference_id).include?(record.reference_id)}
  end

  # Local ads that have no remote counterparts
  def dangling_local_records
    @local_ads.select{|record| !@remote_ads.map(&:reference_id).include?(record.reference_id)}
  end

  # Local ads that are available in remote as well
  def available_local_ads
    @local_ads.select{|ad| !dangling_local_records.map(&:reference_id).include?(ad.reference_id)}
  end

  # Look for ads that are in local but not in remote or vice-versa.
  def calculate_dangling_differences
    dangling_local_records.each do |record|
      @differences << { reference_id: record.reference_id, differences: [{ base: ['Object not found in remote'] }] }
    end
    dangling_remote_records.each do |record|
      @differences << { reference_id: record.reference_id, differences: [{ base: ['Object not found in local'] }] }
    end
  end
end
