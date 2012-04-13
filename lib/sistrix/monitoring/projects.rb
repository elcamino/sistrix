module Sistrix

  require 'sistrix/base'
  class Monitoring
    class Projects

      include ::Sistrix::Base

      attr_reader :credits, :projects

      def initialize(options = {})
        @options = {
          'api_key' => Sistrix.config.api_key,
        }

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def call(options = {})
        data = fetch(options)

        @credits = data.xpath('/response/credits').first['used'].to_i

        @projects = []
        data.xpath('/response/answer/project').each do |r|
          @projects << Record.new(r)
        end

        self
      end

      class Record
        require 'sistrix/record'
        include ::Sistrix::Record

        def initialize(xml_node)
          @data = {}

          @data[:name] = xml_node['name'].to_s.strip
          @data[:id] = xml_node['id'].to_s.strip
        end
      end


    end

  end
end

