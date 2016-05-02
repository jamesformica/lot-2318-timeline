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
		@events = Event.all
		slim :index
	end

	get '/upload' do
		slim :upload
	end

	post '/upload' do
		event = Event.first
		dirname = "./public/events/event_#{event.id}"

		file = params[:file]
		real_file = File.open(file[:tempfile], 'rb')

		unless File.directory?(dirname)
			FileUtils.mkdir_p(dirname)
		end

		File.open("#{dirname}/#{file[:filename]}", 'wb') do |eventfile|
			eventfile.write(real_file.read)
		end
	end
end