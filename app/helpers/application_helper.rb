module ApplicationHelper
  def page_title(sep = ' | ')
    [content_for(:title), 'Sample App'].compact.join(sep)
  end
end
