module TaggableStereotype
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    has_many :tags, class_name: "Tagging::Tag"
  end

  # Return string tag value for tag whose key is given as arg
  def get_tag_value tag_key_name
    tag = self.tags.joins(:tag_key).where('tagging_tag_keys.name = ?', tag_key_name).includes(:tag_value).first
    tag.try(:tag_value).try(:value)
  end

  module ClassMethods
    # Use this method in the class definition to create helper methods for fetching tag values
    def taggable *tag_key_names
      tag_key_names.each do |name|
        define_method name do
          get_tag_value name
        end
      end
    end
  end
end