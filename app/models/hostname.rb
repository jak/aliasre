require 'resolv'

class Hostname < ActiveRecord::Base
  belongs_to :user

  enum status: {
  	:inactive => 0
  }

  validates_length_of :name, minimum: 5, too_short: 'needs to be 5 letters or more'
  validates_format_of :name, with: /\A[a-z]{1}[a-z0-9]{4,}\z/, message: 'needs to start with a letter and be alphanumeric'
  validates_format_of :ipaddress, :with => Resolv::IPv4::Regex, message: 'needs to be valid e.g. 185.14.187.149'
end
