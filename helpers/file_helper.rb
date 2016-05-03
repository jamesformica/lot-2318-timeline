module FileHelper
	def self.get_event_folder_path(event_id)
		return "./public/events/event_#{event_id}"
	end


	def self.get_image_path(event_id, filename)
		return "events/event_#{event_id}/#{filename}"
	end
end