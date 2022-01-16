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
end
