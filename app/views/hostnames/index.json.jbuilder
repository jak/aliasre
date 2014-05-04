json.array!(@hostnames) do |hostname|
  json.extract! hostname, :id, :name, :user_id, :status, :ipaddress
  json.url hostname_url(hostname, format: :json)
end
