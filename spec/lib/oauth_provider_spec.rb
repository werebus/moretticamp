# frozen_string_literal: true

require 'oauth_provider'
require 'rails_helper'

RSpec.describe OauthProvider do
  around do |example|
    described_class.instances = []
    example.run
    described_class.instances = []
  end

  describe 'attributes' do
    let(:oap) { described_class.new('l', 'n', 'i', 'id', 's') }

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
      expect(described_class.instances).to be_a(Array)
    end

    it 'can be assigned to' do
      described_class.instances = [:nothing]
      expect(described_class.instances).to eq [:nothing]
    end

    it 'can be appended to' do
      described_class.instances << :something
      expect(described_class.instances).to include(:something)
    end
  end

  describe '.[]' do
    it 'allows lookup by label' do
      o = described_class.new(:a_label, '', '', '', '')
      expect(described_class[:a_label]).to be(o)
    end

    it 'returns nil if nothing is found' do
      expect(described_class[:nonexeistant]).to be_nil
    end

    it 'returns nil if passed nil' do
      expect(described_class[nil]).to be_nil
    end
  end

  describe '.all' do
    it 'is an alias for .instances' do
      _ = described_class.new(:a, '', '', '', '')
      expect(described_class.all).to eq(described_class.instances)
    end
  end

  describe '.labels' do
    let!(:oap_one) { described_class.new(:l1, '', '', '', '') }
    let!(:oap_two) { described_class.new(:l2, '', '', '', '') }

    it 'is an array' do
      expect(described_class.labels).to be_a(Array)
    end

    it 'contains the labels of all instances' do
      expect(described_class.labels)
        .to contain_exactly(oap_one.label, oap_two.label)
    end
  end

  describe '#initialize' do
    it 'appends to the class instances collection' do
      oap = described_class.new(:foo, '', '', '', '')
      expect(described_class.all).to include(oap)
    end
  end
end
