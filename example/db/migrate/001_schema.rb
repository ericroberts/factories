class Schema < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.integer :min
      t.integer :max
    end

    create_table :customers do |t|
      t.belongs_to :rate
      t.integer :revenue
      t.string :name
    end
  end
end
