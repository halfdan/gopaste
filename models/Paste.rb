class Paste
  include MongoMapper::Document

  before_create :generate_slug

  paginates_per 20

  key :slug, String#, :required => true
  key :name, String, :default => 'No title given'
  key :author, String, :default => 'Anonymous'
  key :language, :default => :plaintext
  key :code, String, :required => true
  key :private, Boolean, :default => false
  timestamps!

  def generate_slug
    self.slug = SecureRandom.hex(6)
  end
end
