require 'sinatra'
require 'sinatra/json'
require 'sinatra/asset_pipeline'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/base'
require 'fileutils'
require 'sass'
require 'slim'
require 'active_support/core_ext/integer/inflections'

class App < Sinatra::Base

	INDEX_JS_FUNCTION = "Index.Initialise"
	UPLOAD_JS_FUNCTION = "Upload.Initialise"
	GALLERY_JS_FUNCTION = "Gallery.Initialise"

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
		@init_function = App::INDEX_JS_FUNCTION
		@events = Event.order(event_date: :desc)
		@latest_image_file = FileHelper.get_random_event_image(@events.first.id)

		slim :index
	end

	get '/gallery/:id' do |id|
		@init_function = App::GALLERY_JS_FUNCTION
		@event_id = id.to_i

		slim :gallery, layout: :js_layout
	end

	get '/upload/?:id?' do |id|
		@init_function = App::UPLOAD_JS_FUNCTION
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

	post '/deleteimage' do
		FileHelper.delete_event_image(params[:event_id], params[:file_name])
	end
end