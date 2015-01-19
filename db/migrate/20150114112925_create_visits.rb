class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references  :link
      t.timestamp   :visited_at
      t.string      :referal, default: ''
      t.inet        :ip,      default: '0.0.0.0'

      t.index       :link_id
      t.index       :visited_at
    end
  end
end
