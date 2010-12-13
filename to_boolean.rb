module BooleanExtension
  def to_boolean
    [true, 'true', 1, '1'].include?(self.class == String ? self.downcase : self)
  end
end
Integer.send :include, BooleanExtension
 String.send :include, BooleanExtension