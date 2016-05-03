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
		
		first_event = @events.first

		puts Dir[FileHelper.get_event_folder_path(first_event.id)]
		random_file = Dir["#{FileHelper.get_event_folder_path(first_event.id)}/*"].sample
		random_file = File.basename(random_file)

		@latest_image_file = FileHelper.get_image_path(first_event.id, random_file)

		slim :index
	end

	get '/upload/?:id?' do |id|
		@init_function = EventHelper::UPLOAD_JS_FUNCTION
		@event = EventHelper.get_or_create_event(id)

		slim :upload
	end

	post '/upload/?:id?' do |id|
		EventHelper.process_upload(id, params)

		redirect to('/')
	end

	post '/delete/:id' do |id|
		EventHelper.delete_event(id.to_i)
	end
end