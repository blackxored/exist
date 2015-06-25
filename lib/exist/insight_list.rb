module Exist
  class InsightList < Hashie::Mash
    include Hashie::Extensions::Coercion

    coerce_key :insights, Array[Insight]

    def size
      insights.size
    end
  end
end
