require_relative 'spec_helper'

describe 'an acl' do
  describe 'when no levels are specified at creation time' do
    before do
      @acl = Rushiro::Acl.new
    end

    it 'serializes to an empty array' do
      @acl.to_a.must_equal []
    end
  end

  describe 'when levels are specified at creation time' do
    before do
      @acl = Rushiro::Acl.new levels: %i(aa bb cc dd)
    end

    it 'serializes to an empty array' do
      @acl.to_a.must_equal []
    end
  end

  describe 'when rules are added to multiple levels' do
    before do
      @acl = Rushiro::Acl.new levels: %i(aa bb)
      @acl.add_rule 'denies|aa|red|green|blue'
      @acl.add_rule 'denies|bb|y,z,x|123'
      @acl.add_rule 'denies|aa|foo|bar'
    end

    it 'serializes to an array of serialized rules' do
      @acl.to_a.must_equal ['denies|aa|foo|bar', 'denies|aa|red|green|blue', 'denies|bb|x,y,z|123']
    end
  end

  describe 'when a rule is added at two levels and removed from one' do
    before do
      @acl = Rushiro::Acl.new
      @acl.add_rule 'denies|individual|foo|bar'
      @acl.add_rule 'denies|system|foo|bar'
      @acl.remove_rule 'denies|individual|foo|bar'
    end

    it 'permits appropriate requests' do
      @acl.permit?('xx|yy').must_equal true
    end

    it 'denies inappropriate requests' do
      @acl.permit?('foo|bar').must_equal false
    end
  end

  describe 'when a rule is added at two levels and removed from both' do
    before do
      @acl = Rushiro::Acl.new
      @acl.add_rule 'denies|individual|foo|bar'
      @acl.add_rule 'denies|system|foo|bar'
      @acl.remove_rule 'denies|system|foo|bar'
      @acl.remove_rule 'denies|individual|foo|bar'
    end

    it 'permits appropriate requests' do
      @acl.permit?('foo|bar').must_equal true
    end
  end

  describe 'when a mode is specified at creation time and rules are added and removed' do
    before do
      @acl = Rushiro::Acl.new levels: %i(aa bb), mode: :deny_by_default
      @acl.add_rule 'allows|aa|foo'
      @acl.add_rule 'allows|bb|foo'
      @acl.remove_rule 'allows|aa|foo'
    end

    it 'permits appropriate requests' do
      @acl.permit?('foo').must_equal true
    end

    it 'denies inappropriate requests' do
      @acl.permit?('bar').must_equal false
    end
  end
end
