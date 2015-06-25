module Exist
  class User < Hashie::Mash
    include Hashie::Extensions::Coercion

    coerce_key :local_time, ->(v) { Time.parse(v) }
    coerce_key :attributes, Array[Exist::Attributes]
  end
end
