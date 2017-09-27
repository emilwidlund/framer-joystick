{Gamepad} = require './Gamepad.coffee'
{Broadcaster} = require './Broadcaster.coffee'
_ = Framer._

class exports.ActionHandler
    constructor: ->

        @focusableActions = []
        @viewActions = []

        Gamepad.on 'gamepadevent', (event) =>
            if event.keyCode < 4
                action = _.find @actions(), {keyCode: event.keyCode}
                if action
                    action.function()
        
        window.addEventListener 'keydown', (event) =>
            if event.keyCode == 13
                action = _.find @actions(), {keyCode: 0}
                if action
                    action.function()
            if event.keyCode == 8
                action = _.find @actions(), {keyCode: 1}
                if action
                    action.function()

        Broadcaster.on 'focusEvent', (focusable) =>
            @focusableActions = focusable.actions
    
    actions: ->
        return @focusableActions.concat @viewActions
    
    clearActions: ->
        @focusableActions = []
        @viewActions = []