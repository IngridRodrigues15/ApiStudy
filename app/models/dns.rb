require 'resolv'

class Dns < ApplicationRecord
  self.table_name = "dns"
  has_many :dns_hosts
  has_many :hostnames, through: :dns_hosts

  validates :ip, presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }
end
