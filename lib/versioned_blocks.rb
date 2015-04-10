class VersionedBlocks
  VERSION = "1.0.3"

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
      b = opts.has_key?(:base_uri) && (opts[:override]==true || self.base_uri=='') ? opts[:base_uri] : self.base_uri
      raise('Empty base URI! Set VersionedBlock.base_uri or pass a :base_uri as an option') if b.nil? || b==''
      b += '/' unless b[-1]=='/' # add a slash if it's missing
      b = b[0..-2] if b[-2..-1]=='//' # get rid of trailing double slashes
      b
    end

    def opts_specify_a_version?(opts)
      opts.has_key?(:to) || (opts.has_key?(:to) && opts.has_key?(:from)) || opts.has_key?(:only) || opts.has_key?(:these)
    end

    def versions_from_opts(opts)
      # specifying versioning:
      #   pass {only:1} to test only v1
      #   pass {to:3} to test v1,v2,v3
      #   pass {from:2, to:3} to test v2,v3
      #   pass {these:[1,2,4]} to test v1,v2,v4 but NOT v3
      # you can set default versioning with:
      #   VersionedBlocks.config = {}
      # you can then override that default for a specifig case by passing:
      #   override:true
      # or reset the default versioning with:
      #   VersionedBlocks.reset
      opts = opts_specify_a_version?(opts) || (opts[:override]==true && opts_specify_a_version?(opts)) ? opts : self.versions 
      raise VersionedBlocksException, "No versions specified!" if opts == {} || !opts_specify_a_version?(opts)
      if opts[:from].is_a?(Integer) && opts[:to].is_a?(Integer) # from vX to vY
        raise VersionedBlocksException, "Expected :from (#{opts[:from]}) to be less than :to (#{opts[:to]})" if opts[:from] > opts[:to]
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
            raise VersionedBlocksException, "Each element in :these must be an integer"
          end
        else
          raise VersionedBlocksException, "Couldn't determine which versions to test!\nUse :only, :these, :to, or :from and :to"
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
      versions = versions_to_test.to_a
    end
    versions.each do |v, uri|
      begin
        block.call(v, uri)
      rescue Exception=> e
        e.message.prepend("When version = #{v}: ") if VersionedBlocks.prepend_errors || (opts[:override]==true && opts[:prepend_errors]==true)
        raise e
      end
    end
  end
end

class VersionedBlocksException < Exception
end