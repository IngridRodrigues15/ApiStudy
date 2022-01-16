module DnsRecords
  ###
  # Class responsible for creating dns records and their associated hostnames
  # Input: 
  #  - dns_ip: a dns record 
  #  - hostnames_attributes: a list of hostnames associated to dns 
  # Output:
  #  - Dns record created
  ###
  class Creator < ApplicationService
    attr_reader :dns_ip, :hostnames_attributes

    def initialize(dns_ip, hostnames_attributes)
      @dns_ip = dns_ip
      @hostnames_attributes = hostnames_attributes
    end

    def call
      create_dns
      create_hostnames
      dns
    end

    private

    attr_accessor :dns

    def create_dns
      @dns ||= Dns.find_or_create_by(ip: dns_ip)
    end

    def create_hostnames
      hostnames_attributes.each do |hostnames_attribute|
        hostname = Hostname.create(domain: hostnames_attribute[:hostname])
        associate_hostnames_to_dns(dns, hostname)
      end

    end

    def associate_hostnames_to_dns(dns, hostname)
      DnsHost.create(dns: dns, hostname: hostname)
    end
  end 
end