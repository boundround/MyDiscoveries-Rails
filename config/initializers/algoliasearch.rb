ENV['ALGOLIA_ID'] ||= 'KXOYK344AM'
ENV["ALGOLIA_API_KEY"] ||= 'f7a37d071e6ab787eb257537ee1f7146'
AlgoliaSearch.configuration = { application_id: ENV["ALGOLIA_ID"], api_key: ENV["ALGOLIA_API_KEY"], pagination_backend: :will_paginate } #unless Rails.env.development?
