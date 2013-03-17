require_relative "../testdefs.rb"
require "findit-support/asset/map-marker"

EXAMPLE_MAP_MARKER_URL = "http://google.com/mapfiles/ms/micons/red-dot.png"
EXAMPLE_MAP_SHADOW_URL = "http://google.com/mapfiles/ms/micons/msmarker.shadow.png"

describe FindIt::Asset::MapMarker do  
  
  describe "#new" do    

    shared_examples "valid_map_marker_instance" do |mk, height, width|
      it "is an instance of FindIt::Asset::MapMarker" do
        mk.should be_a_kind_of(FindIt::Asset::MapMarker)
      end      
      it "has marker property that is an instance of FindIt::Asset::Image" do
        mk.marker.should be_a_kind_of(FindIt::Asset::Image)
      end
      it "has a marker property that contains the marker URL" do
        mk.marker.url.should eq(EXAMPLE_MAP_MARKER_URL)
      end
      it "has a marker property with height #{height||'default'}" do
        mk.marker.height.should eq(height||32)
      end
      it "has a marker property with width #{width||'default'}" do
        mk.marker.width.should eq(width||32)
      end            
    end

    shared_examples "valid_map_marker_shadow_property" do |mk, height, width|
      it "has marker property that is an instance of FindIt::Asset::Image" do
        mk.shadow.should be_a_kind_of(FindIt::Asset::Image)
      end
      it "has a shadow property that contains the shadow URL" do
        mk.shadow.url.should eq(EXAMPLE_MAP_SHADOW_URL)
      end
      it "has a shadow property with height #{height||'default'}" do
        mk.shadow.height.should eq(height||32)
      end
      it "has a shadow property with width #{width||'default'}" do
        mk.shadow.width.should eq(width||59)
      end            
    end
    
    context "with no parameters" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL)
      include_examples "valid_map_marker_instance", mk      
      it "has nil shadow property" do
        mk.shadow.should be_nil
      end      
    end
    
    context "with defined marker height and width" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL, :height => 999, :width => 333)
      include_examples "valid_map_marker_instance", mk, 999, 333    
      it "has nil shadow property" do
        mk.shadow.should be_nil
      end
    end
    
    context "with defined shadow" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL, :shadow => EXAMPLE_MAP_SHADOW_URL)
      include_examples "valid_map_marker_instance", mk 
      include_examples "valid_map_marker_shadow_property", mk    
    end
    
    context "with shadow specified as a filename" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL, :shadow => "msmarker.shadow.png")
      it "calculates the full URL of the shadow graphic correctly" do
        mk.shadow.url.should eq(EXAMPLE_MAP_SHADOW_URL)
      end
      include_examples "valid_map_marker_instance", mk 
      include_examples "valid_map_marker_shadow_property", mk   
    end
    
    context "with defined shadow, marker height and width" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL, :height => 999, :width => 333, :shadow => EXAMPLE_MAP_SHADOW_URL)
      include_examples "valid_map_marker_instance", mk, 999, 333  
      it "has correct url for shadow" do
        mk.shadow.url.should eq(EXAMPLE_MAP_SHADOW_URL)
      end  
      it "defaults shadow height to marker height" do
        mk.shadow.height.should eq(999)
      end
      it "uses default shadow width even when marker width is specified" do
        mk.shadow.width.should eq(59)        
      end      
    end
    
    context "with defined shadow height and width" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL, :shadow => EXAMPLE_MAP_SHADOW_URL, :height_shadow => 999, :width_shadow => 333)
      include_examples "valid_map_marker_instance", mk
      it "has correct url for shadow" do
        mk.shadow.url.should eq(EXAMPLE_MAP_SHADOW_URL)
      end
      it "uses specified height for shadow" do
        mk.shadow.height.should eq(999)
      end
      it "uses specified width for shadow" do
        mk.shadow.width.should eq(333)
      end
    end
    
  end # describe "#new"
  
  describe ".to_h" do   
    
    context "with no shadow image" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL)
      it do
        mk.to_h.should eq({
          :marker => {
            :url => EXAMPLE_MAP_MARKER_URL,
            :height => 32,
            :width => 32,
           },
        })
      end      
    end
    
    context "with shadow image defined" do
      mk = FindIt::Asset::MapMarker.new(EXAMPLE_MAP_MARKER_URL, :shadow => EXAMPLE_MAP_SHADOW_URL)
      it do
        mk.to_h.should eq({
          :marker => {
            :url => EXAMPLE_MAP_MARKER_URL,
            :height => 32,
            :width => 32,
           },
          :shadow => {
            :url => EXAMPLE_MAP_SHADOW_URL,
            :height => 32,
            :width => 59,
           },
        })
      end  
    end  
    
  end # describe ".to_h" 
  
end # describe FindIt::Asset::MapMarker 
    
  