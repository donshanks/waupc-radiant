class CreateDeputations < ActiveRecord::Migration
  def self.up
  	create_table :fm_deputations, :option => "ENGINE=InnoDB" do |t|
      t.integer  "missionary_id",                   :default => 0,        :null => false
      t.string   "status",           :limit => 20,  :default => "active", :null => false
      t.date     "date_start"
      t.date     "date_end"
      t.string   "method_of_travel", :limit => 128
      t.string   "accomodations",    :limit => 128
      t.integer  "number_in_party",                 :default => 1,        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index :fm_deputations, ["missionary_id"], :name => "fm_dep_missionary_id_idx"
    add_index :fm_deputations, ["date_start"],    :name => "fm_dep_date_start_idx"
    add_index :fm_deputations, ["date_end"],      :name => "fm_dep_date_end_idx"
  end

  def self.down
    drop_table :fm_deputations
  end
end
