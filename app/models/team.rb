class Team
  belongs_to :course
  has_many :users

  def points_total
    users.sum(&:points_total)
  end
end
