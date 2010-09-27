class CreateMissionaries < ActiveRecord::Migration
  def self.up
  	create_table :fm_missionaries, :options => "ENGINE=InnoDB" do |t|
      t.string   "firstname",  :limit => 128, :null => false
      t.string   "lastname",   :limit => 128, :null => false
      t.string   "labor",      :limit => 128, :null => false
      t.string   "phone",      :limit => 64
      t.string   "email"
      t.string   "poster"
      t.string   "website"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "fm_missionaries", ["lastname"], :name => "fm_mssn_lastname_idx"
  end

  def self.down
    drop_table :fm_missionaries
  end
end
