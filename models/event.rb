class Event < ActiveRecord::Base
	validates :event_id, presence: true
	validates :description, presence: true
	validates :major, presence: true
	validates :event_date, presence: true
end