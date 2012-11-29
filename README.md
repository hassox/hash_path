# HashPath

Provides a simple interface to access hash paths.

The gem was written to help with specs, so use in production code will have an
unknown performance hit.

## Installation

Add this line to your application's Gemfile:

    gem 'hash_path'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_path

## Usage

Given the hash
    {
      'foo' => {
        'bar' => {
          'baz' => 'hai'
        }
      }
    }

    # Nil versions
    my_hash.at_path("foo.bar.baz")   #=> 'hai'
    my_hash.at_path("foo.bar.barry") #=> nil
    my_hash.at_path("not_a_key")     #=> nil

    # Or the raise version
    my_hash.at_path!("foo.bar.baz")   #=> 'hai'
    my_hash.at_path!("foo.bar.barry") #=> raises
    my_hash.at_path!("not_a_key")     #=> raises


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
