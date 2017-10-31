{FocusSystem} = require './FocusSystem.coffee'
{Broadcaster} = require './Broadcaster.coffee'
{Focusable} = require './Focusable.coffee'
{ActionHandler} = require './ActionHandler.coffee'
{Background} = require './Background.coffee'
_ = Framer._

# Disable Hints
Framer.Extras.Hints.disable()

class exports.App extends FlowComponent

    constructor: (properties={}) ->

        new Background

        super _.defaults properties,
            backgroundColor: 'transparent'
        
        @focusSystem = new FocusSystem(@)
        @actionHandler = new ActionHandler

        # Manipulate FlowComponent's ScrollComponent content insets
        @on 'transitionstart', (previousView, nextView, direction) =>
            sc = @_tempScroll
            sc.contentInset = 0
        
        # Fix freezed state when halting transition
        @on 'transitionhalt', (previousView, nextView, direction) ->
            if previousView
                previousView.visible = false
        
        @on 'transitionend', (previousView, nextView, direction) ->
            sc = @_tempScroll
            sc.content.draggable.enabled = false

    transitionToView: (view, transition) ->
        if transition
            @transition(view, transition)
        else
            @showNext(view)
        
        @focusSystem.clearFocusables()
        @actionHandler.clearActions()

        @actionHandler.viewActions = view.actions

        for child, index in view.descendants
            if child instanceof Focusable
                @focusSystem.focusableElements.push child

        if @focusSystem.focusableElements.length
            @focusSystem.focus @focusSystem.focusableElements[0]

        @emit 'change:view', view
        Broadcaster.viewTransitionEvent(view)