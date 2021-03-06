# -*- encoding : utf-8 -*-
module TopicsHelper
  def cover_url(item,size=:normal)
    s=CoverUploader::SIZES[size]
    url = item.try(:cover).try(size).try(:url)
    if url
      return url
    else
      url = "/defaults/cover/#{size}.gif"
    end
  end
  def topic_name_tag(topic, options = {})
    limit = options[:limit] || 10
    prefix = options[:prefix] || ''
    raw "<a href='#{topic_path(topic.name)}' title='#{h(topic.name)}'>#{prefix}#{h(topic.name)}</a>"
  end

  def topic_cover_tag(topic, size, options = {})
    limit = options[:limit] || 10
      url = eval("topic.cover.#{size}.url")
    raw "<a href='#{topic_path(topic.name)}' title='#{h(topic.name)}'>#{image_tag(url, :class => size.to_s+' imgHead', width:options[:size2], height:options[:size2])}</a>"
  end
  
  def topic_avatar(topic_id)
    "#{Setting.upload_url}/topic/cover/#{topic_id}/small38_______.jpg" 
  end
  module_function(*instance_methods)
end
