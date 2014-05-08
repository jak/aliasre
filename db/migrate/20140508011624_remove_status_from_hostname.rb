class RemoveStatusFromHostname < ActiveRecord::Migration
  def change
  	remove_column :hostnames, :status
  end
end
