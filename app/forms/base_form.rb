class BaseForm < ActiveType::Object
  MAX_INTEGER = ((1 << 32) / 2) - 1
  MAX_BIGINT = ((1 << 64) / 2) - 1
  MAX_STRING = 255
  MAX_TEXT = 65535
  attr_accessor :model

  delegate :persisted?, to: :model, allow_nil: true

  def assign_model(model, params = {})
    @model = model
    @params = params.to_h.with_indifferent_access

    attributes.each do |k, _|
      self[k] = @params.key?(k) ? @params[k] : model.try(k)
    end

    self
  end
end
