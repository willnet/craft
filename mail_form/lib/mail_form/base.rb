module MailForm
  class Base
    include ActiveModel::AttributeMethods
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Validations
    include MailForm::Validators
    extend ActiveModel::Callbacks

    class_attribute :attribute_names
    self.attribute_names = []
    attribute_method_prefix 'clear_'
    define_model_callbacks :deliver

    def initialize(attributes = {})
      attributes.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if attributes
    end

    def self.attributes(*names)
      attr_accessor(*names)
      define_attribute_methods(names)
      self.attribute_names += names
    end

    def persisted?
      false
    end

    def deliver
      if valid?
        run_callbacks(:deliver) do
          MailForm::Notifier.contact(self).deliver
        end
      else
        false
      end
    end

    protected

    def clear_attribute(attribute)
      send("#{attribute}=", nil)
    end
  end
end
