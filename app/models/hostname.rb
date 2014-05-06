require 'resolv'
require 'aws-sdk'

class Hostname < ActiveRecord::Base
  belongs_to :user

  enum status: {
    :inactive => 0
  }

  validates_length_of :name, minimum: 5, too_short: 'needs to be 5 letters or more'
  validates_format_of :name, with: /\A[a-z]{1}[a-z0-9]{4,}\z/, message: 'needs to start with a letter and be alphanumeric'
  validates_format_of :ipaddress, :with => Resolv::IPv4::Regex, message: 'needs to be valid e.g. 185.14.187.149'

  validate :user_cant_have_more_than_one_hostname, on: :create

  after_commit :update_dns, on: [:create, :update]
  after_commit :remove_dns, on: [:destroy]

  private
    def user_cant_have_more_than_one_hostname
      errors.add :user, "can't add an alias at this time" if user.hostnames.size > 0
    end

    def fqdn
      "#{name}.alias.re."
    end

    def update_dns
      logger.debug "AWS #{fqdn} #{ipaddress}"
      r53 = AWS.route_53
      hosted_zone = r53.hosted_zones['Z2I4BXNDC0JI3T']
      hosted_zone.rrsets
      rrset = hosted_zone.rrsets[fqdn, 'A']
      if rrset.exists?
        logger.debug "Updating existing DNS record #{fqdn} #{ipaddress}"
        rrset.resource_records = [{:value => ipaddress}]
        rrset.update
      else
        logger.debug "Creating new DNS record #{fqdn} #{ipaddress}"
        hosted_zone.rrsets.create(fqdn, 'A', :ttl => 60, :resource_records => [{:value => ipaddress}])
      end  
    end
end
