class AddPostedImageToMicroposts < ActiveRecord::Migration
  def self.up
    add_attachment :microposts, :posted_image
  end

  def self.down
    remove_attachment :microposts, :posted_image
  end
end
