module OwnedStereotype
  extend ActiveSupport::Concern

  included do
    scope :all, lambda { |user|
      user_and_descendent_ids = user.descendent_ids
      user_and_descendent_ids << user.id
      joins(:ownership).
      where("(ownerships.value = 'global')
              OR (owner_id = ?)
              OR (ownerships.value = 'user and descendents' AND owner_id in (?))", user.id, user_and_descendent_ids)}
  end

  def editable?(user)
    user === self.owner
  end

  def viewable?(user)
    self.class.all(user).blank? ? false : true
  end

end
