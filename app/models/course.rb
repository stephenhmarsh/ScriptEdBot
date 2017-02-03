class Course # because we can't exactly call it a Class, now can we?
  has_many :users
  has_many :teams

  def leaderboard
    users.sort_by do |user|
      user.points_total
    end
  end
end
