require_relative 'spec_helper'

describe 'a blank rule' do
  before do
    @rule = Rushiro::Rule.new
  end

  it 'matches everything' do
    ['', 'foo', 'foo|bar', 'foo|bar|zoo', '*|*|*'].each do |test|
      @rule.matches?(test).must_equal true
    end
  end

  it 'is equal to another blank rule' do
    @rule.must_equal Rushiro::Rule.new
  end
end

describe 'a rule loaded from a serialized rule string' do
  before do
    @rule = Rushiro::Rule.new serialized_rule
  end

  describe 'the serialized string contains a single group' do
    let(:serialized_rule) { 'foo' }

    it 'matches exact matches' do
      @rule.matches?('foo').must_equal true
    end

    it 'matches anything under that group' do
      @rule.matches?('foo|bar').must_equal true
    end

    it 'does not match anything else' do
      ['', 'bar', 'bar|foo'].each do |test|
        @rule.matches?(test).must_equal false
      end
    end
  end

  describe 'the serialized string contains multiple groups' do
    let(:serialized_rule) { 'foo|bar' }

    it 'matches exact matches' do
      @rule.matches?('foo|bar').must_equal true
    end

    it 'matches anything under those groups' do
      @rule.matches?('foo|bar|zoo').must_equal true
    end

    it 'does not match anything else' do
      ['', 'bar', 'bar|foo'].each do |test|
        @rule.matches?(test).must_equal false
      end
    end
  end

  describe 'the serialized string contains a wildcard' do
    let(:serialized_rule) { '*|bar' }

    it 'matches appropriate strings' do
      ['foo|bar', 'zoo|bar'].each do |test|
        @rule.matches?(test).must_equal true
      end
    end

    it 'does not match anything else' do
      ['', 'bar', 'bar|foo'].each do |test|
        @rule.matches?(test).must_equal false
      end
    end
  end

  describe 'the serialized string contains multi-valued groups' do
    let(:serialized_rule) { 'foo|bar,zoo' }

    it 'matches appropriage strings' do
      ['foo|bar', 'foo|zoo'].each do |test|
        @rule.matches?(test).must_equal true
      end
    end

    it 'does not match anything else' do
      ['bar|foo', 'foo'].each do |test|
        @rule.matches?(test).must_equal false
      end
    end
  end
end

describe 'rule serialization' do
  it 'serializes rules to strings' do
    Rushiro::Rule.new.to_s.must_equal ''
  end

  it 'serializes rules to strings with each field sorted alphabetically' do
    Rushiro::Rule.new('a|c,b|d,e|f').to_s.must_equal 'a|b,c|d,e|f'
  end

  it 'allows rules to be compared using ==' do
    Rushiro::Rule.new.must_be :==, Rushiro::Rule.new
    Rushiro::Rule.new('a|b|c').must_be :==, Rushiro::Rule.new('a|b|c')
  end

  it 'allows rules to be compared using eql?' do
    Rushiro::Rule.new.must_be :eql?, Rushiro::Rule.new
    Rushiro::Rule.new('a|b|c').must_be :eql?, Rushiro::Rule.new('a|b|c')
  end

  it 'allows rules to be used as hash keys' do
    hash = {}
    hash[Rushiro::Rule.new] = 1
    hash[Rushiro::Rule.new] = 2
    hash[Rushiro::Rule.new('a|b|c')] = 3
    hash[Rushiro::Rule.new('a|b|c')] = 4
    hash.keys.count.must_equal 2
    hash.values.must_equal [2, 4]
  end
end
