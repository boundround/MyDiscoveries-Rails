// *********************************************************************
// MAPBOX STREETS
// *********************************************************************

// =====================================================================
// FONTS
// =====================================================================

// Language
@name: '[name_en]';

// set up font sets for various weights and styles
@sans_lt:           "Open Sans Regular","Arial Unicode MS Regular";
@sans_lt_italic:    "Open Sans Italic","Arial Unicode MS Regular";
@sans:              "Open Sans Semibold","Arial Unicode MS Regular";
@sans_bold:         "Open Sans Bold","Arial Unicode MS Regular";
@sans_italic:       "Open Sans Semibold Italic","Arial Unicode MS Regular";
@sans_bold_italic:  "Open Sans Bold Italic","Arial Unicode MS Regular";

// =====================================================================
// LANDUSE & LANDCOVER COLORS
// =====================================================================

@land:              #E8E5D3;
@water:             #62BDC8;
@grass:             #E1EBB0;
@sand:              #F7ECD2;
@rock:              #D8D7D5;
@park:              #C8DF9F;
@cemetery:          #D5DCC2;
@wooded:            #3A6;
@industrial:        #DDDCDC;
@agriculture:       #EAE0D0;
@snow:              #EDE5DD;

@building:          darken(@land, 8);
@hospital:          #F2E3E1;
@school:            #F2EAB8;
@pitch:             #CAE6A9;
@sports:            @park;

@parking:           fadeout(@road_fill, 75%);

// =====================================================================
// ROAD COLORS
// =====================================================================

// For each class of road there are three color variables:
// - line: for lower zoomlevels when the road is represented by a
//         single solid line.
// - case: for higher zoomlevels, this color is for the road's
//         casing (outline).
// - fill: for higher zoomlevels, this color is for the road's
//         inner fill (inline).

@motorway_line:     #DCD5CF;
@motorway_fill:     #DCD5CF;
@motorway_case:     #DCD5CF;

@main_line:     #DCD5CF;
@main_fill:     #DCD5CF;
@main_case:     #DCD5CF;

@road_line:     #DCD5CF;
@road_fill:     #DCD5CF;
@road_case:     #DCD5CF;

@pedestrian_line:   #fff;
@pedestrian_fill:   @pedestrian_line;
@pedestrian_case:   @road_case;

@path_line:     #fff;
@path_fill:     #fff;
@path_case:     @land;

@rail_line:     #aaa;
@rail_fill:     #fff;
@rail_case:     @land;

@bridge_case:   #999;

@aeroway:       lighten(@industrial,5);

// =====================================================================
// BOUNDARY COLORS
// =====================================================================

@admin_2:           #234;
@admin_3:           #345;
@admin_4:           #345;

// =====================================================================
// LABEL COLORS
// =====================================================================

// We set up a default halo color for places so you can edit them all
// at once or override each individually.
@place_halo:        #ddd;

@country_text:      #797062;
@country_halo:      @place_halo;

@state_text:        #82696A;
@state_halo:        @place_halo;

@city_text:         #555;
@city_halo:         @place_halo;

@town_text:         #888;
@town_halo:         @place_halo;

@poi_text:          @poi_text;  

@road_text:         #725556;
@road_halo:         #DCD5CF;

@other_text:        darken(@land,50)*0.8;
@other_halo:        @place_halo;

@locality_text:     #aaa;
@locality_halo:     @land;

// Also used for other small places: hamlets, suburbs, localities
@village_text:      #888;
@village_halo:      @place_halo;

@transport_text:    #445;

/**/