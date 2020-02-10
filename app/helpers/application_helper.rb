module ApplicationHelper
  def full_title page_title = ""
    if page_title.empty?
      t ".title_header"
    else
      page_title + " | " + t(".title_header")
    end
  end
end
