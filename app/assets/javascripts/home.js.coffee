# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  ws = new WebSocket("ws://localhost:8080/")
  ws.onmessage = (event) ->
    data = event.data.split(':')
    if (data[0])
      ids = data[1].split(',')
      $("#" + id).appendTo(data[0]) for id in ids
    else
      alertIcon = $("#" + data[1] + " > span.ui-icon-alert")
      if alertIcon.length is 0
        s = '<span class="ui-icon ui-icon-alert"></span>'
        $(s).appendTo($("#" + data[1]))
      else
        $(alertIcon).remove()
    return

  $("#table1, #table2").sortable(
    cursor: 'move'
    connectWith: 'ul'
    placeholder: 'ui-state-highlight'
    containment: $("#content")
    start: (event, ui) -> 
      ws.send(":" + ui.item.attr('id'))
      return
    stop: (event, ui) ->
      ws.send(":" + ui.item.attr('id'))
      return
    update: (event, ui) ->
      id = ui.item.parent().attr('id')
      ws.send("#" + id + ":" + $("#" + id).sortable('toArray').join(','))
      return
  ).disableSelection()
  return
