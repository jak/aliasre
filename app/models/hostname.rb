require 'resolv'
require 'aws-sdk'

class Hostname < ActiveRecord::Base
  include Tokenable

  belongs_to :user

  validates_length_of :name, minimum: 5, too_short: 'needs to be 5 letters or more'
  validates_format_of :name, with: /\A[a-z]{1}[a-z0-9-]{4,}\z/, message: 'can only contain letters, numbers, hyphens, and must start with a letter'
  validates_format_of :ipaddress, :with => Resolv::IPv4::Regex, message: 'needs to be valid e.g. 185.14.187.149'

  validate :user_cant_have_too_many_hostnames, on: :create

  after_commit :update_dns, on: [:create, :update]
  after_commit :remove_dns, on: [:destroy]

  def fqdn
    "#{name}.alias.re."
  end

  def owned?
    user != nil
  end

  def to_param
    name
  end

  def update_url
    "https://alias.re/aliases/#{name}/updateip?token=#{token}"
  end

  def update_url_with_ip
    "#{update_url}&ip=#{ipaddress}"
  end

  private
    def user_cant_have_too_many_hostnames
      errors.add :user, "has too many aliases" if user != nil && user.hostnames.size > 5
    end

    def update_dns
      logger.debug "AWS #{fqdn} #{ipaddress}"
      rrset = AWS::Route53::ResourceRecordSet.new(fqdn, 'A', { hosted_zone_id: 'Z2I4BXNDC0JI3T' })
      if rrset.exists?
        logger.debug "Updating existing DNS record #{fqdn} #{ipaddress}"
        rrset.resource_records = [ { value: ipaddress } ]
        rrset.update
      else
        logger.debug "Creating new DNS record #{fqdn} #{ipaddress}"
        AWS::Route53::ResourceRecordSetCollection.new('Z2I4BXNDC0JI3T').create(fqdn, 'A', ttl: 60, resource_records: [{value: ipaddress}])
      end
    end

    def remove_dns
      logger.debug "Removing DNS record #{fqdn} #{ipaddress}"
      rrset = AWS::Route53::ResourceRecordSet.new(fqdn, 'A', { hosted_zone_id: 'Z2I4BXNDC0JI3T' }).delete
   end
end
