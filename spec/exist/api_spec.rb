require 'spec_helper'

RSpec.describe Exist::API do
  context "initialization" do
    let(:token) { 'SOMETOKEN' }

    it 'initializes with a token' do
      client = described_class.new(token: token)
      expect(client.api_key).to eq(token)
    end

    it 'reads the token from environment if not given' do
      ENV['EXIST_API_TOKEN'] = token
      client = described_class.new
      expect(client.api_key).to eq(token)
    end

    it 'raises an error if no token present' do
      ENV.delete('EXIST_API_TOKEN')

      expect {
        described_class.new
      }.to raise_error(ArgumentError)
    end

    it 'negotiates a token if username and password are provided' do
      stub_request(:post, api_root + '/auth/simple-token/').to_return(
        body:    { token: token                        }.to_json,
        headers: { 'Content-Type' => 'application/json'}
      )

      client = described_class.new(username: 'some', password: 'pass')
      expect(client.api_key).to be_truthy
    end

    it 'raises an error if fails to login' do
      stub_request(:post, api_root + '/auth/simple-token/').to_return(
        status: 401
      )
      expect {
        described_class.new(username: 'john', password: 'doe')
      }.to raise_error(/There was a problem authenticating with the API/)
    end
  end

  context 'API' do
    let(:client) { described_class.new(token: 'SOME') }

    describe '#me' do
      let(:user) { client.me }

      before do
        stub_request_with_fixture(:get, '/users/$self/', :user_stripped)
      end

      it 'returns the current user' do
        expect(user.id).to eq(1)
        expect(user.local_time).to be_kind_of(Time)
      end
    end

    describe '#overview' do
      let(:overview) { client.overview }

      before do
        stub_request_with_fixture(:get, '/users/$self/today/', :overview)
      end

      it 'returns the overview for the current user' do
        expect(overview.username).to eq('josh')
      end

      it 'coerces keys' do
        expect(overview.local_time).to be_kind_of(Time)
        expect(overview.private).to eq(false)
      end

      it 'contains attributes' do
        expect(overview.attributes.first.group).to eq('steps')
        expect(overview.attributes.first.items.size).to eq(2)
        expect(overview.attributes.first.items.first.value).to eq(258)
      end
    end

    describe '#attributes' do
      let(:attributes) { client.attributes }

      before do
        stub_request_with_fixture(:get, '/users/$self/attributes/?limit=31', :attributes)
      end

      it 'returns the attributes for the current user' do
        expect(attributes).to be
      end

      it 'wraps into an attribute list' do
        expect(attributes).to be_kind_of(Exist::AttributeList)
        expect(attributes.size).to eq(2)
      end

      it 'coerces values' do
        pending
        expect(attributes.first.values.first.date).to be_kind_of(Date)
      end
    end

    describe '#attribute' do
      let(:attribute) { client.attribute(:steps) }

      before do
        stub_request_with_fixture(
          :get, '/users/$self/attributes/steps/?date_max=&date_min=&limit=31&page=1',
          :specific_attribute
        )
      end

      it 'returns a specific attribute' do
        expect(attribute.attributes).to be
      end

      it 'wraps into an attribute list' do
        expect(attribute.total).to eq(655)
        expect(attribute.size).to eq(7)
      end
    end

    describe '#insights' do
      let(:insights) { client.insights }

      before do
        stub_request_with_fixture(
          :get, '/users/$self/insights/?date_max=&date_min=&limit=31&page=1',
          :insights
        )
      end

      it 'returns the user insights' do
        expect(insights.insights).to be
      end

      it 'wraps inside an insight list' do
        expect(insights.total).to eq(740)
        expect(insights.size).to eq(2)
      end
    end

    describe '#insights_for_attribute' do
      let(:insights) { client.insights_for_attribute(:sleep) }

      before do
        stub_request_with_fixture(
          :get, '/users/$self/insights/attribute/sleep/?date_max=&date_min=&limit=31&page=1',
          :insights_for_specific_attribute
        )
      end

      it 'returns the specific attribute insights' do
        expect(insights.insights).to be
      end

      it 'wrap in an insights list' do
        expect(insights.size).to eq(1)
        expect(insights.total).to eq(220)
      end
    end

    describe '#averages' do
      let(:averages) { client.averages }

      before do
        stub_request_with_fixture(:get, '/users/$self/averages/', :averages)
      end

      it 'returns the current averages' do
        expect(averages.averages).to be
      end

      it 'wraps in an average list' do
        expect(averages.size).to eq(2)
      end
    end

    describe '#average_for_attribute' do
      let(:average) { client.average_for_attribute(:steps) }

      before do
        stub_request_with_fixture(
          :get, '/users/$self/averages/attribute/steps/?date_max=&date_min=&limit=31&page=1',
          :average_for_specific_attribute
        )
      end

      it 'returns the average for an specific attribute' do
        expect(average.averages).to be
      end

      it 'wraps in an average list' do
        expect(average.size).to eq(2)
      end
    end

    describe '#correlations' do
      let(:correlations) { client.correlations(:$self, :steps) }

      before do
        stub_request_with_fixture(
          :get, '/users/$self/correlations/attribute/steps/?date_max=&date_min=&limit=31&page=1',
          :correlations
        )
      end

      it 'returns the correlations for an attribute' do
        expect(correlations.correlations).to be
      end

      it 'wraps in a correlation list' do
        expect(correlations.total).to eq(479)
        expect(correlations.size).to eq(2)
      end

      context 'when specifying latest_only' do
        before do
          stub_request(
            :get,
            api_root + '/users/$self/correlations/attribute/steps/?latest_only=true&limit=31&page=1'
          ).to_return(
            body: {}.to_json,
            headers: { 'Content-Type' => 'application/json'}
          )
        end

        it 'returns only the latest correlations, avoiding date ranges' do
          client.correlations(:$self, :steps, latest_only: true)
        end
      end
    end
  end
end
