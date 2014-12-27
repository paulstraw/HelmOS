class DetailsApplication extends tg.Application
  # @applicationName: 'Navigation'
  @singleInstance: false

  @defaults:
    resizable: true
    positioning:
      top: 0
      left: 0
      width: 200
      height: 300
      minWidth: 200
      minHeight: 100
      maxWidth: 300
      maxHeight: 600

  constructor: (@props) ->
    @constructor.applicationName = @props.name
    super


    @render()

  render: =>
    @contentEl.html """
      hai
      #{JSON.stringify @props}
    """


tg.DetailsApplication = DetailsApplication