module PostsHelper
  def post_length_in_minutes(body)
    min = body.split(" ").size / 250
    if min == 0
      t('application.length.less_than_one_minute')
    else
      t('application.length.minutes_read', read_time: min)
    end
  end

  # blacklisting
  def remove_javascript(html)
    html.gsub(/<script.*?>/i, "")
        .gsub(/<\/script>/i, "")
        .gsub(/javascript:/i, "")
        .gsub(/on[\w]+=/i, "")
  end

  # whitelisting
  # TODO: this won't work for embedded video
  def sanitize_html(html)
    sanitize(html, tags: %w(p b i u blockquote br h2 h3 div a img figure figcaption iframe html),
             attributes: %w(class href style))
  end
end
