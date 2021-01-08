# frozen_string_literal: true

class PositiveLengthValidator < ActiveModel::EachValidator
  # Used to validate the end_date
  def validate_each(record, attribute, value)
    return unless value.present? &&
                  record.start_date.present? &&
                  value < record.start_date

    record.errors.add(attribute, "must be after #{record.start_date}")
  end
end
