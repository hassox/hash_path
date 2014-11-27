require 'spec_helper'

RSpec.describe HashPath do
  describe '#at_path' do
    it 'returns nil if the key is not found' do
      expect({}.at_path('foo')).to eq(nil)
    end

    it 'returns a value if it is found' do
      expect({foo: {bar: 5}}.at_path('foo.bar')).to eq(5)
    end
  end

  describe '#at_path!' do
    it 'looks up a key given by a string' do
      expect({'foo' => 5}.at_path!('foo')).to eq(5)
    end

    it 'finds a symbol when searching by a string' do
      expect({foo: 5}.at_path!('foo')).to eq(5)
    end

    it 'looks up a key given by a symbol' do
      expect({foo: 5}.at_path!(:foo)).to eq(5)
    end

    it 'looks up a symbol key given by an array' do
      expect({foo: 5}.at_path!(['foo'])).to eq(5)
    end

    it 'looks up a string key given by an array' do
      expect({'foo' => 5}.at_path!(['foo'])).to eq(5)
    end

    it 'looks up an object key' do
      expect({73 => 5}.at_path!([73])).to eq(5)
    end

    it 'looks up a second level value' do
      expect({foo: {bar: 5}}.at_path!(['foo', :bar])).to eq(5)
    end

    it 'raises a nice error when top-level key not found' do
      expect {
        {}.at_path!(['foo', 'bar'])
      }.to raise_error(HashPath::PathNotFound, 'foo')
    end

    it 'raises a nice error when second-level key not found' do
      expect {
        {foo: {}}.at_path!(['foo', 'bar'])
      }.to raise_error(HashPath::PathNotFound, 'foo.bar')
    end

    context 'a few more cases' do
      let(:hash) { { 'foo' => {'bar' => {'baz' => 'hai'} }, "baz" => [11,22] } }

      it 'throws an exception with middle key missing' do
        expect { hash.at_path!('foo.not.baz') }.to raise_error(HashPath::PathNotFound, 'foo.not')
      end

      it 'throws an exception with first key missing' do
        expect { hash.at_path!('not.here.yo') }.to raise_error(HashPath::PathNotFound, 'not')
      end

      it 'throws an exception with third key missing' do
        expect { hash.at_path!('foo.bar.not') }.to raise_error(HashPath::PathNotFound, 'foo.bar.not')
      end

      it 'can traverse an array with a zero-based integer' do
        expect(hash.at_path!('baz.1')).to eq(22)
      end
    end
  end

  describe '#flatten_key_paths' do
    it 'un-nests hashes' do
      expect({a: 5, b: {c: 7}}.flatten_key_paths).to eq({'a' => 5, 'b.c' => 7})
    end
  end

  describe 'HashPath::VERSION' do
    it 'is set' do
      expect(HashPath::VERSION).not_to eq(nil)
    end
  end
end
