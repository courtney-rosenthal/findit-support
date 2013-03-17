require "sequel"

module Sequel
  
  # Default spatialite extension library module load file.
  SPATIALITE_EXTENSION_LIBRARY = "libspatialite.so.3"
  
  # Connect to a Spatialite database.
  #
  # Arguments are the same as to Sequel::sqlite
  #
  # Returns a Sequel::SQLite::Database instance, with the Spatialite
  # extensions loaded.
  #
  # Additional options:
  #
  # [:spatialite]
  #   Module to load for spatialiate extensions,
  #   instead of default.
  #
  # Example:
  #
  #   db = Sequel.spatialite("example.db", :spatialite => "/usr/local/lib/libspatialite.so.3")
  #
  def self.spatialite(database, opts = {})
    opts[:after_connect]||= proc {|db| db.enable_load_extension(true)}
    db = Sequel.sqlite(database, opts)
    
    db.get{load_extension(opts[:spatialite] || SPATIALITE_EXTENSION_LIBRARY)}

    def db.spatialite_version
      self.get{spatialite_version{}}
    end
    
    # This will raise an error if SpatiaLite not loaded correctly.
    db.spatialite_version
    
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
