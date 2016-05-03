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

		if !event.nil? then
			# make the event image folder if it doesnt exist
			dirname = FileHelper.get_event_folder_path(event.id)
			unless File.directory?(dirname)
				FileUtils.mkdir_p(dirname)
			end

			# write the images to file in the event folder
			params[:files].map do |file|
				real_file = File.open(file[:tempfile], 'rb')

				filename = file[:filename]
				basename = File.basename(filename, ".*")
				extension = File.extname(filename)

				new_filename = "#{dirname}/#{basename}_#{Time.now.to_i}#{extension}"

				File.open(new_filename, 'wb') do |eventfile|
					eventfile.write(real_file.read)
				end
			end
		end
	end

	def self.delete_event(id)
		if Event.find(id).destroy then
			# delete the event folder and all the files
			FileUtils.rm_rf("./public/events/event_#{id}")
		end
	end
end