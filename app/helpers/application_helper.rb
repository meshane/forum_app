module ApplicationHelper
  
  #Return a title on a per-page basis
  def title
    base_title = "Forum Lab"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("ForumLab.png", :class => "round", :alt => "ForumLab")
  end
  
end
