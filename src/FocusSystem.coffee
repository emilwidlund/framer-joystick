{Gamepad} = require './Gamepad.coffee'
{Broadcaster} = require './Broadcaster.coffee'
_ = Framer._

class exports.FocusSystem 
    constructor: (app) ->

        @focusableElements = []
        @focusedElement = {}
        @previouslyFocusedElement = {}

        @app = app

        # Setup event listeners for navigation
        Gamepad.on 'gamepadevent', (event) =>
            if event.keyCode > 36 && event.keyCode < 41 && @focusableElements.length
                @navigate event.keyCode
            else if event.keyCode > 11 && event.keyCode < 16 && @focusableElements.length
                @navigate event.keyCode

        window.addEventListener 'keydown', (event) =>
            if event.keyCode > 36 && event.keyCode < 41 && @focusableElements.length
                @navigate(event.keyCode)

    navigate: (keyCode) ->

        focusedPosition = 
            x: @focusedElement.screenFrame.x + (@focusedElement.screenFrame.width / 2),
            y: @focusedElement.screenFrame.y + (@focusedElement.screenFrame.height / 2)

        relevantFocusables = _.filter @focusableElements, (focusable) ->

            if focusable.parent.parent.visible == false || focusable.parent.parent.opacity == 0 
                return false
            if focusable.visible == false || focusable.opacity == 0 
                return false

            switch keyCode
                when 13
                    focusablePosition =
                        x: focusable.screenFrame.x + focusable.screenFrame.width
                        y: focusable.screenFrame.y + (focusable.screenFrame.height / 2)

                    if focusablePosition.x < focusedPosition.x
                        return true
                    else 
                        return false

                when 11
                    focusablePosition =
                        x: focusable.screenFrame.x + (focusable.screenFrame.width / 2)
                        y: focusable.screenFrame.y + focusable.screenFrame.height
                
                    if focusablePosition.y < focusedPosition.y 
                        return true
                    else 
                        return false

                when 14
                    focusablePosition =
                        x: focusable.screenFrame.x
                        y: focusable.screenFrame.y + (focusable.screenFrame.height / 2)

                    if focusablePosition.x > focusedPosition.x 
                        return true
                    else 
                        return false

                when 12
                    focusablePosition =
                        x: focusable.screenFrame.x + (focusable.screenFrame.width / 2)
                        y: focusable.screenFrame.y

                    if focusablePosition.y > focusedPosition.y 
                        return true
                    else 
                        return false

                when 37
                    focusablePosition =
                        x: focusable.screenFrame.x + focusable.screenFrame.width
                        y: focusable.screenFrame.y + (focusable.screenFrame.height / 2)

                    if focusablePosition.x < focusedPosition.x 
                        return true
                    else 
                        return false

                when 38
                    focusablePosition = 
                        x: focusable.screenFrame.x + (focusable.screenFrame.width / 2)
                        y: focusable.screenFrame.y + focusable.screenFrame.height

                    if focusablePosition.y < focusedPosition.y 
                        return true
                    else 
                        return false

                when 39
                    focusablePosition =
                        x: focusable.screenFrame.x,
                        y: focusable.screenFrame.y + (focusable.screenFrame.height / 2)

                    if focusablePosition.x > focusedPosition.x 
                        return true
                    else 
                        return false

                when 40
                    focusablePosition =
                        x: focusable.screenFrame.x + (focusable.screenFrame.width / 2)
                        y: focusable.screenFrame.y

                    if focusablePosition.y > focusedPosition.y 
                        return true
                    else 
                        return false
   

        sortedFocusables = _.sortBy relevantFocusables, (focusable) ->

            switch keyCode
                when 14
                    angleOffset = 90
                    break

                when 12
                    angleOffset = 0
                    break

                when 15
                    angleOffset = 90
                    break

                when 13
                    angleOffset = 180
                    break

                when 37
                    angleOffset = 90
                    break

                when 38
                    angleOffset = 0
                    break

                when 39
                    angleOffset = 90
                    break

                when 40
                    angleOffset = 180
                    break
                

            focusablePosition =
                x: focusable.screenFrame.x + (focusable.screenFrame.width / 2)
                y: focusable.screenFrame.y + (focusable.screenFrame.height / 2)
            
            Y = Math.abs(focusedPosition.y - focusablePosition.y)
            X = Math.abs(focusedPosition.x - focusablePosition.x)
            
            distance = Math.sqrt(Math.abs(X*X + Y*Y))
            angle = Math.abs(Math.atan2(focusedPosition.x - focusablePosition.x, focusedPosition.y - focusablePosition.y) * 180 / Math.PI)
            score = distance + Math.abs(angleOffset - angle)
            return score
		
        if sortedFocusables.length
            @focus sortedFocusables[0]
	
    focus: (focusable) ->

        Broadcaster.focusEvent(focusable)
        @app.emit 'change:focusedElement', focusable

        # If an element is focused, set it as previouslyFocused and change state to default
        # Loop through descendant elements and update their states as well

        if Object.keys(@focusedElement).length
            @previouslyFocusedElement = @focusedElement
            @previouslyFocusedElement.animate 'default'

            @previouslyFocusedElement.descendants.map (desc, index) ->
                if desc.states.focused
                    desc.animate 'default'
        
        # Focus focusable and change state to focused
        # Loop through descendant elements and update their states as well

        @focusedElement = focusable
        @focusedElement.animate 'focused'

        for desc, index in @focusedElement.descendants
            if desc.states.focused
                desc.animate 'focused'
    
    clearFocusables: ->
        @focusableElements = []
        @previouslyFocusedElement = @focusedElement
        if Object.keys(@focusedElement).length
            @clearFocused()
    
    clearFocused: ->
        @previouslyFocusedElement = @focusedElement
        @previouslyFocusedElement.animate 'default'

        @previouslyFocusedElement.descendants.map (desc, index) ->
            if desc.states.focused
                desc.animate 'default'
        
        @focusedElement = {}