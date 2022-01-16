require 'rails_helper'

RSpec.describe Hostname, type: :model do
  describe 'validations' do
    subject { described_class.new }

    context 'domain' do
      it 'validates presence' do
        subject.save 
        expect(subject.errors.full_messages).to include("Domain can't be blank")
      end
    end
  end

  describe 'scope' do
    describe '.excluded_domain' do
      subject { described_class.excluded_domain(domain) }

      let(:domain) { 'hello.com' }
      let(:domain1) { 'netflix.com' }
      let(:domain2) { 'amazon.com' }

      let(:hostname) { Hostname.create(domain: domain) }
      let(:hostname1) { Hostname.create(domain: domain1) }
      let(:hostname2) { Hostname.create(domain: domain2) }
      let(:dns) { Dns.create(ip: '11.11.11.1') }

      before do
        DnsHost.create(dns: dns, hostname: hostname)
        DnsHost.create(dns: dns, hostname: hostname1)
        DnsHost.create(dns: dns, hostname: hostname2)
      end

      it 'returns all hostnames except the excluded domain' do
        expect(subject).to eq [hostname1, hostname2]
      end
    end

    describe '.included_dns' do
      subject { described_class.included_dns(dns.id) }

      let(:hostname1) { Hostname.create(domain: 'hello.com') }
      let(:hostname2) { Hostname.create(domain: 'netflix.com') }
      let(:hostname3) { Hostname.create(domain: 'amazon.com') }
      let(:dns) { Dns.create(ip: '11.11.11.1') }

      before do
        DnsHost.create(dns: dns, hostname: hostname1)
        DnsHost.create(dns: dns, hostname: hostname2)
        DnsHost.create(dns: dns, hostname: hostname3)
      end

      it 'returns all domains associated to dns' do
        expect(subject).to eq [hostname1, hostname2, hostname3]
      end
    end

    describe '.excluded_dns' do
      subject { described_class.excluded_dns(dns.id) }
      
      let(:hostname1) { Hostname.create(domain: 'hello.com') }
      let(:hostname2) { Hostname.create(domain: 'netflix.com') }
      let(:hostname3) { Hostname.create(domain: 'amazon.com') }
      let(:dns) { Dns.create(ip: '11.11.11.1') }
      let(:dns2) { Dns.create(ip: '22.22.22.2') }

      before do
        DnsHost.create(dns: dns, hostname: hostname1)
        DnsHost.create(dns: dns2, hostname: hostname2)
        DnsHost.create(dns: dns2, hostname: hostname3)
      end

      it 'returns all domains not associated to dns' do
        expect(subject).to eq [hostname2, hostname3]
      end
    end
  end

  describe '.group_by_domain' do
    subject { described_class.group_by_domain(hostnames: hostnames) }

    let(:domain) { 'hello.com' }
    let(:domain1) { 'netflix.com' }
    let(:domain2) { 'amazon.com' }

    let(:hostname1) { Hostname.create(domain: domain) }
    let(:hostname2) { Hostname.create(domain: domain) }

    let(:hostname3) { Hostname.create(domain: domain1) }
    let(:hostname4) { Hostname.create(domain: domain1) }
    let(:hostname5) { Hostname.create(domain: domain1) }

    let(:hostname6) { Hostname.create(domain: domain2) }

    let(:hostnames) do 
      [hostname1, hostname2, hostname3, hostname4, hostname5, hostname6]
    end

    let(:expected_response) do
      {domain=>2, domain1=>3, domain2=>1}
    end

    it 'group same domains and count' do
      expect(subject).to eq expected_response
    end
  end
end
