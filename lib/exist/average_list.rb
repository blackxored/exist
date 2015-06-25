module Exist
  class AverageList < Hashie::Mash
    include Hashie::Extensions::Coercion

    coerce_key :averages, Array[Average]

    def size
      averages.size
    end
  end
end
