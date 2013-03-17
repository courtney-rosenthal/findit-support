module FindIt
  module Asset    
    class Image      
    
    attr_reader :url
    attr_reader :height
    attr_reader :width
    
      #
      # Construct a new FindIt::Asset::Image instance.
      #
      # [url]
      #   The URL of the image file.
      # [params] 
      #   Parameters for the image.
      #
      # Parameters:
      # [:height]
      #   Height of the image in pixels. (required)
      # [:width]
      #   Width of the image in pixels. (required)
      #
      def initialize(url, params = {})
        @url = url
        raise("required parameter \":height\"  missing") unless params.has_key?(:height)
        @height = params.delete(:height).to_i
        raise("required parameter \":width\"  missing") unless params.has_key?(:width)
        @width = params.delete(:width).to_i
        raise("unrecognized parameter(s) specified: \"#{params.keys}\"") unless params.empty?
      end
      
      # Produce a Hash that represents the Image values.
      def to_h
        {
          :url => @url,
          :height => @height,
          :width => @width,
        }.freeze
      end
  
    end # class Image
  end # module Asset    
end # module FindIt