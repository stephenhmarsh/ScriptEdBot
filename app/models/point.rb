class Point < ApplicationRecord
  belongs_to :pointable, polymorphic: true
end
