jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1008 / 200
      setSelect: [0, 0, 1008, 200]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#place_crop_x').val(coords.x)
    $('#place_crop_y').val(coords.y)
    $('#place_crop_w').val(coords.w)
    $('#place_crop_h').val(coords.h)
