# versioned_blocks

Are you working with versioned APIs? Loop through them easily like this:

	VersionedBlocks.base_uri = 'http://www.api.com/'

	versioned_block(from: 2, to: 4) do |v, uri|
		puts "For version #{v}, the URI is #{uri}"
	end

## Usage

### Specifying ranges

You can specify version ranges in many ways:
- {from: 2, to: 4} would pass 2,3,4 to the block
- {to: 3} would pass 1,2,3 to the block
- {only: 6} would pass just 6 to the block
- {these: [2,4,5]} would pass 2,4,5 to the block

You can config all blocks to run over a certain range by default, like this...
	
	VersionedBlocks.versions = {from: 2, to: 4}

	versioned_block {|v, uri| puts "URI: #{uri}"}

...and override a default range in a specific case like this:
	
	versioned_block(only: 5, override: true) do |v, uri|
		puts "For version #{v}, the URI is #{uri}"
	end

### Error messages

If you're using a versioned_block inside a test, for example, you might want any error messages to include some information about the version number that the test broke on. Just configure VersionedBlocks like this:

	VersionedBlocks.prepend_errors = true

### Configuring defaults

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

	versioned_block(from: 1, to: 10, override: true) do |v, uri|
		puts "For version #{v}, the URI is still #{uri}"
	end

## Installation

Add this line to your application's Gemfile:

    gem 'versioned_blocks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install versioned_blocks

## Contributing

1. Fork it ( https://github.com/[my-github-username]/versioned_blocks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
