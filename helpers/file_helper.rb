module FileHelper
	def self.get_event_folder_path(event_id)
		return "./public/events/event_#{event_id}"
	end


	def self.get_image_path(event_id, filename)
		return "/events/event_#{event_id}/#{filename}"
	end

	def self.create_event_folder(event_id)
		dirname = FileHelper.get_event_folder_path(event_id)

		# make the event image folder if it doesnt exist
		unless File.directory?(dirname)
			FileUtils.mkdir_p(dirname)
		end

		return dirname
	end

	def self.save_files(files, dirname)
		# write the images to file in the event folder
		files.map do |file|
			real_file = File.open(file[:tempfile], 'rb')

			filename = file[:filename]
			basename = File.basename(filename, '.*')
			extension = File.extname(filename)

			new_filename = "#{dirname}/#{basename}_#{Time.now.to_i}#{extension}"

			File.open(new_filename, 'wb') do |eventfile|
				eventfile.write(real_file.read)
			end
		end
	end

	def self.get_random_event_image(event_id)
		dir = FileHelper.get_event_folder_path(event_id)

		random_file_path = Dir["#{dir}/*"].sample

		random_file_name = File.basename(random_file_path)

		return FileHelper.get_image_path(event_id, random_file_name)
	end
end