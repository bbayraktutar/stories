class Authentication < ApplicationRecord
  validates_uniqueness_of :provider, scope: [:uid]

  belongs_to :user, inverse_of: :authentications, counter_cache: true

end
