require 'active_support/concern'

module Delicious
  module Bookmarks
    module Methods

      module All
        extend ActiveSupport::Concern

        class Criteria
          include Enumerable

          def self.param(param)
            method, query_param = param.is_a?(Hash) ? param.first : [param, param]
            define_method method do |value|
              params[query_param] = value
              self
            end
          end

          param limit: :results
          param offset: :start
          param :tag

          def initialize(&block)
            @fetch = block
          end

          def from(from)
            params[:fromdt] = format_time(from)
            self
          end

          def to(to)
            params[:todt] = format_time(to)
            self
          end

          def each(&block)
            @fetch.call(self).each(&block)
          end

          def params
            @params ||= {}
          end

          private

          def format_time(time)
            time = Time.parse(time) if time.respond_to?(:to_str)
            time.strftime "%FT%TZ"
          end
        end

        def all
          Criteria.new do |criteria|
            response = @client.connection.get '/v1/posts/all', criteria.params.merge(tag_separator: 'comma')
            response.body['posts']['post'].map do |post_attrs|
              Delicious::Post.build_persisted @client,
                url:         post_attrs['href'],
                description: post_attrs['description'],
                extended:    post_attrs['extended'],
                tags:        post_attrs['tags'],
                dt:          post_attrs['dt'],
                shared:      post_attrs['shared']
            end
          end
        end
      end

    end
  end
end
