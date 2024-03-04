class Content < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
end
