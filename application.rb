require 'sinatra'
require 'sinatra/json'
require 'sinatra/asset_pipeline'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/base'
require 'fileutils'
require 'sass'
require 'slim'

class App < Sinatra::Base

	(Dir['./models/*.rb'].sort).each do |file|
		require file
	end

	(Dir['./helpers/*.rb'].sort).each do |file|
		require file
	end

	set :root, File.dirname(__FILE__)
	set :public_folder, File.dirname(__FILE__) + '/public/'
	set :assets_prefix, %w(app/assets vendor/assets)

	register Sinatra::AssetPipeline
	
	configure :development do
		register Sinatra::Reloader
	end
	
	get '/' do
		@events = Event.order(event_date: :desc)
		slim :index
	end

	get '/upload' do
		@init_function = "Upload.Initialise"
		@event = Event.new(major: true, event_date: Date.today)

		slim :upload
	end

	get '/edit/:id' do |id|
		@init_function = "Upload.Initialise"
		@event = Event.find(id)

		slim :upload
	end

	post '/upload/:id' do |id|
		id = id.to_i

		date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
		major = params[:major]
		description = params[:description]
		
		event = nil

		if id == -1 then
			# create new event
			new_event = Event.new(description: description, major: major, event_date: date)

			if new_event.save! then
				event = new_event
			end
		else
			# retrieve existing event
			existing_event = Event.find(id)
			if existing_event.update(description: description, major: major, event_date: date) then
				event = existing_event
			end
		end

		if !event.nil? then
			# make the event image folder if it doesnt exist
			dirname = "./public/events/event_#{event.id}"
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

		redirect to('/upload')
	end

	post '/delete/:id' do |id|
		id = id.to_i

		if Event.find(id).destroy then
			# delete the event folder and all the files
			FileUtils.rm_rf("./public/events/event_#{id}")
			return true
		end

		return false
	end
end