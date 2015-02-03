class SearchSuggestionSerializer < ActiveModel::Serializer
  attributes :id, :term, :popularity
end
