class SearchController < ApplicationController
  
  def names
    if params[:keywords]
      search_word = '%'+params[:keywords]+'%'
      @searchedUsers = User.find :all, :conditions => ["firstname LIKE ? OR lastname LIKE ?", search_word, search_word], :order => 'firstname, lastname'
    else
      @searchedUsers = []
    end
  end
  
  def countries
    @all_countries = Country.find :all
    @countries = []
    
    for country in @all_countries
      if country.schools.size > 0
        @countries.push country
      end
    end
    
  end
  
end
