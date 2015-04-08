class VersionedBlocks
  VERSION = "1.0.0"

  class << self
    attr_accessor :versions, :base_uri, :prepend_errors

    def reset
      # set defaults
      self.versions = {}
      self.base_uri = ''
      self.prepend_errors = false
    end

    def base_uri_from_opts(opts)
      # specify a base uri:
      #   base:'http://www.example.com/'
      # or set a default base like:
      #   VersionedRetry.base = 'http://www.example.com/'
      b = opts.has_key?(:base_uri) ? opts[:base_uri] : self.base_uri
      raise('Empty base URI! Set VersionedBlock.base_uri or pass a :base_uri as an option') if b.nil? || b==''
      b += '/' unless b[-1]=='/' # add a slash if it's missing
      b = b[0..-2] if b[-2..-1]=='//' # get rid of trailing double slashes
      b
    end

    def versions_from_opts(opts)
      # specifying versioning:
      #   pass {only:1} to test only v1
      #   pass {to:3} to test v1,v2,v3
      #   pass {from:2, to:3} to test v2,v3
      #   pass {these:[1,2,4]} to test v1,v2,v4 but NOT v3
      # you can set default versioning with:
      #   VersionedRetry.config = {}
      # you can then override that default for a specifig case by passing:
      #   override:true
      # or reset the default versioning with:
      #   VersionedRetry.reset
      opts = self.versions unless (opts[:override]==true || self.versions == {})
      if opts[:from].is_a?(Integer) && opts[:to].is_a?(Integer) # from vX to vY
        versions_to_test = (opts[:from]..opts[:to])
      else
        if opts[:to].is_a?(Integer) # up to vX
          versions_to_test = (1..opts[:to])
        elsif opts[:only].is_a?(Integer) # only vX
          versions_to_test = [opts[:only]]
        elsif opts[:these].is_a?(Array) # vX, vY, etc. for each of :these
          if opts[:these].all?{|n| n.is_a?(Integer)}
            versions_to_test = opts[:these]
          else
            raise "Each element in :these must be an integer"
          end
        else
          raise "Couldn't determine which versions to test!\nUse :only, :these, :to, or :from and :to"
        end
      end
      versions_to_test
    end
  end
end

VersionedBlocks.reset

module Kernel
  def versioned_block(opts = {}, &block)
    versions_to_test = VersionedBlocks.versions_from_opts(opts)
    if block.arity == 2 # if block is asking for the uri and the version
      base_uri = VersionedBlocks.base_uri_from_opts(opts)
      versions = versions_to_test.map{|num| [num, "#{base_uri}v#{num}"]}
    else # just return the version 
      versions = versions_to_test.to_a #.map{|num| "v#{num}"}
    end
    versions.each do |v, uri|
      begin
        block.call(v, uri)
      rescue Exception=> e
        e.message.prepend("When version = #{v}: ") if VersionedBlocks.prepend_errors
        raise e
      end
    end
  end
end