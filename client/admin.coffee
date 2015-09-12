# listen to actions from server
io = window.io.connect()

io.on 'message', (data) ->
  if data.taskName?
    $("##{data.taskName}_detail")
      .append "#{data.message}<br/>"
  else
    console.log "server says: ", data.message

io.on 'done', (data) ->
  $("##{data.taskName}_message")
    .html data.message
    .parent().addClass 'has-success'
  $("##{data.taskName}_detail")
    .append "done!<br/>"

io.on 'error', (data) ->
  message = data?.error?.message ? 'Unknown error occurred'
  fullMessage = "ERROR: #{message} (see server output for details)"
  $("##{data.taskName}_message")
    .html message
    .parent().addClass 'has-error'
  $("##{data.taskName}_detail")
    .append "#{fullMessage}<br/>"
  console.warn fullMessage


# interact with the admin user interface
Admin = {
  createCard: (data) ->
    # reset messsage
    console.log "creating card", data
    $('#createCard_message')
      .html "working ..."
      .parent()
        .removeClass 'has-success'
        .removeClass 'has-error'
    $('#createCard_detail')
      .html ""

    # do the reset thing
    io.emit "createCard", data

  deleteCard: (cardId) ->
    # reset messsage
    console.log "deleting card #{cardId}"
    $('#deleteCard_message')
      .html "working ..."
      .parent()
        .removeClass 'has-success'
        .removeClass 'has-error'
    $('#deleteCard_detail')
      .html ""

    # do the reset thing
    io.emit "deleteCard", cardId

  resetUser: (userId) ->
    # reset messsage
    console.log "resetting user #{userId}"
    $('#resetUser_message')
      .html "working ..."
      .parent()
        .removeClass 'has-success'
        .removeClass 'has-error'
    $('#resetUser_detail')
      .html ""

    # do the reset thing
    io.emit "resetUser", userId

  migrateS3: ->
    # reset messsage
    console.log "migrating image content to S3"
    $('#migrateS3_message')
      .html "working ..."
      .parent()
        .removeClass 'has-success'
        .removeClass 'has-error'
    $('#migrateS3_detail')
      .html ""

    # do the reset thing
    io.emit "migrateS3"
}

window.Admin = Admin

# routing
hidePages = ->
  $(".page").hide()

window.onhashchange = hashChange = ->
  console.log "showing page #{window.location.hash}"
  hidePages()
  $(window.location.hash).show()

# init the app
$(document).ready ->
  $('#createCard_form').on 'submit', -> Admin.createCard $(this).serializeObject(); false
  $('#deleteCard').on 'submit', -> Admin.deleteCard $('#deleteCard_id').val(); false
  $('#resetUser').on  'submit', -> Admin.resetUser  $('#resetUser_id').val(); false
  $('#migrateS3').on  'submit', -> Admin.migrateS3(); false
  if window.location.hash then hashChange()
  io.emit 'ready'

