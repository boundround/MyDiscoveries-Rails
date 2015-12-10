jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 840 / 167
      setSelect: [0, 0, 840, 167]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#place_crop_x').val(coords.x)
    $('#place_crop_y').val(coords.y)
    $('#place_crop_w').val(coords.w)
    $('#place_crop_h').val(coords.h)
