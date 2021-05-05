class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|

      t.string :username
      t.string :name
      t.string :password
      t.string :token
      t.boolean :matchmaking
      t.belongs_to :board
      t.timestamps
    end
  end
end
