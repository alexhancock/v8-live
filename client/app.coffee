React = require "react"
$ = require "jquery"
_ = require "underscore"

{div, form, input} = React.DOM

AppClass = React.createClass
  getInitialState: () ->
    {
      currentCompiledCode: "V8 Compiled Code Will be Displayed Here"
    }

  makeMessageSender: (socket) ->
    () ->
      newJS = $(this).html()
      socket.emit("new_source", { code: newJS })
  
  componentDidMount: () ->
    socket = io.connect('http://localhost:8000')
    socket.on "new_code", (data) =>
      @setState { currentCompiledCode: data.code.replace /\n/g, "<br />" }

    sender = _.throttle @makeMessageSender(socket), 100

    $(@getDOMNode())
      .on 'focus', '[contenteditable]', ->
          $this = $(this)
          $this.data 'before', $this.html()
          return $this
      .on 'blur keyup paste input', '[contenteditable]', sender

  render: () ->
    div
      className: "flex-container"

      div
        className: "flex-item"
        div
          contentEditable: true
          "// Enter JavaScript Code Here"

      div
        className: "flex-item"
        dangerouslySetInnerHTML:
          __html: @state.currentCompiledCode

App = AppClass()
 
React.renderComponent App, document.getElementById("app")
