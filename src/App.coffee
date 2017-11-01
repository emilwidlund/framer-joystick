{FocusSystem} = require './FocusSystem.coffee'
{Focusable} = require './Focusable.coffee'
{Background} = require './Background.coffee'
{viewStore} = require './stores/ViewStore.coffee'
{actionStore} = require './stores/ActionStore.coffee'
_ = Framer._

# Disable Hints
Framer.Extras.Hints.disable()

class exports.App extends FlowComponent

    constructor: (properties={}) ->

        background = new Background

        super _.defaults properties,
            backgroundColor: 'transparent'
        
        @focusSystem = new FocusSystem()
        @background = background
        @setupTransitionListener()

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
        
        viewStore.transition properties.view
    
    setupTransitionListener: ->
        viewStore.on 'transitionEvent', (transitionEvent) =>
            if transitionEvent.viewTransition
                @transition transitionEvent.view, transitionEvent.viewTransition
            else
                @showNext transitionEvent.view