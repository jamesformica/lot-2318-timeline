class AddEventsTable < ActiveRecord::Migration
	def change
		create_table :events do |t|
			t.decimal :event_id
			t.string :description
			t.boolean :major
			t.datetime :event_date

			t.timestamps null: false
		end
	end
end
