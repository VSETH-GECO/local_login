class CreateLoginLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :login_logs do |t|
      t.string :username
      t.string :mac

      t.timestamps
    end
  end
end
