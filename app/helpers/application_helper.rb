SECONDS_PER_HOUR = 60 * 60
SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR


module ApplicationHelper
  def page_title(sep = ' | ')
    [content_for(:title), 'Sample App'].compact.join(sep)
  end

  def duration_of_time_in_words(total_seconds)
    # make sure we've got an integer
    if total_seconds % 1 == 0
      total_seconds = total_seconds.to_i
    else
      total_seconds = total_seconds.round
    end

    days = total_seconds / SECONDS_PER_DAY
    remaining_seconds = total_seconds % SECONDS_PER_DAY
    hours = remaining_seconds / SECONDS_PER_HOUR
    minutes = (remaining_seconds / 60) % 60
    seconds = remaining_seconds % 60

    parts = []
    parts << "#{'%d' % days} days" if days > 0
    parts << "#{'%d' % hours} hours" if hours > 0
    parts << "#{'%d' % minutes} minutes" if minutes > 0
    parts << "#{'%d' % seconds} seconds" if seconds > 0

    return '0 seconds' if parts.empty?
    parts.join(', ')
  end
end
