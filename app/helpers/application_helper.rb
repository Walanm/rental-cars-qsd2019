module ApplicationHelper
  def attr_translate(model_attribute)
    t("activerecord.attributes.#{model_attribute}")
  end

  def model_translate(model)
    return t("activerecord.models.#{model}.one") unless model[-1] == 's'

    t("activerecord.models.#{model[0..-2]}.other")
  end
end
