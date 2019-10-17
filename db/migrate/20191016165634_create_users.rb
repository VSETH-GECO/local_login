class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :mac
      t.string :ip
      t.string :switch
    end
  end
end
