class Advertisement
  attr_accessor :differences
  attr_accessor :status, :reference_id, :description

  class << self
    def fields_to_compare
      [:reference_id, :status, :description]
    end
  end

  def initialize(params)
    self.class.fields_to_compare.each do |f|
      self.instance_variable_set("@#{f}", params[f])
    end
    @differences = []
  end

  def ==(another)
    compare(another)
    differences.present?
  end

  def compare(another)
    return {} unless another.reference_id
    self.class.fields_to_compare.each do |field|
    value_for_self = self.send(field)
    value_for_another = another.send(field)
      if value_for_self != value_for_another
        @differences << {
          field => {
            one: value_for_self,
            another: value_for_another
          }
        }
      end
    end
  end
end
