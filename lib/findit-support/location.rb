module FindIt
  
  #
  # A geographic location, identified by a latitude and longitude.
  #
  class Location
    
    attr_reader :latitude_deg, :longitude_deg, :latitude_rad, :longitude_rad
    
    # Constant to convert from degrees to radians.
    DEG_TO_RAD = Math::PI / 180.0
    
    # Construct a new FindIt::Location instance for a given location.
    #
    # [lat]
    #   The latitude value, as a Float.
    # [lng]
    #   The longitude value, as a Float.
    # [type]
    #   Either </tt>:DEG<tt> or <tt>:RAD</tt>.
    #
    # Returns a FindIt::Location instance.
    #
    # Latitude/longitude can be specified as either degrees or radians,
    # as indicated by the <i>type</i> argument.
    #
    def initialize(lat, lng, type)
      case type
      when :DEG
        @latitude_deg = lat
        @longitude_deg = lng
        @latitude_rad = lat * DEG_TO_RAD
        @longitude_rad =  lng * DEG_TO_RAD
      when :RAD
        @latitude_rad = lat
        @longitude_rad = lng
        @latitude_deg = lat / DEG_TO_RAD
        @longitude_deg = lng / DEG_TO_RAD
      else
        raise "unknown coordinate type \"#{type}\""
      end      
    end
    
    # Construct a new FindIt::Location instance from a Spatialite geometry blob.
    #
    # [db]
    #   A Sequel handle to a Spatialite database.
    # [geometry]
    #   A Spatialite geometry blob.
    #
    # No data are read or written to the database. The database
    # handle is needed because we use Spatialite libraries to
    # process the geometry information.
    #
    def self.from_geometry(db, geometry)
      lng = db.get{X(ST_Transform(geometry.to_sequel_blob, 4326))}
      lat = db.get{Y(ST_Transform(geometry.to_sequel_blob, 4326))}
      self.new(lat, lng, :DEG)
    end
    
    # Short for <i>latitude_deg</i>.
    def lat
      @latitude_deg
    end

    # Short for <i>longitude_deg</i>.
    def lng
      @longitude_deg
    end
    
    def to_h(type = :DEG)
      case type
      when :DEG
        {:latitude => @latitude_deg, :longitude => @longitude_deg}
      when :RAD
        {:latitude => @latitude_rad, :longitude => @longitude_rad}
      else
        raise "unknown coordinate type \"#{type}\""
      end
    end
  
    # Earth mean radius, in miles.
    EARTH_R = 3963.0 
    
    #
    # Calculate distance from current location to another location.
    #
    # [loc]
    #   A FindIt::Location instance, to measure the distance to.
    #
    # Returns the calculated distance, in miles.
    #
    # Based on equitorial approximation formula at:
    # http://www.movable-type.co.uk/scripts/latlong.html  
    #
    def distance(loc)
      x = (loc.longitude_rad-self.longitude_rad) * Math.cos((self.latitude_rad+loc.latitude_rad)/2);
      y = (loc.latitude_rad-self.latitude_rad);
      Math.sqrt(x*x + y*y) * EARTH_R;
    end  
    
  end # class Location
end # module FindIt
