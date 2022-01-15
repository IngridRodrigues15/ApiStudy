class Hostname < ApplicationRecord
  has_many :dns_hosts
  has_many :dns, through: :dns_hosts
end
