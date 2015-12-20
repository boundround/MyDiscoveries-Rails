module Api
  module V1
    class PlacesController < ApplicationController
      class Place < ::Place
        # Note: this does not take into consideration the create/update actions for changing google_place_id
        def as_json(options = {})
          super.merge(google_place_id: place_id)
        end
      end

      respond_to :json

      def index
        respond_with Place.all_places
      end

      def show
        @place = Place.friendly.find(params[:id])
        respond_with @place, include: [:photos, :videos]
      end

      def create
        respond_with Place.create(params[:place])
      end

      def update
        respond_with Place.update(params[:id], params[:places])
      end

      def destroy
        respond_with Place.destroy(params[:id])
      end
    end
  end
end
