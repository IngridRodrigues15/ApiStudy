class CreateDns < ActiveRecord::Migration[6.1]
  def change
    create_table :dns do |t|
      t.binary :ip, null: false

      t.timestamps
    end
  end
end
