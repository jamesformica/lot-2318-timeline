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
		@events = Event.order(:event_date)
		slim :index
	end

	get '/upload' do
		@events = Event.order(:event_date)
		slim :upload
	end

	post '/upload' do
		event = nil
		existing_event = params[:existing_event]

		if existing_event.to_s.length == 0 then
			# create new event
			date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
			major = params[:major]
			description = params[:description]

			new_event = Event.new(description: description, major: major, event_date: date)

			if new_event.save! then
				event = new_event
			end

		else
			# retrieve existing event
			event = Event.find(existing_event.to_i)
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

				File.open("#{dirname}/#{file[:filename]}", 'wb') do |eventfile|
					eventfile.write(real_file.read)
				end
			end
		end

		redirect to('/upload')
	end
end