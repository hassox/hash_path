require "hash_path/version"
module HashPath
  class PathNotFound < StandardError; end

  module NilPath
    def at_path(path)
      nil
    end

    def at_path!(path)
      raise PathNotFound, path
    end

    def flatten_key_paths(*)
      {}
    end
  end



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
  #   f = { 'foo' => {'bar' => {'baz' => 'hai'} }, "baz" => [1,2] }
  #   f.at_path!('foo.not.baz') # Raises, message == 'foo.not'
  #   f.at_path!('not.here.yo') # Raises, message == 'not'
  #   f.at_path!('foo.bar.not') # Raises, message == 'foo.bar.not'
  #   f.at_path!("baz.1") # => 2
  # @see HashPath#at_path
  def at_path!(path)
    the_keys = []

    normalize_path(path).reduce(self) do |memo, key|
      the_keys << key
      case key
      when String
        memo.key?(key) ? memo.fetch(key) : memo.fetch(key.to_sym)
      else
        memo.fetch(key)
      end
    end

  rescue => e
    raise(PathNotFound, the_keys.join(DELIMITER))
  end

  # Provides flattened hash key paths
  def flatten_key_paths(hash_or_obj=self, prefix=nil)
    case hash_or_obj
    when Hash
      hash_or_obj.inject({}) do |h, (k,v)|
        full_prefix = [prefix, k].compact.join(DELIMITER)
        result = flatten_key_paths(v, full_prefix)
        case result
        when Hash
          h.merge!(result)
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
    end.map{|key| key =~ /\A\d+\z/ ? key.to_i : key }
  end
end


class Hash
  include HashPath
end

class NilClass
  include HashPath::NilPath
end
