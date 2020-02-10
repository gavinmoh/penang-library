class Book < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_title, against: :title, using: [:tsearch]
  pg_search_scope :search_by_author, against: :author, using: [:tsearch]
  pg_search_scope :search_by_genre, against: :genre, using: [:tsearch]

  has_many :transactions, dependent: :destroy

  has_paper_trail

  validates :title, presence: true
  validates :author, presence: true
  validates :genre, presence: true
  validates :published_year, presence: true
  validates :serial_number, presence: true

  def status
    if self.transactions.where(checkin_timestamp: nil).exists?
      status = 'CHECKED_OUT'
    else
      status = 'AVAILABLE'
    end
  end

end
