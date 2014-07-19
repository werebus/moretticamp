class PositiveLengthValidator < ActiveModel::EachValidator
  # Use to validate the end_date
  def validate_each(record, attribute, value)
    if value.present? && record.start_date.present? && value < record.start_date
      record.errors[attribute] << (options[:message] || "must be after #{record.start_date}")
    end
  end
end
