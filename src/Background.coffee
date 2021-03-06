{Broadcaster} = require './Broadcaster.coffee'
_ = Framer._

class exports.Background extends Layer
    constructor: (properties={}) ->
        super properties

        @bgLayer = new Layer
            parent: @
            size: Screen.size
            backgroundColor: '#000'

        @gradientLayer = {}

        Broadcaster.on 'viewTransitionEvent', (view) =>
            @populateBackground(view.background)

    populateBackground: (background) ->

        tempVar = new Layer
            parent: @
            size: Screen.size
            image: background.image || null
            backgroundColor: background.backgroundColor || '#000'
            blur: background.blur || null
            opacity: 0
        
        tempVar.animate
            opacity: 1
            options:
                time: .4
            
        Utils.delay .4, =>
            @bgLayer.destroy()
            @bgLayer = tempVar