class CommunicationsApplication extends tg.Application
  @applicationName: 'Communications'

  @defaults:
    resizable: true
    positioning:
      bottom: 0
      left: 0
      width: 400
      height: 240
      minWidth: 200
      minHeight: 100
      maxWidth: 800
      maxHeight: 800

  constructor: ->
    super

    @currentChannelName = null
    @channels = []

    @contentEl.html """
      <ul class="channels"></ul>
      <ul class="messages"></ul>
      <input class="message-box" type="text">
    """

    # handle when we connect to a channel
    $(document).on 'channel.connected', (e, channelName) =>
      @_handleChannelConnect(channelName)

    # handle when we disconnect from a channel
    $(document).on 'channel.disconnected', (e, channelName) =>
      @_handleChannelDisconnect(channelName)

    # handle channels that were already connected when the comms app was initialized
    _.each tg.ghos.serverData.chatChannels, (channel) =>
      @_handleChannelConnect(channel.name)

    @contentEl.on 'click', '.channels li', @switchChannel
    @contentEl.on 'keydown', '.message-box', @sendMessage


  _handleChannelConnect: (channelName) =>
    return if @channels.indexOf(channelName) > -1
    @channels.push {name: channelName, messages: []}

    console.log 'capp', channelName
    $(document).on "#{channelName.replace(' ', '_')}.new_message", @_handleChannelNewMessage
    @contentEl.find('.channels').append """
      <li data-channel-name="#{channelName}">
        #{channelName.split(':')[0].split('.')[1]}
      </li>
    """

    # if this is our only channel, switch to it
    @switchChannel({target: @contentEl.find('.channels').find('li:first-child')}) if @channels.length == 1


  _handleChannelDisconnect: (channelName) =>
    @channels = _.reject @channels, (channel) -> channel.name == channelName
    $(document).off "#{channelName.replace(' ', '_')}.new_message", @_handleChannelNewMessage


  _handleChannelNewMessage: (e, message) =>
    messageChannel = _.find @channels, (channel) -> channel.name == message.channel_name

    messageChannel.messages.push(message)
    @addMessage(message) if message.channel_name == @currentChannelName


  addMessage: (message) =>
    @contentEl.find('.messages').append """
      <li>
        <span class="name" style="color: ##{message.ship.name_hex_color}">#{message.ship.name}:</span>
        #{message.content}
      </li>
    """

  switchChannel: (e) =>
    clicked = $(e.target)

    clicked.addClass('current').siblings().removeClass('current')

    @currentChannelName = clicked.data('channel-name')

    @contentEl.find('.messages').html('')

    newChannel = _.find @channels, (channel) => channel.name == @currentChannelName
    console.log newChannel.messages
    @addMessage message for message in newChannel.messages


  sendMessageSuccess: ->
    console.log 'success'

  sendMessageFailure: ->
    console.log 'success'

  sendMessage: (e) =>
    messageBox = @contentEl.find('.message-box')
    val = messageBox.val()

    return if e.which != 13 || val == ''

    messageBox.val('')

    message =
      channel_name: @currentChannelName
      content: val

    tg.ghos.socket.trigger 'messages.create', message, ->
      console.log 'Successfully sent message'
    , ->
      console.log 'Failed to send message', arguments





tg.CommunicationsApplication = CommunicationsApplication