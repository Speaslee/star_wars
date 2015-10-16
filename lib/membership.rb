class Membership < ActiveRecord::Base
validates_presence_of :character_id, :affiliation_id
validates_uniqueness_of :character_id, scope: :affiliation_id

belongs_to :character
belongs_to :affiliation
end
