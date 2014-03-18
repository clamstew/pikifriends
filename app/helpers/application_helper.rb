# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def nl2br(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end
  
end
