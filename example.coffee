# A more thorough introduction of this module can be found here:
# https://blog.framer.com/introducing-framer-joystick-28359287bef0

class CardCarousel extends ScrollComponent
    constructor: (properties={}) ->
        super properties

        @content.clip = properties.clip;

        app.on 'change:focusedElement', (focusable) =>
            if focusable && focusable.parent == @content
                @scrollToCard focusable

    scrollToCard: (focusable) ->
        if (focusable.screenFrame.x + focusable.screenFrame.width) > (@screenFrame.x + @screenFrame.width)
            @scrollToLayer(focusable, 1, 0, true)
        else if focusable.screenFrame.x < @screenFrame.x
            @scrollToLayer(focusable, 0, 0, true)

homeView = new View
    background:
        backgroundColor: '#eaeaea'

app = new App

scroller = new CardCarousel
    parent: homeView.safezone
    width: homeView.safezone.width
    height: Grid.getHeight(35)
    y: Align.center
    clip: false

for index in [0..5]
    new Focusable
        parent: scroller.content
        width: Grid.getWidth(6)
        height: Grid.getHeight(35)
        x: index * Grid.getWidth(7)
        backgroundColor: '#fff'
        focusProperties:
            backgroundColor: '#00ffdd'
            scale: 1.1
            animationOptions:
                time: .2
        animationOptions:
            time: .2

app.transitionToView(homeView)