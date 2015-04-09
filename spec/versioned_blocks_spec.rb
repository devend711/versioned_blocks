require_relative './spec_helper'

describe 'Versioned Blocks' do
  context 'before any config' do
    it 'has empty config, base_uri' do
      expect(VersionedBlocks.versions).to eq({})
      expect(VersionedBlocks.base_uri).to eq ''
    end

    context 'prepend_errors' do
      it 'is false' do
        expect(VersionedBlocks.prepend_errors).to be false
      end
    end

    context ':to' do
      it 'counts up to x' do
        count = 0
        versioned_block(to:3) do |v|
          count += 1
          expect(v).to eq count
        end
      end
    end

    context ':to, :from' do
      before :all do
        @x = 5
        @y = 8
        @count = @x - 1
      end

      it 'counts from x to y' do
        versioned_block(from:@x, to:@y) do |v|
          @count += 1
          expect(v).to eq @count
        end
        expect(@count).to eq @y
      end

      it 'raises an error if :from > :to' do
        begin
          versioned_block(from:@y, to:@x) {}
          expect(false).to be true
        rescue Exception=>e
          expect(e.class.to_s).to eq 'RuntimeError'
        end
      end
    end

    context ':these' do
      before :all do
        @nums = [1,2,5]
      end

      it 'counts only the specified versions' do
        versioned_block(these:@nums) do |v|
          expect(@nums).to include v
        end
      end
    end

    context ':only' do
      before :all do
        @num = 3
      end

      it 'counts only the specified version' do
        versioned_block(only:@num) do |v|
          expect(@num).to eq v
        end
      end
    end
  end

  context 'after config' do
    before :all do
      @versions = {to:5}
      @base_uri = 'http://www.google.com/'
      @prepend_errors = true
      VersionedBlocks.versions = @versions
      VersionedBlocks.base_uri = @base_uri
      VersionedBlocks.prepend_errors = @prepend_errors
    end

    it 'has a specified version' do
      expect(VersionedBlocks.versions).to eq @versions
    end

    it 'has a specified uri' do
      expect(VersionedBlocks.base_uri).to eq @base_uri
    end

    it 'can override a default uri without specifying version' do
      versioned_block(base_uri: 'test2.com', override: true) do |v, uri|
          expect(uri).to include 'test2'
      end
    end

    it 'can override a default uri and version' do
      versioned_block(base_uri: 'test2.com', only:8, override: true) do |v, uri|
          expect(uri).to include 'test2'
          expect(v).to eq 8
      end
    end

    it 'prepends errors' do
      expect(VersionedBlocks.prepend_errors).to eq @prepend_errors
      begin
        versioned_block do |v|
          v + "can't do this!"
        end
      rescue Exception=>e
        expect(e.message).to include "version"
      end
    end

    it 'can return a version and a url' do
      versioned_block do |v, uri|
        expect(v).to be_a Integer
        expect(uri).to be_a String
        expect(uri).to include @base_uri
      end
    end

    it 'returns the default specified versions' do
      versioned_block do |v|
        count = 0
        versioned_block do |v|
          count += 1
          expect(v).to eq count
        end
        expect(count).to eq @versions[:to]
      end
    end
  end
end