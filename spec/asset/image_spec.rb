require_relative "../testdefs.rb"
require "findit-support/asset/image"

EXAMPLE_IMAGE_URL = "http://example.com/dir/marker.png"
EXAMPLE_IMAGE_HEIGHT = 99
EXAMPLE_IMAGE_WIDTH = 33

describe FindIt::Asset::Image do  
  
  describe "#new" do       

    shared_examples "valid_image_instance" do |img|
      it "is an instance of FindIt::Asset::Image" do
        img.should be_a_kind_of(FindIt::Asset::Image)
      end
      it "has valid url property" do
        img.url.should eq(EXAMPLE_IMAGE_URL)
      end
      it "has valid height property" do
        img.height.should eq(EXAMPLE_IMAGE_HEIGHT)
      end
      it "has valid width property" do
        img.width.should eq(EXAMPLE_IMAGE_WIDTH)
      end
    end

    context "with lat/lng specified in degrees" do
      img = FindIt::Asset::Image.new(EXAMPLE_IMAGE_URL,
        :height => EXAMPLE_IMAGE_HEIGHT,
        :width => EXAMPLE_IMAGE_WIDTH)     
      include_examples "valid_image_instance", img
    end
    
    context "missing height property" do
      it "raises an exception" do
        expect do
          FindIt::Asset::Image.new(EXAMPLE_IMAGE_URL,  :width => EXAMPLE_IMAGE_WIDTH)     
        end.to raise_error(RuntimeError)
      end
    end
    
    context "missing width property" do
      it "raises an exception" do
        expect do
          FindIt::Asset::Image.new(EXAMPLE_IMAGE_URL,  :height => EXAMPLE_IMAGE_HEIGHT)     
        end.to raise_error(RuntimeError)
      end
    end
    
    context "unrecognized property" do
      it "raises an exception" do
        expect do    
          FindIt::Asset::Image.new(EXAMPLE_IMAGE_URL,
            :height => EXAMPLE_IMAGE_HEIGHT,
            :width => EXAMPLE_IMAGE_WIDTH,
            :bogus => true)        
        end.to raise_error(RuntimeError)
      end
      
    end
    
  end
  

  describe ".to_h" do
    img = FindIt::Asset::Image.new(EXAMPLE_IMAGE_URL,
      :height => EXAMPLE_IMAGE_HEIGHT,
      :width => EXAMPLE_IMAGE_WIDTH)
    it do
      img.to_h.should eq({
        :url => EXAMPLE_IMAGE_URL,
        :height => EXAMPLE_IMAGE_HEIGHT,
        :width => EXAMPLE_IMAGE_WIDTH
      })
    end
  end
    
end