class RemoveStreamingPlatformAndUrlFromContents < ActiveRecord::Migration[7.1]
  def change
    remove_column :contents, :streaming_url
    remove_column :contents, :streaming_platform
  end
end
