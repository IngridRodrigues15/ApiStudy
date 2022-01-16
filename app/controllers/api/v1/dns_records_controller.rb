module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        render :json => DnsPresenter.new(index_params).render
      rescue ActionController::ParameterMissing => e
        render :json => { errors: e }, :status => :unprocessable_entity
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

      def index_params
        params.require(:page)
        params.permit(:excluded, :included)
        params
      end

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
