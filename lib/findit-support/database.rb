require "sequel"

# The SRID typically used in spatialite to represent latitude/longitude coordinates.
SRID_LATLNG = 4326

module Sequel
  
  # Connect to a Spatialite database.
  #
  # Arguments are the same as to Sequel::sqlite
  #
  # Returns a Sequel::SQLite::Database instance, with the Spatialite
  # extensions loaded.
  #
  # Additional options:
  # [:spatialite]
  #   Module to load for spatialiate extensions.
  #
  # The Spatialite module (shared library file) is determined, in order:
  # * The value specified for the :spatialite option, if any.
  # * The value specified by the SPATIALITE environment setting, if any.
  # * libspatialite.so
  #
  # Example:
  #
  #   db = Sequel.spatialite("example.db", :spatialite => "libspatialite.so.3")
  #
  def self.spatialite(database, opts = {})
    opts[:after_connect]||= proc {|db| db.enable_load_extension(true)}
    db = Sequel.sqlite(database, opts)
    
    db.get{load_extension(opts[:spatialite] || ENV["SPATIALITE"] || "libspatialite.so")}

    def db.spatialite_version
      self.get{spatialite_version{}}
    end
    
    # This will raise an error if SpatiaLite not loaded correctly.
    db.spatialite_version

    # Return a hash of geometry information for the specified table.
    # Returns nil if table has no geometry information.
    # Assumes the table has at most one geometry columns.
    #
    def db.geo_info(table)
      @geo_info_data ||= {}
      t = table.to_s
      unless @geo_info_data.has_key?(t)
        rs = self[:geometry_columns].filter(:f_table_name => t)
        @geo_info_data[t] = (rs.count == 1 ? rs.first : nil)
      end
      return @geo_info_data[t]
    end

    # Returns the name of the geometry column (as symbol) for this table.
    # Returns nil if table has no geometry information.
    #
    def db.geo_column(table)
      (info = geo_info(table)) && (val = info[:f_geometry_column]) && val.to_sym
    end

    # Returns the geospatial coordinate system (SRID) (as int) for this table.
    # Returns nil if table has no geometry information.
    #
    def db.geo_srid(table)
      (info = geo_info(table)) && (val = info[:srid]) && val.to_i
    end

    db        
  end
  
  
  class Dataset
    
    # Fetch record from a dataset that has at most one result.
    #
    # Returns nil if the dataset is empty.
    #
    # Raises a Sequel::Error if the dataset has more than one row.
    #
    def fetch_one
      results = self.limit(2).all
      case results.length
      when 0
        nil
      when 1
        results[0]
      else
        raise Sequel::Error, "query returned too many rows (#{self})"
      end
    end
    
  end # class Dataset  
  
end # moduel Sequel
