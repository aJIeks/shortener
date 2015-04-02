class AddUserForLink < ActiveRecord::Migration
  def change
    change_table  :links do |t|
      t.integer   :user
      t.index     :user
    end
  end
end
