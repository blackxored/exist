module Exist
  class CorrelationList < Hashie::Mash
    include Hashie::Extensions::Coercion

    coerce_key :correlations, Array[Correlation]
  end
end
