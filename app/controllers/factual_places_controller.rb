class FactualPlacesController < ApplicationController
  require 'factual'
  def search
    term = params[:term]
    factual = Factual.new(ENV["FACTUAL_KEY"], ENV["FACTUAL_SECRET"])
    allowed_categories = [44, 50, 107, 108, 109, 110, 111, 112, 113, 114,
                          115, 116, 117, 118, 119, 120, 121, 122, 147, 151,
                          153, 154, 311, 319, 323, 325, 328, 331, 332, 344,
                          371, 389, 390, 392, 394, 402, 403, 407, 413, 452]
    response = factual.table("places").search(term).filters("category_ids" => {"$includes_any" => allowed_categories}).rows

    respond_to do |format|
      format.json { render json: response.to_json}  # respond with the created JSON object
    end
  end
end
