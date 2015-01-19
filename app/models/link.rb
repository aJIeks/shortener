class Link < ActiveRecord::Base
  has_many :visits, counter_cache: :visits_count

  SYMBOLS = {
      dig: %w(2 3 4 5 6 7 8 9),
      small_letter: %w(a b c d e f g h j k m n p q r s t u v w x y z),
      capital_letter: %w(A B C D E F G H J K L M N P Q R S T U V W X Y Z)
  }.freeze

  KEY_LENGTH = 6

  validates_presence_of   :key, :url, :digest
  validates_uniqueness_of :key, :digest

  before_validation :normalize_url
  before_validation :generate_key
  before_validation :calc_digest

  def track(env)
    visits.create(ip: env['REMOTE_ADDR'], referal: env['HTTP_REFERER'], visited_at: Time.now.getutc)
  end

  private

  def normalize_url
    self.url = 'http://' + self.url unless self.url.to_s.match /^http[s]?:\/\//
  end

  def calc_digest
    self.digest = Digest::CRC32.hexdigest(self.url)
  end

  def generate_key
    puts "KEY=#{self.key}"
    while(true) do
      new_key = ([nil] * KEY_LENGTH).map { SYMBOLS[SYMBOLS.keys.sample].sample } .join
      return self.key = new_key unless Link.exists?(key: new_key)
    end unless self.key.present?
  end
end
