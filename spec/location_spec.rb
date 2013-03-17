require_relative "./testdefs.rb"
require "findit-support/location"

# Austin City Hall
SAMPLE_LAT_DEG = 30.26481
SAMPLE_LNG_DEG = -97.74708
# radians = degrees * PI / 180
SAMPLE_LAT_RAD = SAMPLE_LAT_DEG * (Math::PI / 180.0)
SAMPLE_LNG_RAD = SAMPLE_LNG_DEG * (Math::PI / 180.0)

# The Alamo
SAMPLE2_LAT_DEG = 29.4258
SAMPLE2_LNG_DEG = -98.4862

DELTA_DEGREES = 1E-6
DELTA_RADIANS = 1E-4

  
describe FindIt::Location do
  
  describe "#new" do    
  
    shared_examples "valid_location_instance" do |loc|
      it "is an instance of FindIt::Location" do
        loc.should be_a_kind_of(FindIt::Location)
      end
      it "has valid latitude_deg property" do
        loc.latitude_deg.should be_within(DELTA_DEGREES).of(SAMPLE_LAT_DEG)
      end
      it "has valid longitude_deg property" do
        loc.longitude_deg.should be_within(DELTA_DEGREES).of(SAMPLE_LNG_DEG)
      end
      it "has valid latitude_rad property" do
        loc.latitude_rad.should be_within(DELTA_RADIANS).of(SAMPLE_LAT_RAD)
      end
      it "has valid longitude_rad property" do
        loc.longitude_rad.should be_within(DELTA_RADIANS).of(SAMPLE_LNG_RAD)
      end
    end    
    
    context "with lat/lng specified in degrees" do
      loc = FindIt::Location.new(SAMPLE_LAT_DEG, SAMPLE_LNG_DEG, :DEG)
      include_examples "valid_location_instance", loc
    end
    
    context "with lat/lng specified in radians" do     
      loc = FindIt::Location.new(SAMPLE_LAT_RAD, SAMPLE_LNG_RAD, :RAD)
      include_examples "valid_location_instance", loc 
    end
    
    context "with lat/lng specified with unrecognized units" do
      it "raises an exception" do
        expect do
          FindIt::Location.new(SAMPLE_LAT_DEG, SAMPLE_LNG_DEG, :FAIL)      
        end.to raise_error(RuntimeError)
      end
    end
  
  end  

  describe "#from_geometry" do
    require "findit-support/database"
    db = Sequel.spatialite(EXAMPLE_DATABASE)
    geometry = db.get{MakePoint(SAMPLE_LNG_DEG, SAMPLE_LAT_DEG, 4326)}
    loc = FindIt::Location.from_geometry(db, geometry)
    include_examples "valid_location_instance", loc
  end
  
  describe ".lat" do
    loc = FindIt::Location.new(SAMPLE_LAT_DEG, SAMPLE_LNG_DEG, :DEG)
    include_examples "valid_location_instance", loc
    it "returns latitude in degrees" do
      loc.lat.should be_within(DELTA_DEGREES).of(SAMPLE_LAT_DEG)
    end   
  end
  
  describe ".lng" do
    loc = FindIt::Location.new(SAMPLE_LAT_DEG, SAMPLE_LNG_DEG, :DEG)
    include_examples "valid_location_instance", loc
    it "returns longitude in degrees" do
      loc.lng.should be_within(DELTA_DEGREES).of(SAMPLE_LNG_DEG)
    end    
  end
  
  
  describe ".to_h" do    

    # Pick object constructed in target units, to avoid floating point errors.
    locd = FindIt::Location.new(SAMPLE_LAT_DEG, SAMPLE_LNG_DEG, :DEG)
    locr = FindIt::Location.new(SAMPLE_LAT_RAD, SAMPLE_LNG_RAD, :RAD)
    
    context "coordinate type :DEG" do
      it "returns location in degrees in a hash" do
        locd.to_h(:DEG).should eq({:latitude => SAMPLE_LAT_DEG, :longitude => SAMPLE_LNG_DEG})
      end
    end

    context "no coordinate type specified" do
      it "returns location in degrees in a hash" do
        locd.to_h.should eq({:latitude => SAMPLE_LAT_DEG, :longitude => SAMPLE_LNG_DEG})
      end
    end
    

    context "coordinate type :RAD" do
      it "returns location in radians in a hash" do
        locr.to_h(:RAD).should eq({:latitude => SAMPLE_LAT_RAD, :longitude => SAMPLE_LNG_RAD})
      end
    end
    
    context "bad coordinate type specified" do
      it "raises an exception" do
        expect do
          locd.to_h(:FAIL)
        end.to raise_error(RuntimeError)
      end
    end    
    
  end

  
  describe "distance" do
    
    loc1 = FindIt::Location.new(SAMPLE_LAT_DEG, SAMPLE_LNG_DEG, :DEG)
    
    context "distance between a location and itself" do
      it "is zero" do
        loc1.distance(loc1).should be_within(1E-6).of(0.0)
      end      
    end
    
    loc2 = FindIt::Location.new(SAMPLE2_LAT_DEG, SAMPLE2_LNG_DEG, :DEG)
    
    context "distance between Austin City Hall and the Alamo" do
      it "is correct starting from Austin" do
        loc1.distance(loc2).should be_within(1E-6).of(73.03425265430688)
      end
      it "is correct starting from San Antonio" do
        loc2.distance(loc1).should be_within(1E-6).of(73.03425265430688)
      end
    end

    
  end
  
  
end