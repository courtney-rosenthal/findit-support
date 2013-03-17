require_relative 'image'

module FindIt
  module Asset  
    
    #
    # A MapMarker is a graphic image (and an optional shadow image to provide 3D effect) to
    # identify a point on a map.
    #
    # A nice index of Google map markers can be viewed here:
    # https://sites.google.com/site/gmapsdevelopment/
    #
    class MapMarker
      
      # Standard height (in pixels) of Google map icon images.
      DEFAULT_MARKER_HEIGHT = 32
      
      # Standard width (in pixels) of Google map icon images.
      DEFAULT_MARKER_WIDTH = 32
      
      # Standard width (in pixels) of Google map icon shadow images.
      DEFAULT_SHADOW_WIDTH = 59
      
      # A FindIt::Asset::Image instance for the map icon graphic.
      attr_reader :marker
      
      # A FindIt::Asset::Image instance for the map icon shadow graphic,
      # or nil if there is no shadow graphic for this marker.
      attr_reader :shadow
    
      #
      # Construct a new FindIt::Asset::MapMarker instance.
      #
      # Parameters:
      # [url]
      #   URL of the marker image.
      # [params]
      #   Parameters for the marker.
      #
      # Returns: A FindIt::Asset::MapMarker instance.
      #
      # Parameters:
      # [:height]
      #   Height of the image in pixels. (default: DEFAULT_MARKER_HEIGHT)
      # [:width]
      #   Width of the image in pixels. (default: DEFAULT_MARKER_WIDTH)
      # [:shadow]
      #   URL of the marker shadow image. Can be specified either as a full
      #   URL, or a path relative to the directory containing the marker image.
      #   (default: marker has no shadow)
      # [:height_shadow]
      #   Height of the marker shadow image in pixels. (default: same height as marker)
      # [:width_shadow]
      #   Width of the marker shadow image in pixels. (default: DEFAULT_SHADOW_WIDTH)
      #
      # Example:
      #
      #   m = FindIt::Asset::MapMarker.new(
      #     "http://maps.google.com/mapfiles/kml/pal2/icon0.png",
      #     :shadow => "icon0s.png")
      #
      # In this example, the URL for the marker shadow image will be:
      #
      #   http://maps.google.com/mapfiles/kml/pal2/icon0s.png"
      #                 
      def initialize(url, params = {})
        height = params[:height] || DEFAULT_MARKER_HEIGHT
        width = params[:width] || DEFAULT_MARKER_WIDTH
        @marker = FindIt::Asset::Image.new(url, :height => height, :width => width)
        
        @shadow = if params[:shadow]
          url_shadow = params[:shadow]
          if url_shadow !~ %r{://} && url_shadow !~ %r{^/}
            url_shadow.insert(0, url.sub(%r{[^/]*$}, ""))
          end
          height_shadow = params[:height_shadow] || height
          width_shadow = params[:width_shadow] || DEFAULT_SHADOW_WIDTH
          FindIt::Asset::Image.new(url_shadow, :height => height_shadow, :width => width_shadow)
        else
          nil
        end
      end
      
      # Example:
      #
      #   m = FindIt::Asset::MapMarker.new(
      #     "http://maps.google.com/mapfiles/kml/pal2/icon0.png",
      #     :shadow => "icon0s.png")
      #   m.to_h
      #
      # Produces:
      #
      #   {
      #     :marker => {
      #       :url => "http://maps.google.com/mapfiles/kml/pal2/icon0.png",
      #       :height => 32, :width => 32},
      #     :shadow => {
      #       :url => "http://maps.google.com/mapfiles/kml/pal2/icon0s.png",
      #       :height => 32, :width => 59}
      #   }
      #
      def to_h
        h = {}
        h[:marker] = @marker.to_h
        h[:shadow] = @shadow.to_h if @shadow
        h.freeze
      end      

    end # class MapMarker
  end # module Asset    
end # module FindIt