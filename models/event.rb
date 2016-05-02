class Event < ActiveRecord::Base
	validates :description, presence: true
	validates :event_date, presence: true
end