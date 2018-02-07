MainMenuScene = {}
    MainMenuScene.initialize = function ()
        -- ----------------------------------------------------- game objects
        MainMenuScene.gameObjects = {}
        MainMenuScene.gameObjects[1] = createGameObject(
            true,
            "name",
            ImageTitle,
            love.graphics.getWidth()/2,
            love.graphics.getHeight()/2,
            0,ScreenScaleFactor,ScreenScaleFactor,
            ImageTitle:getWidth()/2,
            ImageTitle:getHeight()/2,
            1
        )
        MainMenuScene.gameObjects[1].animation = true
        MainMenuScene.gameObjects[1].animator = createScalingAnimator(
                MainMenuScene.gameObjects[1],true,
                ScreenScaleFactor-0.1,ScreenScaleFactor-0.05,
                ScreenScaleFactor,ScreenScaleFactor,0.005)

        -- use these codes to create a sprite animation and assign it to game object :
            -- MainMenuScene.gameObjects[1].animation = false
            -- MainMenuScene.gameObjects[1].animator = createSpriteAnimator(MainMenuScene.gameObjects[1],0.05,false,AnimationImages,1,31,Sfx)
        love.graphics.setFont (FontOCRAEXT1)
    end
    -- ---------------------------------------------------------------------------- main functions

    MainMenuScene.draw = function ()
        MainMenuScene.drawBackground()
        MainMenuScene.drawImages()
        MainMenuScene.drawUI()
    end

    MainMenuScene.update = function (dt)
        
    end

    MainMenuScene.listenerKeyPressed = function (key)
        if key == "escape" then
            love.event.quit()
        elseif key == 'return' or key == 'space' or key == 'up' or key == 'down' or key == 'left' or key == 'right' then
            BgSoundMainMenu:stop()
            SfxStart:play()
            BgSoundGameplay:play()
            changeScene(3)
        end
    end

    MainMenuScene.listenerMousePressed = function (x, y, button, istouch )
        
    end

    MainMenuScene.listenerMouseMoved = function (x, y, button, istouch )
    end

    MainMenuScene.listenerMouseReleased = function (x, y, button, istouch )
    end

    MainMenuScene.listenerTouchPressed = function (id, x, y, dx, dy, pressure)
        
    end

    MainMenuScene.listenerTouchReleased = function (id, x, y, dx, dy, pressure)

    end

    MainMenuScene.listenerTouchMoved = function (id, x, y, dx, dy, pressure)

    end

    -- ---------------------------------------------------------------------------- other functions

    MainMenuScene.drawBackground = function ()
        local red = math.abs( math.sin( love.timer.getTime() ) * 90 )
        local blue = math.abs( math.sin( love.timer.getTime() ) * 90 )
        love.graphics.setColor(red, 0, 41, 255)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(70, 0, blue, 255)
        love.graphics.circle( "fill",
            love.graphics.getWidth()/2, love.graphics.getHeight()/2,
            math.abs(love.graphics.getWidth()/2*math.cos(love.timer.getTime()))
            )
        love.graphics.setColor(255,255,255)
        love.graphics.draw(ImageBox1, love.graphics.getWidth()/2,0,0,1,1,ImageBox1:getWidth()/2,0)
        love.graphics.draw(ImageBox2, love.graphics.getWidth()/2,love.graphics.getHeight(),0,1,1,ImageBox2:getWidth()/2,ImageBox2:getHeight())
    end

    MainMenuScene.drawImages = function ()
        love.graphics.setColor(255,255,255,255)
        if MainMenuScene.gameObjects then
            for a,b in ipairs(MainMenuScene.gameObjects) do
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

    MainMenuScene.drawUI = function ()
        love.graphics.setColor(30,30,30)
        local highScoreToPrint ='-------- HIGH SCORES --------\n'
        for a=1,#Highscore do
            highScoreToPrint = highScoreToPrint .. "(" ..  a .. string.format( ".) %d\t",Highscore[a])
        end
        love.graphics.printf(highScoreToPrint, love.graphics.getWidth()/2, love.graphics.getHeight(), 1200,"center",0,1,1,600,55) -- score
        love.graphics.printf(
            "Use arrow keys to move. Destroy enemies by touching it with tail. Each enemy destroyed will spawns two new enemies and longer tail. Red enemy valued 10 score points, blue 15 points, and green 20 points. Losing health if the head hits enemy. Game over if (escape) button pressed."
            , love.graphics.getWidth()/2, 10, 900,"center",0,1,1,450,0) -- info
    end