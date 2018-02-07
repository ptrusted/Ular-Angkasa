SplashScene = {}

    SplashScene.initialize = function()
    -- ------------------------------------------------------------------------
        SplashScene.gameObjects = {}
        SplashScene.gameObjects[1] = createGameObject(
            true,
            "splash icon",
            ImagesSplash[1],
            love.graphics.getWidth()/2,
            love.graphics.getHeight()/2,
            0,1,1,
            ImagesSplash[1]:getWidth()/2,
            ImagesSplash[1]:getHeight()/2,
            1
        )
        SplashScene.gameObjects[1].animation = false
        SplashScene.gameObjects[1].animator = createSpriteAnimator(SplashScene.gameObjects[1],0.05,false,ImagesSplash,1,31,SfxSplash)
    -- ------------------------------------------------------------------------

        -- this is a LUA coroutine feature used to execute some sequenced operation.
        SplashScene.usingTimer = true
        SplashScene.sequenceExecution = coroutine.create(
            function ()
                SplashScene.gameObjects[1].animator.play(1,31)
                coroutine.yield(4.0) -- delay in seconds
                changeScene(2) -- operation 2
                BgSoundMainMenu:play()
            end
        )
    end

    -- ---------------------------------------------------------------------------- main functions

    SplashScene.draw = function()
        SplashScene.setBackground()
        SplashScene.drawImages()
    end

    SplashScene.update = function()
    end

    SplashScene.listenerKeyPressed = function (key)
    end

    SplashScene.listenerMousePressed = function (x, y, button, istouch )
    end

    SplashScene.listenerMouseMoved = function (x, y, button, istouch )
    end

    SplashScene.listenerMouseReleased = function (x, y, button, istouch )
    end

    SplashScene.listenerTouchPressed = function (id, x, y, dx, dy, pressure)
    end

    SplashScene.listenerTouchReleased = function (id, x, y, dx, dy, pressure)
    end

    SplashScene.listenerTouchMoved = function (id, x, y, dx, dy, pressure)
    end

    -- ---------------------------------------------------------------------------- other functions

    SplashScene.setBackground = function()
        love.graphics.setBackgroundColor( 255, 255, 255 )
    end

    SplashScene.drawImages = function ()
        if SplashScene.gameObjects then
            for a,b in ipairs(SplashScene.gameObjects) do
                if b.active then
                    love.graphics.draw(b.image, b.positionX ,b.positionY,b.rotation,b.scaleX,b.scaleY,b.offsetX,b.offsetY)
                    if b.animation and b.animator then
                        b.animator.updateAnimator()
                    end
                    if b.behaviour then
                        b.behaviour()
                    end
                end
            end
        end
    end