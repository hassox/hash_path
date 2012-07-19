require "hash_path/version"
module HashPath
  class PathNotFound < StandardError; end

  DELIMITER = '.'

  # Looks up the path provided
  # @param path String the path to lookup
  # @example
  #   my_hash.at_path("foo.bar.baz") # looks in my_hash['foo']['bar']['baz']
  def at_path(path)
    path_keys = normalize_path(path)
    current_value = self

    path_keys.each do |key|
      return nil unless ::Hash === current_value
      current_value = current_value[key]
    end
    current_value
  end

  # Same as at_path but raises when a path is not found
  # The raise will give a delimited path of where the path went dead
  # @example
  #   f = { 'foo' => {'bar' => {'baz' => 'hai'} } }
  #   f.at_path!('foo.not.baz') # Raises, message == 'foo.not'
  #   f.at_path!('not.here.yo') # Raises, message == 'not'
  #   f.at_path!('foo.bar.not') # Raises, message == 'foo.bar.not'
  # @see HashPath#at_path
  def at_path!(path)
    path_keys = normalize_path(path)
    the_keys, current_value = [], self

    path_keys.each do |key|
      raise(PathNotFound, the_keys.join(DELIMITER))unless ::Hash === current_value
      the_keys << key
      current_value = current_value[key]
    end
    current_value
  end

  private
  def normalize_path(path)
    case path
    when Array
      path
    when String, Symbol
      path.to_s.split(DELIMITER)
    end
  end
end

class Hash
  include HashPath
end
