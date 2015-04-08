# versioned_blocks

Are you working with versioned APIs? Loop through them easily like this:

	VersionedBlocks.base_uri = 'http://www.api.com/'

	versioned_block(from:2, to:4) do |v, uri|
		puts "For version #{v}, the URI is #{uri}"
	end

The above example would return 'http://www.api.com/v2' through 'http://www.api.com/v4'

You can specify version ranges in many ways:
- {from: 2, to: 4} would result in v2, v3, v4
- {to: 3} would result in v1, v2, v3
- {only: 6} would result in v6
- {these: [2,4,5]} would result in v2, v4, v5

You can config all blocks to run over a certain range by default, like this:
	
	VersionedBlocks.versions = {from: 2, to: 4}

And override a default range in a specific case like this:
	
	versioned_block(only: 5, override: true) do |v, uri|
		puts "For version #{v}, the URI is #{uri}"
	end

If you're using a versioned_block inside a test, for example, you might want any error messages to include the version number. Just configure VersionedBlocks like this:

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
