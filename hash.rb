class Hash
  def recursive_symbolize_keys!
    symbolize_keys!
    # symbolize each hash in .values
    values.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    # symbolize each hash inside an array in .values
    values.select{|v| v.is_a?(Array) }.flatten.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    self
  end

  # {:requirements=>{:drivers_license=>"types"}}.symbolize_values #=> {:requirements=>{:drivers_license=>:types}}
  def symbolize_values
    inject({}) do |options, (key, value)|
       options[key] = value.is_a?(Hash) ? value.symbolize_values : value.to_sym
       options
     end
  end

  def deep_merge!(second)
    # From: http://www.ruby-forum.com/topic/142809
    # Author: Stefan Rusterholz
    merger = proc {|key,v1,v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge!(second, &merger)
  end
  
  # {:a => 1, :b => {:c => 2, :f => 3, :d => 4}}.include?({:b => {:c => 2, :f => 3}}) #=> true
  def deep_include?(sub_hash)
    sub_hash.keys.all? do |key|
      self.has_key?(key) && if sub_hash[key].is_a?(Hash)
        self[key].is_a?(Hash) && self[key].deep_include?(sub_hash[key])
      else
        self[key] == sub_hash[key]
      end
    end
  end

  def nested_hash(array)
    node = self
    array.each do |i|
      node[i]=Hash.new if node[i].nil?
      node = node[i]
    end
    self
  end

  def merge_nested_hash!(nested_hash)
    deep_merge!(nested_hash)
  end

#  {:a => {:b => 1}}.deep_value_valid?(:a, Hash) #=> true
#  {:a => {:b => 1, :c => 2}}.deep_value_valid?({:a => {:b => 1}}, Integer, :in => (1..15).to_a) #=> true
  def deep_value_valid?(object_or_hash, class_name, options={})
    return self.is_a?(class_name) unless object_or_hash.is_a?(Hash)

    return false unless self.has_key?(object_or_hash.keys[0])
    return self[object_or_hash.keys[0]].deep_value_valid?(object_or_hash.values[0], class_name, options) if object_or_hash.values[0].is_a?(Hash)

    return options[:in].include?(object_or_hash.values[0]) if options[:in]
    return object_or_hash.values[0] =~ options[:format]    if options[:format]

    self[object_or_hash.keys[0]].is_a?(class_name)
  end

  def to_params
    params = ''
    stack = []

    each do |k, v|
      if v.is_a?(Hash)
        stack << [k,v]
      else
        params << "#{k}=#{v}&"
      end
    end

    stack.each do |parent, hash|
      hash.each do |k, v|
        if v.is_a?(Hash)
          stack << ["#{parent}[#{k}]", v]
        else
          params << "#{parent}[#{k}]=#{v}&"
        end
      end
    end

    params.chop! # trailing &
    params
  end

  # Returns a new hash containing only the keys specified
  # that exist in the current hash.
  #
  #  {:a => '1', :b => '2', :c => '3'}.only(:a, :c)
  #  # => {:a => '1', :c => '3'}
  #
  # Keys that do not exist in the original hash are ignored.
  def only(*keys)
    inject( {} ) do |new_hash, (key, value)|
      new_hash[key] = value if keys.include?(key)
      new_hash
    end
  end
end