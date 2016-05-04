module EventHelper

	UPLOAD_JS_FUNCTION = "Upload.Initialise"

	def self.get_or_create_event(id)
		if id.nil? then
			return Event.new(major: true, event_date: Date.today)
		else
			return Event.find(id)
		end
	end

	def self.process_upload(id, params)
		date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
		major = params[:major]
		description = params[:description]
		
		event = nil

		if id.nil? then
			# create new event
			new_event = Event.new(description: description, major: major, event_date: date)

			if new_event.save! then
				event = new_event
			end
		else
			# retrieve existing event
			existing_event = Event.find(id.to_i)
			if existing_event.update(description: description, major: major, event_date: date) then
				event = existing_event
			end
		end

		if !event.nil? & params[:files] then	
			# save files to corresponding event folder
			dirname = FileHelper.create_event_folder(event.id)
			FileHelper.save_files(params[:files], dirname)
		end
	end

	def self.delete_event(id)
		if Event.find(id).destroy then
			# delete the event folder and all the files
			FileUtils.rm_rf(FileHelper.get_event_folder_path(id))
		end
	end
end