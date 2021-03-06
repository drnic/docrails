require 'abstract_unit'

module ActionDispatch
  module Routing
    class MapperTest < ActiveSupport::TestCase
      class FakeSet
        attr_reader :routes

        def initialize
          @routes = []
        end

        def resources_path_names
          {}
        end

        def request_class
          ActionDispatch::Request
        end

        def add_route(*args)
          routes << args
        end

        def conditions
          routes.map { |x| x[1] }
        end
      end

      def test_initialize
        Mapper.new FakeSet.new
      end

      def test_map_slash
        fakeset = FakeSet.new
        mapper = Mapper.new fakeset
        mapper.match '/', :to => 'posts#index', :as => :main
        assert_equal '/', fakeset.conditions.first[:path_info]
      end

      def test_map_more_slashes
        fakeset = FakeSet.new
        mapper = Mapper.new fakeset

        # FIXME: is this a desired behavior?
        mapper.match '/one/two/', :to => 'posts#index', :as => :main
        assert_equal '/one/two(.:format)', fakeset.conditions.first[:path_info]
      end
    end
  end
end
