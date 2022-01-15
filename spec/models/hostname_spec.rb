require 'rails_helper'

RSpec.describe Hostname, type: :model do
  describe 'validations' do
    subject { described_class.new }

    context 'domain' do
      it 'validates presence' do
        subject.save 
        expect(subject.errors.full_messages).to include("Domain can't be blank")
      end

      it 'validates uniqueness' do
        domain1 = Hostname.create(domain: 'netflix.com')
        domain2 = Hostname.create(domain: 'netflix.com')
  
        expect(domain2.errors.full_messages).to include("Domain has already been taken")
      end
    end
  end
end
