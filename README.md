# versioned_blocks

Are you working with versioned APIs? Loop through them easily like this:

	versioned_block(from: 1, to: 3) {|v| puts "version #{v}"}

	VersionedBlocks.base_uri = 'http://www.api.com/'

	versioned_block(from: 2, to: 4) do |v, uri|
		puts "For version #{v}, the URI is #{uri}"
	end

The last example would pass 'http://www.api.com/v2' through 'http://www.api.com/v4' to the block.

### Specifying ranges

You can specify version ranges in many ways:
- {from: 2, to: 4} would result in v2, v3, v4
- {to: 3} would result in v1, v2, v3
- {only: 6} would result in v6
- {these: [2,4,5]} would result in v2, v4, v5

You can config all blocks to run over a certain range by default, like this...
	
	VersionedBlocks.versions = {from: 2, to: 4}

	versioned_block {|v, uri| puts "URI: #{uri}"}

...and override a default range in a specific case like this:
	
	versioned_block(only: 5, override: true) do |v, uri|
		puts "For version #{v}, the URI is #{uri}"
	end

### Configuration

You can set your preferences like this...
      
	VersionedBlocks.versions = {to: 5}
	VersionedBlocks.base_uri = 'http://www.api.com/'
	VersionedBlocks.prepend_errors = true

...and reset them all like this:

	VersionedBlocks.reset

All configurations can be overridden in a specific case using `override: true`:

	versioned_block(from: 1, to: 10, base_uri: 'http://new-api.com/', prepend_errors: false, override: true) do |v, uri|
		puts "For version #{v}, the URI is now #{uri}"
	end

You can also just override one of them - the others will use their default value:

	puts "overriding the versions but not the uri:"

	versioned_block(from: 1, to: 10, override: true) do |v, uri|
		puts "For version #{v}, the URI is still #{uri}"
	end

### Error messages

If you're using a versioned_block inside a test, for example, you might want any error messages to include some information about the version number that the test broke on. Just configure VersionedBlocks like this:

	VersionedBlocks.prepend_errors = true

## Installation

Add this line to your application's Gemfile:

    gem 'versioned_blocks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install versioned_blocks

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/versioned_blocks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
