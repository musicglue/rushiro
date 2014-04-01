require_relative 'spec_helper'

describe 'a set of rules in allow-by-default mode' do
  before do
    @rules = Rushiro::Rules.new level: :individual, mode: Rushiro::Modes::AllowByDefault.new
  end

  describe 'no rules' do
    it 'permits any request' do
      @rules.permit?('page|view|posts').must_equal true
    end
  end

  describe 'a denies rule is added for a different level' do
    before do
      @rules.add_rule 'denies|system|company|edit|acme-123'
    end

    it 'ignores that rule' do
      @rules.permit?('company|edit|acme-123').must_equal true
    end
  end

  describe 'a denies rule has been added' do
    before do
      @rules.add_rule 'denies|individual|company|edit|acme-123'
    end

    it 'denies a request for that permission' do
      @rules.permit?('company|edit|acme-123').must_equal false
    end

    it 'permits any another request' do
      @rules.permit?('page|edit|blogs').must_equal true
    end
  end

  describe 'an allows rule has been added' do
    before do
      @rules.add_rule 'allows|individual|company|edit|acme-123'
    end

    it 'allows a request for that permission' do
      @rules.permit?('company|edit|acme-123').must_equal true
    end
  end

  describe 'a denies rule is added and then removed' do
    before do
      @rules.add_rule 'denies|individual|company|edit|acme-123'
      @rules.remove_rule 'denies|individual|company|edit|acme-123'
    end

    it 'allows a request for that permission' do
      @rules.permit?('company|edit|acme-123').must_equal true
    end
  end

  describe 'a wildcard denies rule has been added' do
    before do
      @rules.add_rule 'denies|individual|company|*|acme-456'
    end

    it 'denies any request matching that rule' do
      @rules.permit?('company|read|acme-456').must_equal false
      @rules.permit?('company|create|acme-456').must_equal false
      @rules.permit?('company|reboot|acme-456').must_equal false
    end
  end

  describe 'a complex example' do
    before do
      @rules.add_rule 'denies|individual|aa,bb|*|dd|*|12|34,56'
    end

    it 'denies any request matching that rule' do
      @rules.permit?('aa|xx|dd|xx|12|34').must_equal false
      @rules.permit?('bb|yyyyy|dd|zzzz|12|56').must_equal false
    end

    it 'allows other requests' do
      @rules.permit?('bb|yyyyy|ee|zzzz|12|56').must_equal true
    end
  end

  describe 'partially-matched permissions' do
    before do
      @rules.add_rule 'denies|individual'
    end

    it 'does not deny more complex permissions that match that simple rule' do
      @rules.permit?('a').must_equal true
    end
  end
end
