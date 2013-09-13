require "hash_path/version"
module HashPath
  class PathNotFound < StandardError; end

  DELIMITER = '.'

  # Looks up the path provided
  # @param path String the path to lookup
  # @example
  #   my_hash.at_path("foo.bar.baz") # looks in my_hash['foo']['bar']['baz']
  def at_path(path)
    at_path!(path) rescue nil
  end

  # Same as at_path but raises when a path is not found
  # The raise will give a delimited path of where the path went dead
  # @example
  #   f = { 'foo' => {'bar' => {'baz' => 'hai'}, "baz" => [1,2] } }
  #   f.at_path!('foo.not.baz') # Raises, message == 'foo.not'
  #   f.at_path!('not.here.yo') # Raises, message == 'not'
  #   f.at_path!('foo.bar.not') # Raises, message == 'foo.bar.not'
  #   f.at_path!("baz.1") # => 2
  # @see HashPath#at_path
  def at_path!(path)
    path_keys = normalize_path(path)
    the_keys, current_value = [], self

    path_keys.each do |key|
      raise(PathNotFound, the_keys.join(DELIMITER)) unless current_value.respond_to?(:[])
      the_keys << key
      current_value = current_value[key]
    end
    current_value
  end

  # Provides flattened hash key paths
  def flatten_key_paths(hash_or_obj=self, prefix=nil)
    case hash_or_obj
    when Hash
      hash_or_obj.inject({}) do |h, (k,v)|
        full_prefix = [prefix, k].compact.join(".")
        result = flatten_key_paths(v, full_prefix)
        if Hash === result
          h.merge! result
        else
          h[full_prefix] = result
        end
        h
      end
    else
      hash_or_obj
    end
  end

  private
  def normalize_path(path)
    case path
    when Array
      path
    when String, Symbol
      path.to_s.split(DELIMITER)
    end.map{|key| key =~ /^\d+$/ ? key.to_i : key }
  end
end

class Hash
  include HashPath
end
