module AffirmativeAndNegativeWords
  def self.to_s
    I18n.translate(:affirmative_and_negative_words).flatten.join(",")
  end
end
