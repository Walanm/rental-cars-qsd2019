module ApplicationHelper
  def attr_translate(model_attribute)
    t("activerecord.attributes.#{model_attribute}")
  end
end
