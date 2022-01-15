class CreateDnsHosts < ActiveRecord::Migration[6.1]
  def change
    create_table :dns_hosts do |t|
      t.references :dns, null: false, foreign_key: true
      t.references :hostname, null: false, foreign_key: true

      t.timestamps
    end
  end
end
