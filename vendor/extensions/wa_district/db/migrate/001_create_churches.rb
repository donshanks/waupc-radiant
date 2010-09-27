class CreateChurches < ActiveRecord::Migration
  def self.up
  	create_table :fm_churches, :options => "ENGINE=InnoDB" do |t|
      t.string   "name"
      t.string   "pastor"
      t.string   "city"
      t.string   "email"
      t.string   "status",      :limit => 20, :default => "active", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index :fm_churches, ["name"], :name => "fm_church_name_idx"
  end

  def self.down
    drop_table :fm_churches
  end
end
