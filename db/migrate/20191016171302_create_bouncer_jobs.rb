class CreateBouncerJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :bouncer_jobs do |t|
      t.string :clientMAC
      t.integer :targetVLAN
    end
  end
end
