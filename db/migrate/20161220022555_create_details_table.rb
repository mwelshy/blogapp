class CreateDetailsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :details do |t|
  		t.integer :user_id
  		t.string :sex
  		t.integer :age
  		t.string :location
  	end
  end
end
