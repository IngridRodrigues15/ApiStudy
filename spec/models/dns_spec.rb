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
end
