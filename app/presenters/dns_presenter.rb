# frozen_string_literal: true
# This class is responsible to present all dns informations

class DnsPresenter
  attr_reader :excluded, :included

  def initialize(params)
    @excluded = params[:excluded]
    @included = params[:included].present? ? params[:included].split(',') : params[:included]
  end

  def render
    {
      total_records: total_records,
      records: dns_records,
      related_hostnames: related_hostnames,
    }
  end

  private

  def total_records
    dns.length
  end

  def dns_records
    dns_records = []
    dns.each do |dns_record|
      dns_records << { id: dns_record.id, ip_address: dns_record.ip }
    end
    dns_records
  end

  def related_hostnames
    hostnames_records = []
    hostnames.each do |hostname|
      hostnames_records << { count: hostname[1], hostname: hostname[0] }
    end
    
    hostnames_records
  end

  def dns
    dns = Dns.all
    dns = Dns.by_domain(included).group_by_ip if included
    dns = dns - Dns.by_domain(excluded) if excluded
    dns
  end

  def hostnames
    sort = false

    if excluded.blank? && included.blank?
      hostnames =  Hostname.all
    elsif excluded && included
      domains = included << excluded
      hostnames = Hostname.included_dns(dns.pluck(:id))
                          .excluded_domain(domains)
    elsif excluded
      hostnames = Hostname.excluded_domain(excluded)
                          .excluded_dns(Dns.by_domain(excluded).pluck(:id))
    elsif included
      sort = true
      hostnames = Hostname.included_dns(dns.pluck(:id))
                          .excluded_domain(included)
    end

    format_hostname(hostnames: hostnames, sort: sort )
  end

  def format_hostname(hostnames:, sort: )
    hosts = Hostname.group_by_domain(hostnames: hostnames )
    return hosts.sort if sort
    hosts
  end
end