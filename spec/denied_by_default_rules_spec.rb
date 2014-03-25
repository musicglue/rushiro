require_relative 'spec_helper'

describe 'a set of rules in deny-by-default mode' do
  before do
    @rules = Rushiro::Rules.new level: :individual, mode: Rushiro::Modes::DenyByDefault.new
  end

  describe 'no rules' do
    it 'denies any request' do
      @rules.permit?('page|view|posts').must_equal false
    end
  end

  describe 'an allows rule is added for a different level' do
    before do
      @rules.add_rule 'allows|system|company|edit|acme-123'
    end

    it 'ignores that rule' do
      @rules.permit?('company|edit|acme-123').must_equal false
    end
  end

  describe 'an allows rule has been added' do
    before do
      @rules.add_rule 'allows|individual|company|edit|acme-123'
    end

    it 'allows a request for that permission' do
      @rules.permit?('company|edit|acme-123').must_equal true
    end

    it 'denies any another request' do
      @rules.permit?('page|edit|blogs').must_equal false
    end
  end

  describe 'an denies rule has been added' do
    before do
      @rules.add_rule 'denies|individual|company|edit|acme-123'
    end

    it 'denies a request for that permission' do
      @rules.permit?('company|edit|acme-123').must_equal false
    end
  end

  describe 'an allows rule is added and then removed' do
    before do
      @rules.add_rule 'allows|individual|company|edit|acme-123'
      @rules.remove_rule 'allows|individual|company|edit|acme-123'
    end

    it 'denies a request for that permission' do
      @rules.permit?('company|edit|acme-123').must_equal false
    end
  end
end
