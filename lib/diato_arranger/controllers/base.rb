module DiatoArranger
  module Controllers
    class Base
      def call(env)
        request = ::Rack::Request.new(env)
        handle(request)
      rescue NotFound
        respond 404, "Not found"
      end

      def handle(request)
        respond(404, "")
      end

      def respond(code, content, headers = {})
        [
          code,
          {"content-type" => "text/html",
           "content-length" => content.to_s.size.to_s}.merge(headers),
          [content.to_s]
        ]
      end

      def redirect(url)
        respond 302, "", "location" => url
      end

      def success(content)
        respond 200, content
      end
    end
  end
end
