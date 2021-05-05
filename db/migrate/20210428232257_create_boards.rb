class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.text :board
      t.string :winner
      t.string :turn
      t.timestamps
    end
  end
end
