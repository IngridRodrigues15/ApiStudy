# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DnsRecords::Creator do
  describe '.call' do
    let(:ip) { '1.1.1.1' }
    let(:netflix) { 'netflix.com' }
    let(:amazon) { 'amazon.com' }

    let(:hostnames_attributes) do 
     [
        {
          hostname: netflix
        },
        {
          hostname: amazon
        }
      ]
    end
    subject do
      described_class.call(ip, hostnames_attributes)
    end

    it 'creates dns record' do
      subject
      expect(Dns.last.ip).to eq ip
    end

    it 'creates hostnames record' do
      subject
      expect(Hostname.pluck(:domain)).to eq [netflix,amazon] 
    end

    it 'associates dns to hostnames' do
      subject
      expect(Dns.last.hostnames.pluck(:domain)).to eq [netflix,amazon]  
    end
  end
end
