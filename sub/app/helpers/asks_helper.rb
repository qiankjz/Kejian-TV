# coding: utf-8
module AsksHelper
  def topics_name_tag(topics,limit = 20)
    html = []
    return "" if topics.blank?
    if limit > 0
      topics = topics[0,limit]
    end
    for topic in topics
      html << "<a style=\"float:left\" class=\"topic\" href=\"/topics/#{topic}\">#{h(topic)}</a>"
    end
    return raw html.join("")
  end

  def ask_title_tag(ask, options = {})
    class_name = options[:class] || ""
    prefix = ""
    if !ask.to_user.blank?
      prefix = "请问#{ask.to_user.name}："
    end
    raw "<a href=\"/asks/#{ask.id}\" class=\"#{class_name}\">#{h(prefix)}#{h(ask.title)}</a>"
  end
  
  def md_body(str,opts={})
    opts[:with_tfmt] = true if opts[:with_tfmt].nil?
    return "" if str.blank?
    # str = simple_format(str) if str =~ /\n/
    # Rails.logger.info "str: #{str.inspect}"
    str = sanitize(str,:tags => %w(div span strong strong b i em u strike s ol ul li blockquote address br p), :attributes => %w(style))
    str = auto_link(str,:html=>{:target => "_blank", :rel => "nofollow" },:sanitize=>false)
    if opts[:with_tfmt]
	    return raw "<div class=\"tfmt\">#{str}</div>"
	  else
	    return raw str
	  end
  end

  def truncate_lines(body, lines = 4, max_chars = 400)
    return "" if body.blank?
    body_lines = body.split("\n")
    lines = body_lines.count if body_lines.count < lines
    summary = body_lines[0,lines].join("\n")
    summary = inner_truncate_lines(body_lines, lines - 1, summary, max_chars)
    return summary
  end

  # 检测是否 Vote 过 Answer
  def voted?(answer,type = :up)
    return false if current_user.blank?
    if type == :up
      return false if answer.up_voter_ids.blank?
      return answer.up_voter_ids.count(current_user.id) > 0
    else
      return false if answer.down_voter_ids.blank?
      return answer.down_voter_ids.count(current_user.id) > 0
    end
  end

  # 检测是否 Spam 过 Ask 
  def spamed?(ask)
    return false if current_user.blank? or ask.spam_voter_ids.blank?
    return ask.spam_voter_ids.count(current_user.id) > 0
  end

  # 判断是否是 spam 的题
  def spam_ask?(ask)
    point = ask.spams_count || 0
    return point >= Setting.ask_spam_max
  end

  # 判断是否是 spam 的解答
  def spam_answer?(answer)
    point = answer.spams_count || 0
    return point >= Setting.answer_spam_max
  end

  # 判断是否是 spam 过这个解答
  def spam_answered?(answer)
    return false if current_user.blank?
    return false if answer.spam_voter_ids.blank?
    return answer.spam_voter_ids.count(current_user.id) > 0
    return
  end

  def thank_answered?(answer)
    return false if current_user.blank?
    return false if current_user.thanked_answer_ids.blank?
    return current_user.thanked_answer_ids.count(answer.id) > 0
    return
  end

  private
  def inner_truncate_lines(body_lines, lines, summary, max_chars)
    if summary.length > max_chars
      lines -= 1
      if lines > 1
        body_lines = body_lines[0,lines]
        summary = body_lines.join("\n")
        return inner_truncate_lines(body_lines, lines, summary, max_chars)
      else
        summary = body_lines[0][0,max_chars]
        return summary
      end
    else
      return summary
    end
  end

  
end
