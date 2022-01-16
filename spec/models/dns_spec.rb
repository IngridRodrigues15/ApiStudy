require 'rails_helper'

RSpec.describe Dns, type: :model do
  describe 'validations' do
    subject { described_class.new }

    context 'ip' do
      it 'validates presence' do
        subject.save 
        expect(subject.errors.full_messages).to include("Ip can't be blank")
      end

      it 'validates format' do
        ip = Dns.create(ip: 'oi')
  
        expect(ip.errors.full_messages).to include("Ip is invalid")
      end

      it 'validates uniqueness' do
        ip1 = Dns.create(ip: '11.11.11.1')
        ip2 = Dns.create(ip: '11.11.11.1')
  
        expect(ip2.errors.full_messages).to include("Ip has already been taken")
      end
    end
  end
  
  describe 'scope' do
    describe 'by_domain' do
      subject { described_class.by_domain(domain) }

      context 'when there is dns records associated to domain' do
        let(:domain) { 'netflix.com' }
        let(:dns) { Dns.create(ip: '11.11.11.1') }
        let(:hostname) { Hostname.create(domain: domain) }

        before do
          DnsHost.create(dns: dns, hostname: hostname)
        end

        it 'returns dns records associated to domain' do
          expect(subject).to eq [dns]
        end
      end

      context 'when there are no dns records associated with the domain' do
        let(:domain) { 'nodns.com' }

        it 'returns dns records associated to domain' do
          expect(subject).to eq []
        end
      end
    end
  end
end
