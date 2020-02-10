class WhoDidIt
  def self.find(id)
    User.find(id).email
    # this is to show user email instead of user id, can change to name or others
  end
end

PaperTrailScrapbook.configure do |config|
  config.whodunnit_class = WhoDidIt
  config.recent_first = true # view recent story first
end
