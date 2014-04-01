require_relative 'spec_helper'

describe 'a set of rules in allow-by-default mode' do
  before do
    @acl = Rushiro::Acl.new levels: :individual, modes: :allow_by_default
  end

  describe 'no rules' do
    it 'permits any request' do
      @acl.permit?('page|view|posts').must_equal true
    end
  end

  describe 'a denies rule is added for a different level' do
    before do
      @acl.add_rule 'denies|system|company|edit|acme-123'
    end

    it 'ignores that rule' do
      @acl.permit?('company|edit|acme-123').must_equal true
    end
  end

  describe 'a denies rule has been added' do
    before do
      @acl.add_rule 'denies|individual|company|edit|acme-123'
    end

    it 'denies a request for that permission' do
      @acl.permit?('company|edit|acme-123').must_equal false
    end

    it 'permits any another request' do
      @acl.permit?('page|edit|blogs').must_equal true
    end
  end

  describe 'an allows rule has been added' do
    before do
      @acl.add_rule 'allows|individual|company|edit|acme-123'
    end

    it 'allows a request for that permission' do
      @acl.permit?('company|edit|acme-123').must_equal true
    end
  end

  describe 'a denies rule is added and then removed' do
    before do
      @acl.add_rule 'denies|individual|company|edit|acme-123'
      @acl.remove_rule 'denies|individual|company|edit|acme-123'
    end

    it 'allows a request for that permission' do
      @acl.permit?('company|edit|acme-123').must_equal true
    end
  end

  describe 'a wildcard denies rule has been added' do
    before do
      @acl.add_rule 'denies|individual|company|*|acme-456'
    end

    it 'denies any request matching that rule' do
      @acl.permit?('company|read|acme-456').must_equal false
      @acl.permit?('company|create|acme-456').must_equal false
      @acl.permit?('company|reboot|acme-456').must_equal false
    end
  end

  describe 'a complex example' do
    before do
      @acl.add_rule 'denies|individual|aa,bb|*|dd|*|12|34,56'
    end

    it 'denies any request matching that rule' do
      @acl.permit?('aa|xx|dd|xx|12|34').must_equal false
      @acl.permit?('bb|yyyyy|dd|zzzz|12|56').must_equal false
    end

    it 'allows other requests' do
      @acl.permit?('bb|yyyyy|ee|zzzz|12|56').must_equal true
    end
  end

  describe 'partially-matched permissions' do
    before do
      @acl.add_rule 'denies|individual'
    end

    it 'does not deny more complex permissions that match that simple rule' do
      @acl.permit?('a').must_equal true
    end
  end
end
