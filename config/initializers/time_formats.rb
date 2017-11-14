Time::DATE_FORMATS[:long_ordinal] = ->(time) {
  day_format = ActiveSupport::Inflector.ordinalize(time.day)
  time.strftime("%B #{day_format}, %Y at %-I:%M %p")
}
