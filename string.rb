class String
  # http://www.vitarara.org/cms/hpricot_to_nokogiri_day_1
  alias_method :old_strip, :strip
  def strip
    self.gsub(/^[\302\240|\s]*|[\302\240|\s]*$/, '')
  end

  def istrip
    self.gsub(/\d|\(.*\)/, '').strip
  end

  def replace_br
    self.gsub(/<br(.*)>/, "\n").strip
  end

  def capitalize_words
    self.gsub(/\b\w/){$&.upcase}
  end

  def clean(config = {})
    Sanitize.clean(self, config)
  end
end