class Character < ActiveRecord::Base
validates_presence_of :name
validates_uniqueness_of :name

has_many :memberships
has_many :affiliations, through: :memberships
end
