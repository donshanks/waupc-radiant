class CreateBookings < ActiveRecord::Migration
  def self.up
  	create_table :fm_bookings, :options => "ENGINE=InnoDB" do |t|
      t.integer  "deputation_id",               :default => 0,      :null => false
      t.integer  "church_id"
      t.string   "status",        :limit => 20, :default => "open", :null => false
      t.date     "date_of"
      t.time     "time_of"
      t.string   "meridian",      :limit => 2,  :default => "pm",   :null => false
      t.string   "email"
      t.text     "notes"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index :fm_bookings, ["date_of"],       :name => "fm_book_date_of_idx"
    add_index :fm_bookings, ["church_id"],     :name => "fm_book_church_id_idx"
    add_index :fm_bookings, ["deputation_id"], :name => "fm_book_deputation_id_idx"
  end

  def self.down
    drop_table :fm_bookings
  end
end
