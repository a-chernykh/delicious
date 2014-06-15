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

          # @!method limit(count)
          #   Sets the limit
          #
          #   @param count [Integer] How many bookmarks server should return at most
          #   @return [Criteria]
          param limit: :results
          # @!method offset(count)
          #   Sets the offset
          #
          #   @param count [Integer] How many bookmarks server should skip
          #   @return [Criteria]
          param offset: :start
          # @!method tag(name)
          #   Sets tag-based filtering
          #
          #   @param name [String] Name of the tag
          #   @return [Criteria]
          param :tag

          def initialize(&block)
            @fetch = block
          end

          # Sets starting date and time for which you want to get bookmarks
          #
          # @!macro [new] time_criteria
          #   @param date [String,Time,DateTime] `String` time represenation or any object which responds to `strftime`
          #   @return [Criteria]
          def from(date)
            params[:fromdt] = format_time(date)
            self
          end

          # Sets ending date and time for which you want to get bookmarks
          #
          # @!macro time_criteria
          def to(date)
            params[:todt] = format_time(date)
            self
          end

          # Fetches bookmarks from server filtering by current criteria
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

        # Returns all bookmarks associated with given access token. Results can be paginated:
        #
        # ```ruby
        # client.all.offset(150).limit(50).to_a
        # ```
        #
        # And filtered by date and tag:
        #
        # ```ruby
        # client.all.tag('angular').from('2013/11/12 10:23:00').to('2013/11/13 12:10:00')
        # ```
        #
        # @see Criteria
        # @return [Criteria]
        def all
          Criteria.new do |criteria|
            response = @client.connection.get '/v1/posts/all', criteria.params.merge(tag_separator: 'comma')
            posts = response.body['posts'] ? response.body['posts']['post'] : []
            posts.map do |post_attrs|
              Delicious::Post.build_persisted @client,
                url:         post_attrs['href'],
                description: post_attrs['description'],
                extended:    post_attrs['extended'],
                tags:        post_attrs['tag'],
                dt:          post_attrs['dt'],
                shared:      post_attrs['shared']
            end
          end
        end
      end

    end
  end
end
