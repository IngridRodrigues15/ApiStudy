require 'resolv'

class Dns < ApplicationRecord
  self.table_name = "dns"
  has_many :dns_hosts
  has_many :hostnames, through: :dns_hosts

  validates :ip, presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }

  scope :by_domain, ->(domain) { joins(:hostnames).where(hostnames: { domain: domain} ) }
  scope :group_by_ip, -> { select('dns.id', 'dns.ip').group('dns.id', 'dns.ip').having('count(ip) > 1') }
end
