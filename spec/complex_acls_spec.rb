require_relative 'spec_helper'

describe 'complex acls' do
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

  describe 'when a rule is denied and allowed at the same level' do
    before do
      @acl = Rushiro::Acl.new
      @acl.add_rule 'denies|individual|foo|bar'
      @acl.add_rule 'allows|individual|foo|bar'
    end

    it 'permits the request' do
      @acl.permit?('foo|bar').must_equal true
    end
  end

  describe 'when a rule is denied at a low level and allowed at a high level' do
    before do
      @acl = Rushiro::Acl.new
      @acl.add_rule 'denies|individual|foo|bar'
      @acl.add_rule 'allows|system|foo|bar'
    end

    it 'permits the request' do
      @acl.permit?('foo|bar').must_equal true
    end
  end

  describe 'when a rule is allowed at a low level and denied at a high level' do
    before do
      @acl = Rushiro::Acl.new
      @acl.add_rule 'denies|system|foo|bar'
      @acl.add_rule 'allows|organization|foo|bar'
    end

    it 'denies the request' do
      @acl.permit?('foo|bar').must_equal false
    end
  end

  describe 'when a rule is denied at a low level and allowed at a higher level and denied at the highest level' do
    before do
      @acl = Rushiro::Acl.new
      @acl.add_rule 'denies|individual|foo|bar'
      @acl.add_rule 'allows|organization|foo|bar'
      @acl.add_rule 'denies|system|foo|bar'
    end

    it 'permits the request' do
      @acl.permit?('foo|bar').must_equal false
    end

    it 'serializes to an array of serialized rules' do
      @acl.to_a.must_equal ['denies|individual|foo|bar', 'allows|organization|foo|bar', 'denies|system|foo|bar']
    end
  end

  describe 'when a rule is allowed at a low level and denies at a higher level and allowed at the highest level' do
    before do
      @acl = Rushiro::Acl.new
      @acl.add_rule 'allows|individual|foo|bar'
      @acl.add_rule 'denies|organization|foo|bar'
      @acl.add_rule 'allows|system|foo|bar'
    end

    it 'denies the request' do
      @acl.permit?('foo|bar').must_equal true
    end

    it 'serializes to an array of serialized rules' do
      @acl.to_a.must_equal ['allows|individual|foo|bar', 'denies|organization|foo|bar', 'allows|system|foo|bar']
    end
  end
end
