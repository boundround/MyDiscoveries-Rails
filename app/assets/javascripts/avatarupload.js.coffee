# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#fileupload').fileupload
    dataType: "script"
    send: ->
      $('.spinner').css('visibility', 'visible')
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      console.log(file)
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('.passport-photo').empty()
        $('.passport-photo').append(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    done: ->
      $('.spinner').css('visibility', 'hidden')
