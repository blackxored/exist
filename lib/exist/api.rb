module Exist
  class API
    include Authentication

    attr_reader :client

    def initialize(options = {})
      @options = options
      @token   = options[:token]
      @client  = initialize_http_client

      login! if credentials_provided?

      unless api_key
        raise ArgumentError.new(
          "Must include user & password if no token provided or in environment"
        )
      end

      client.headers['Authorization'] = "Token #{api_key}"
    end

    def me
      User.new(user_resource(nil))
    end

    def overview(username = '$self')
      User.new(client.get("users/#{username}/today/").body)
    end

    def attributes(limit: 31)
      response = user_resource('attributes', limit: limit)
      AttributeList.new(attributes: response)
    end

    # Date format is YYYY-mm-dd
    def attribute(attribute, limit: 31, page: 1, oldest_date: nil, newest_date: nil)
      response = paginated_user_resource(
        "attributes/#{attribute}", page, limit, oldest_date, newest_date
      )
      AttributeList.new(
        attributes: response['results'], total: response['count']
      )
    end

    def insights(limit: 31, page: 1, oldest_date: nil, newest_date: nil)
      response = paginated_user_resource(
        'insights', page, limit, oldest_date, newest_date
      )

      InsightList.new(insights: response['results'], total: response['count'])
    end

    def insights_for_attribute(attribute, limit: 31, page: 1, oldest_date: nil, newest_date: nil)
      response = paginated_user_resource(
        "insights/attribute/#{attribute}",
        page, limit, oldest_date, newest_date
      )
      InsightList.new(
        insights: response['results'],
        total:    response['count'],
      )
    end

    def averages
      response = user_resource('averages')
      AverageList.new(averages: response)
    end

    def average_for_attribute(attribute, limit: 31, page: 1, oldest_date: nil, newest_date: nil)
      response = paginated_user_resource(
        "averages/attribute/#{attribute}", page, limit, oldest_date, newest_date
      )

      AverageList.new(averages: response['results'], total: response['count'])
    end

    def correlations(username, attribute, limit: 31, page: 1, oldest_date: nil,
                     newest_date: nil, latest_only: false)

      params = { page: page, limit: limit }

      if !latest_only
        params.merge!(date_min: oldest_date, date_max: newest_date)
      else
        params.merge!(latest_only: true)
      end

      response = client.get(
        "users/#{username}/correlations/attribute/#{attribute}/", params
      ).body

      CorrelationList.new(
        correlations: response['results'],
        total:        response['count']
      )
    end

    private
    def initialize_http_client
      Faraday.new(url: base_url) do |conn|
        conn.headers['User-Agent'] = "Exist Ruby #{Exist::VERSION}"
        conn.request :json
        conn.response :logger if ENV['FARADAY_DEBUG']
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    def user_resource(resource, params = {})
      url = base_url + "users/$self/#{resource}"
      url += "/" unless url.end_with?('/')

      client.get(url, params).body
    end

    def paginated_user_resource(resource, page, limit, newest_date, oldest_date)
      user_resource(resource, {
        page: page, limit: limit, date_min: oldest_date,
        date_max: newest_date
      })
    end

    def base_url
      'https://exist.io/api/1/'
    end
  end
end
