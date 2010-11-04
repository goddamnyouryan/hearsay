module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end
  
  def text_field_for(form, field)
  	label = content_tag('label', "#{field.humanize}:", :for => field)
  	form_field = form.text_field field, :size => 22
  	content_tag('div', "#{label} #{form_field}", :class => 'form_row')
  end
  
  def age(birthday)
		(((Date.today  -  birthday.to_date).to_i)/365).round
	end
	
	def voted_on(answer)
  	answer.votes.find_by_user_id(current_user.id)
  end
  
  def ranked_up(image)
  	image.ranks.find_by_user_id(current_user.id)
  end
  
end
