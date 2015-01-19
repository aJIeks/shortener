class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string      :key,            default: ''
      t.string      :url,            default: ''
      t.integer     :visits_count, default: 0
      t.string      :digest,         default: ''
      t.timestamps

      t.index       :key, unique: true
      t.index       :digest, unique: true
    end
  end
end
