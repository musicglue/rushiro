require_relative 'spec_helper'

describe 'a set of rules in deny-by-default mode' do
  before do
    @acl = Rushiro::Acl.new levels: :individual, modes: :deny_by_default
  end

  describe 'no rules' do
    it 'denies any request' do
      @acl.permit?('page|view|posts').must_equal false
    end
  end

  describe 'an allows rule is added for a different level' do
    before do
      @acl.add_rule 'allows|system|company|edit|acme-123'
    end

    it 'ignores that rule' do
      @acl.permit?('company|edit|acme-123').must_equal false
    end
  end

  describe 'an allows rule has been added' do
    before do
      @acl.add_rule 'allows|individual|company|edit|acme-123'
    end

    it 'allows a request for that permission' do
      @acl.permit?('company|edit|acme-123').must_equal true
    end

    it 'denies any another request' do
      @acl.permit?('page|edit|blogs').must_equal false
    end
  end

  describe 'an denies rule has been added' do
    before do
      @acl.add_rule 'denies|individual|company|edit|acme-123'
    end

    it 'denies a request for that permission' do
      @acl.permit?('company|edit|acme-123').must_equal false
    end
  end

  describe 'an allows rule is added and then removed' do
    before do
      @acl.add_rule 'allows|individual|company|edit|acme-123'
      @acl.remove_rule 'allows|individual|company|edit|acme-123'
    end

    it 'denies a request for that permission' do
      @acl.permit?('company|edit|acme-123').must_equal false
    end
  end

  describe 'partially-matched permissions' do
    before do
      @acl.add_rule 'allows|individual'
    end

    it 'does not allow more complex permissions that match that simple rule' do
      @acl.permit?('a').must_equal false
    end
  end
end
