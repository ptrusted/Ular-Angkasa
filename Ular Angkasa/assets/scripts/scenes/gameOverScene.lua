GameOverScene = {}
    GameOverScene.initialize = function ()
        -- ----------------------------------------------------- game objects
        GameOverScene.gameObjects = {}
        
        -- use these codes to create a sprite animation and assign it to game object :
            -- GameOverScene.gameObjects[1].animation = false
            -- GameOverScene.gameObjects[1].animator = createSpriteAnimator(GameOverScene.gameObjects[1],0.05,false,AnimationImages,1,31,Sfx)
        GameOverScene.HighscoreCalculated = false
        GameOverScene.ScoreToPrint = ""
        GameOverScene.HighScoreToPrint = ""
    end
    -- ---------------------------------------------------------------------------- main functions

    GameOverScene.draw = function ()
        GameOverScene.drawBackground()
        GameOverScene.drawImages()
        GameOverScene.drawUI()
    end

    GameOverScene.update = function (dt)
        
    end

    GameOverScene.listenerKeyPressed = function (key)
        if key == "escape" then
            SfxStart:play()
            changeScene(2)
        end
    end

    GameOverScene.listenerMousePressed = function (x, y, button, istouch )
        
    end

    GameOverScene.listenerMouseMoved = function (x, y, button, istouch )
    end

    GameOverScene.listenerMouseReleased = function (x, y, button, istouch )
    end

    GameOverScene.listenerTouchPressed = function (id, x, y, dx, dy, pressure)
        
    end

    GameOverScene.listenerTouchReleased = function (id, x, y, dx, dy, pressure)

    end

    GameOverScene.listenerTouchMoved = function (id, x, y, dx, dy, pressure)

    end

    -- ---------------------------------------------------------------------------- other functions

    GameOverScene.drawBackground = function ()
        local red = math.abs( math.sin( 5 * love.timer.getTime() ) * 125 )
        love.graphics.setColor(red, 35, 60, 255)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    GameOverScene.drawImages = function ()
        love.graphics.setColor(255,255,255,255)
        if GameOverScene.gameObjects then
            for a,b in ipairs(GameOverScene.gameObjects) do
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

    GameOverScene.drawUI = function ()
        love.graphics.setColor(255,255,255)

        if not GameOverScene.HighscoreCalculated then
            GameOverScene.highScoreCalculator()
            saveProgress()
            GameOverScene.HighscoreCalculated = true
        end

        local interval = math.abs( math.sin( 5.5 * love.timer.getTime() )) / 10
        love.graphics.draw(ImageBox3, love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,1 - interval,1 - interval,ImageBox3:getWidth()/2,ImageBox3:getHeight()/2)

        love.graphics.setColor(255,255,255)

        love.graphics.setFont (FontOCRAEXT3)
        love.graphics.printf(GameOverScene.ScoreToPrint, love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 200, 1000,"center",0,1,1,500,0) -- score

        love.graphics.setFont (FontOCRAEXT2)
        love.graphics.printf(GameOverScene.HighScoreToPrint, love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 50, 1000,"center",0,1,1,500,0) -- high score
    end

    GameOverScene.highScoreCalculator = function ()
        GameOverScene.ScoreToPrint = string.format( "\t%d\t", GameScene.Score)

        local recentScore = 0
        local rankHasBeenSet = false
        local rank = ""
        for a=1,#Highscore do
            if GameScene.Score > Highscore[a] and not rankHasBeenSet then
                rankHasBeenSet = true
                recentScore = Highscore[a]
                Highscore[a] = GameScene.Score
                rank = a
            elseif recentScore > 0 then
                local temp = Highscore[a]
                Highscore[a] = recentScore
                recentScore = temp
            end
        end

        GameOverScene.HighScoreToPrint = ""
        for a=1,#Highscore do
            if a == rank then
                GameOverScene.HighScoreToPrint = GameOverScene.HighScoreToPrint .. "(" .. a .. string.format( ".) %d new record !!!\n",Highscore[a])
            else
                GameOverScene.HighScoreToPrint = GameOverScene.HighScoreToPrint .. "(" .. a .. string.format( ".) %d\n",Highscore[a])
            end
        end
    end