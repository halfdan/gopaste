class Paste
  include MongoMapper::Document

  before_create :generate_slug

  key :slug, String#, :required => true
  key :name, String, :default => ''
  key :author, String
  key :language, :default => 'text'
  key :code, String, :required => true
  key :private, Boolean, :default => false
  timestamps!

  def generate_slug
    self.slug = SecureRandom.hex(6)
  end
end