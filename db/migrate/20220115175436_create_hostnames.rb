class CreateHostnames < ActiveRecord::Migration[6.1]
  def change
    create_table :hostnames do |t|
      t.string :domain, null: false
      t.timestamps
    end
  end
end
