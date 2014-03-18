class PikiEntry < ActiveRecord::Base
  file_column :image,
	  :root_path => File.join(RAILS_ROOT, "public/uploaded"),
	  :web_root => "uploaded/",
	  :magick => {
	    :versions => {
	      :thumb => {:size => '64x64'},
	      :medium => {:size => '320x320'}
      }
    }
end
