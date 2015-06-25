module Exist
  class AttributeList < Hashie::Mash
    include Hashie::Extensions::Coercion

    coerce_key :attributes, Array[Attributes]

    def size
      attributes.size
    end
    alias :count :size
  end
end
