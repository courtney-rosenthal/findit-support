require_relative "./testdefs.rb"
require "findit-support/database"

describe Sequel do  
  
  shared_examples "opens_sqlite_database" do |db|
    it "opens an SQLite database" do
      db.should be_a_kind_of(Sequel::Database)
      db.tables.should include(EXAMPLE_TABLE)
    end
  end

  shared_examples "opens_spatialite_database" do |db|
    include_examples "opens_sqlite_database", db
    it "includes spatialite extensions" do
      db.get{spatialite_version{}}.should match(/^[34]\./)
    end
  end
  
  
  describe ".sqlite" do
    db = Sequel.sqlite(EXAMPLE_DATABASE)
    include_examples "opens_sqlite_database", db
  end

  
  describe ".spatialite" do
    
    context "with default arguments" do
      db = Sequel.spatialite(EXAMPLE_DATABASE)
      include_examples "opens_spatialite_database", db
    end
    
    context "with spatialite library argument" do
      db = Sequel.spatialite(EXAMPLE_DATABASE, :spatialite => "libspatialite.so")
      include_examples "opens_spatialite_database", db
    end
    
    context "with bad spatialite library argument" do
      it "raises an exception" do
        expect do
          Sequel.spatialite(EXAMPLE_DATABASE, :spatialite => "library_not_found.so")
        end.to raise_error(Sequel::DatabaseError)
      end
    end
    
  end
  
  
  describe "#spatialite_version" do    
    db = Sequel.spatialite(EXAMPLE_DATABASE)
    subject { db.spatialite_version }
    it "is a module version string" do
      should be_a_kind_of(String)
      should match(/^[0-9]/)
    end
    it "returns spatialite_version() value" do
      should eq(db.get{spatialite_version{}})
    end
  end

  describe "#geo_info" do
    db = Sequel.spatialite(EXAMPLE_DATABASE)

    context "when table has one geometry column" do
      subject { db.geo_info(EXAMPLE_TABLE) }
      it "should retrieve geospatial info for table" do
        should be_a_kind_of(Hash)
      end
    end

    context "when invalid table specified" do
      subject { db.geo_info(:no_such_table) }
      it "should be nil" do
        should be_nil
      end
    end

  end

  describe "#geo_column" do
    db = Sequel.spatialite(EXAMPLE_DATABASE)
    subject { db.geo_column(EXAMPLE_TABLE) }
    it "should return geometry column name for table" do
      should eq(:Geometry)
    end
  end

  describe "#geo_srid" do
    db = Sequel.spatialite(EXAMPLE_DATABASE)
    subject { db.geo_srid(EXAMPLE_TABLE) }
    it "should return SRID value for table" do
      should eq(3333)
    end
  end
    
  
end
    
  
describe Sequel::Dataset do
  
  describe ".fetch_one" do        

    db = Sequel.spatialite(EXAMPLE_DATABASE)
    
    context "with dataset of one row" do
      ds = db[EXAMPLE_TABLE].filter(EXAMPLE_COL => EXAMPLE_COL_VALUE_EXISTS)
      it "returns one row" do
        ds.fetch_one[EXAMPLE_COL].should equal(EXAMPLE_COL_VALUE_EXISTS)
      end
    end
    
    context "with dataset of no rows" do
      ds = db[EXAMPLE_TABLE].filter(EXAMPLE_COL => EXAMPLE_COL_VALUE_NOT_EXISTS)
      it "returns nil" do
        ds.fetch_one.should be_nil
      end
    end
    
    context "with dataset of many rows" do
      ds = db[EXAMPLE_TABLE]
      it "raises an exception" do
        expect { ds.fetch_one }.to raise_error(Sequel::Error)
      end
    end
    
  end
  
end
