module Exist
  class Insight < Hashie::Mash
    include Hashie::Extensions::Coercion

    coerce_key :created,     ->(v) { Time.parse(v) }
    coerce_key :target_date, ->(v) { Date.parse(v) }
  end
end
