class CreateClienCouponEvents < ActiveRecord::Migration
  def change
    create_table :clien_coupon_events do |t|
      t.integer :event_id
      t.string :event_name
      t.string :event_url
      t.timestamps
    end
    add_index :clien_coupon_events, :event_id
  end
end
