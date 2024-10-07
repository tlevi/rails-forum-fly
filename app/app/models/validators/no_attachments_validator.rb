class NoAttachmentsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.respond_to?(:body) && value.body.attachments.any?
      record.errors.add(attribute, "Attachments are forbidden!")
    end
  end
end
