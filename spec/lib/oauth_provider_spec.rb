# frozen_string_literal: true

require 'oauth_provider'
require 'rails_helper'

RSpec.describe OauthProvider do
  before(:each) { OauthProvider.instances = [] }
  describe 'attributes' do
    let(:oap) { OauthProvider.new('l', 'n', 'i', 'id', 's') }
    it 'includes a label' do
      expect(oap.label).to eq 'l'
    end
    it 'includes a name' do
      expect(oap.name).to eq 'n'
    end
    it 'includes an icon' do
      expect(oap.icon).to eq 'i'
    end
    it 'includes an app_id' do
      expect(oap.app_id).to eq 'id'
    end
    it 'includes an app_secret' do
      expect(oap.app_secret).to eq 's'
    end
  end

  describe '.instances' do
    it 'is an array' do
      expect(OauthProvider.instances).to be_a(Array)
    end
    it 'can be assigned to' do
      OauthProvider.instances = [:nothing]
      expect(OauthProvider.instances).to eq [:nothing]
    end
    it 'can be appended to' do
      OauthProvider.instances << :something
      expect(OauthProvider.instances).to include(:something)
    end
  end

  describe '.[]' do
    it 'allows lookup by label' do
      o = OauthProvider.new(:a_label, '', '', '', '')
      expect(OauthProvider[:a_label]).to be(o)
    end
    it 'returns nil if nothing is found' do
      expect(OauthProvider[:nonexeistant]).to be_nil
    end
    it 'returns nil if passed nil' do
      expect(OauthProvider[nil]).to be_nil
    end
  end

  describe '.all' do
    it 'is an alias for .instances' do
      _ = OauthProvider.new(:a, '', '', '', '')
      expect(OauthProvider.all).to eq(OauthProvider.instances)
    end
  end

  describe '.labels' do
    let!(:oap_one) { OauthProvider.new(:l1, '', '', '', '') }
    let!(:oap_two) { OauthProvider.new(:l2, '', '', '', '') }

    it 'is an array' do
      expect(OauthProvider.labels).to be_a(Array)
    end
    it 'contains the labels of all instances' do
      expect(OauthProvider.labels)
        .to contain_exactly(oap_one.label, oap_two.label)
    end
  end

  describe '#initialize' do
    it 'appends to the class instances collection' do
      oap = OauthProvider.new(:foo, '', '', '', '')
      expect(OauthProvider.all).to include(oap)
    end
  end
end
