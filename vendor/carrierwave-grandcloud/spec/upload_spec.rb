require File.dirname(__FILE__) + '/spec_helper'

require "open-uri"
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

describe "Upload" do
  def setup_db
    ActiveRecord::Schema.define(:version => 1) do
      create_table :photos do |t|
        t.column :image, :string
      end
    end
  end

  def drop_db
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end

  class PhotoUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    def grandcloud_bucket
      "carrierwave"
    end

    version :small do
      process :resize_to_fill => [120, 120]
    end

    def store_dir
      "photos"
    end
  end

  class Photo < ActiveRecord::Base
    mount_uploader :image, PhotoUploader
  end


  before :all do
    setup_db
  end

  after :all do
    drop_db
  end

  describe "Upload Image" do
    context "should upload image" do
      before(:all) do
        @file = load_file("foo.jpg")
        @file1 = load_file("foo.gif")
        @photo = Photo.new(:image => @file)
        @photo1 = Photo.new(:image => @file1)
      end

      it "should upload file" do
        @photo.save.should be_true
        @photo1.save.should be_true
      end

      it "should get uploaded file" do
        img = open(@photo.image.url)
        img.size.should == @file.size
        img1 = open(@photo1.image.url)
        img1.size.should == @file1.size
      end

      it "sholud get small version uploaded file" do
        open(@photo.image.small.url).should_not == nil
        open(@photo1.image.small.url).should_not == nil
      end
    end
  end
end