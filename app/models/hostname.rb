class Hostname < ApplicationRecord
  has_many :dns_hosts
  has_many :dns, through: :dns_hosts

  validates :domain, presence: true

  scope :excluded_domain, ->(domain) { joins(:dns).where.not(domain: domain) }
  scope :included_dns, ->(dns) { joins(:dns).where(dns: {id: dns}) }
  scope :excluded_dns, ->(dns) { joins(:dns).where.not(dns: {id: dns}) }

  def self.group_by_domain(hostnames:)
    hostnames.group_by(&:domain).transform_values(&:count)
  end
end
