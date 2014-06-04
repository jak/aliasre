class AddTokenToHostname < ActiveRecord::Migration
  def change
    add_column :hostnames, :token, :string
    Hostname.reset_column_information
    reversible do |dir|
      dir.up do
        Hostname.where(token: nil).each do |hostname|
          hostname.generate_token
          hostname.save
        end
      end
    end
  end
end
