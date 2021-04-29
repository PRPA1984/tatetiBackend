class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|

      t.string :first_player
      t.string :second_player
      t.text :board
      t.timestamps
    end
  end
end
