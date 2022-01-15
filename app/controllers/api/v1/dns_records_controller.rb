module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        # TODO: Implement this action
      end

      # POST /dns_records
      def create
        dns = DnsRecords::Creator.call(dns_ip, hostnames_attributes)
        render :json => dns, :except => [:created_at, :updated_at]
      rescue StandardError => e
        Rails.logger.error("Error on create dns record for ip: #{dns_ip}, hostnames: #{hostnames_attributes} error: #{e}")
        render :json => { errors: e }, :status => :bad_request
      end

      private

      def dns_ip
        dns_records.require(:ip)
      end

      def hostnames_attributes
        dns_records.require(:hostnames_attributes)
      end

      def dns_records
        params.require(:dns_records)
      end
    end
  end
end
