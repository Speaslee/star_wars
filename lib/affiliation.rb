class Affiliation < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :memberships
  has_many :characters, through: :memberships


  def make_affiliation m
    m = name

    self.create(
    name: name
    )
  end

end
