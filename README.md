# versioned_blocks

Are you working with versioned APIs? Loop through them easily like this:

	VersionedBlocks.base_uri = 'http://www.api.com/'

	versioned_block(from:2, to:4) do |v, uri|
		puts "For version #{v}, the URI is #{uri}"
	end

The above example would return 'http://www.api.com/v2' through 'http://www.api.com/v8'

You can specify version ranges in many ways:
- {from:2, to:4} -> [2,3,4]
- {to: 5} -> [1,2,3,4,5]
- {only: 6} -> [6]
- {these:[2,4,5]} -> [2,4,5]

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
