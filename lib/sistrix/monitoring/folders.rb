module Sistrix

  require 'sistrix/base'
  class Monitoring
    class Folders

      include ::Sistrix::Base

      attr_reader :credits, :folders

      def initialize(options = {})
        @options = {
          'project' => nil,
          'api_key' => Sistrix.config.api_key,
        }.merge(options)

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def call(options = {})
        data = fetch(options)

        @credits = data.xpath('/response/credits').first['used'].to_i

        @folders = []
        data.xpath('/response/answer/folder').each do |r|
          @folders << Record.new(r)
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
          @data[:parent] = xml_node['parent'].to_s.strip
        end
      end


    end

  end
end

