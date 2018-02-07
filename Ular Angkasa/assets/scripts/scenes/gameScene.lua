GameScene = {}
    GameScene.initialize = function()
        -- ------------------------------------------------------------------------ the grid
        GameScene.Grid = {}
            GameScene.GridSize = 10
            GameScene.GridColumn = math.floor( (love.graphics.getWidth() / GameScene.GridSize) - 1)
            GameScene.GridRow = math.floor( (love.graphics.getHeight() / GameScene.GridSize) - 1)
            for a = 1, GameScene.GridColumn do
                GameScene.Grid[a] = {}
                for b = 1, GameScene.GridRow do
                    GameScene.Grid[a][b] = {}
                    GameScene.Grid[a][b].x = (a) * GameScene.GridSize
                    GameScene.Grid[a][b].y = (b) * GameScene.GridSize
                    GameScene.Grid[a][b].member = 0
                end
            end
            GameScene.GridChecked = {0, 0}
        -- ------------------------------------------------------------------------ variables
        GameScene.TailsMax = GameScene.GridColumn * GameScene.GridRow
        GameScene.TailsActive = 10
        GameScene.Score = 0
        GameScene.Health = 3
        GameScene.EnemyStartIndex = math.floor(GameScene.TailsMax + 2)
        GameScene.EnemyEndIndex = GameScene.EnemyStartIndex + 5
        -- ----------------------------------------------------- game objects
        GameScene.GameObjects = {}
        -- player
        GameScene.GameObjects[1] = createGameObject(
            true,
            "Player",
            ImagePlayer,
            46,
            45,
            0,1,1,
            ImagePlayer:getWidth()/2,
            ImagePlayer:getHeight()/2,
            1
        )
        GameScene.GameObjects[1].animation = true
        GameScene.GameObjects[1].animator = createScalingAnimator(
                GameScene.GameObjects[1],true,
                0.75,0.95,
                1,1,0.05
        )
        GameScene.GameObjects[1].moveUp = true
        GameScene.GameObjects[1].moveDown = false
        GameScene.GameObjects[1].moveLeft = false
        GameScene.GameObjects[1].moveRight = false
        GameScene.GameObjects[1].behaviour = function()
            if GameScene.GameObjects[1].moveUp and GameScene.GameObjects[1].positionY > 1 then
                GameScene.GameObjects[1].previousX = GameScene.GameObjects[1].positionX
                GameScene.GameObjects[1].previousY = GameScene.GameObjects[1].positionY
                GameScene.GameObjects[1].positionY = GameScene.GameObjects[1].positionY - 1
                GameScene.GameObjects[1].rotation = 0
            elseif GameScene.GameObjects[1].moveDown and GameScene.GameObjects[1].positionY < GameScene.GridRow then
                GameScene.GameObjects[1].previousX = GameScene.GameObjects[1].positionX
                GameScene.GameObjects[1].previousY = GameScene.GameObjects[1].positionY
                GameScene.GameObjects[1].positionY = GameScene.GameObjects[1].positionY + 1
                GameScene.GameObjects[1].rotation = 3.14
            elseif GameScene.GameObjects[1].moveLeft and GameScene.GameObjects[1].positionX > 1 then
                GameScene.GameObjects[1].previousX = GameScene.GameObjects[1].positionX
                GameScene.GameObjects[1].previousY = GameScene.GameObjects[1].positionY
                GameScene.GameObjects[1].positionX = GameScene.GameObjects[1].positionX - 1
                GameScene.GameObjects[1].rotation = -1.57
            elseif GameScene.GameObjects[1].moveRight and GameScene.GameObjects[1].positionX < GameScene.GridColumn then
                GameScene.GameObjects[1].previousX = GameScene.GameObjects[1].positionX
                GameScene.GameObjects[1].previousY = GameScene.GameObjects[1].positionY
                GameScene.GameObjects[1].positionX = GameScene.GameObjects[1].positionX + 1
                GameScene.GameObjects[1].rotation = 1.57
            else
                GameScene.GameObjects[1].moveUp, GameScene.GameObjects[1].moveDown, GameScene.GameObjects[1].moveLeft, GameScene.GameObjects[1].moveRight = false, false, false, false
            end
            if GameScene.CollisionDetected(GameScene.GameObjects[1].previousX, GameScene.GameObjects[1].previousY) > 0 then
                GameScene.DecreaseHealth()
            end
        end
        -- tails
        for a = 2, GameScene.TailsMax + 1 do
            GameScene.GameObjects[a] = createGameObject(
                false,
                "Tail",
                ImageTail,
                GameScene.GameObjects[a-1].positionX,
                GameScene.GameObjects[a-1].positionY,
                0,1,1,
                ImageTail:getWidth()/2,
                ImageTail:getHeight()/2
            )
            GameScene.GameObjects[a].index = a
            GameScene.GameObjects[a].parent = a - 1
            GameScene.GameObjects[a].behaviour = function()
                GameScene.GameObjects[a].previousX = GameScene.GameObjects[a].positionX
                GameScene.GameObjects[a].previousY = GameScene.GameObjects[a].positionY
                GameScene.GameObjects[a].positionX = GameScene.GameObjects[GameScene.GameObjects[a].parent].previousX
                GameScene.GameObjects[a].positionY = GameScene.GameObjects[GameScene.GameObjects[a].parent].previousY
                if GameScene.GameObjects[a].positionX ~= GameScene.GridChecked[1] or GameScene.GameObjects[a].positionY ~= GameScene.GridChecked[2] then
                    local hitEnemy = GameScene.CollisionDetected(GameScene.GameObjects[a].positionX, GameScene.GameObjects[a].positionY)
                    if hitEnemy > 0 then
                        GameScene.AddTail(hitEnemy)
                    end
                end
            end
            if(a < GameScene.TailsActive + 2) then
                GameScene.GameObjects[a].active = true
            end
        end
        -- enemies
        for a = GameScene.EnemyStartIndex, GameScene.EnemyStartIndex + 5 do
            GameScene.GameObjects[a] = GameScene.SpawnEnemy(a)
        end
        -- ------------------------------------------------------------------------
        GameScene.ScoreEffectTimer = 0
        GameScene.ScoreEffectPosition = {0,0}
        GameScene.ScoreEffectType = 1
        love.graphics.setFont (FontOCRAEXT2)
    end

    -- ---------------------------------------------------------------------------- main functions

    GameScene.draw = function()
        GameScene.setBackground()
        GameScene.drawImages()
        GameScene.drawUI()
    end

    GameScene.update = function(dt)
        --
    end

    GameScene.listenerKeyPressed = function (key)
        if key == "escape" then
            GameScene.GameOver()
        elseif key == "left" then
            SfxMove:stop()
            SfxMove:play()
            GameScene.GameObjects[1].moveLeft = true
            GameScene.GameObjects[1].moveRight, GameScene.GameObjects[1].moveUp, GameScene.GameObjects[1].moveDown = false, false, false
        elseif key == "right" then
            SfxMove:stop()
            SfxMove:play()
            GameScene.GameObjects[1].moveRight = true
            GameScene.GameObjects[1].moveLeft, GameScene.GameObjects[1].moveUp, GameScene.GameObjects[1].moveDown = false, false, false
        elseif key == "up" then
            SfxMove:stop()
            SfxMove:play()
            GameScene.GameObjects[1].moveUp = true
            GameScene.GameObjects[1].moveRight, GameScene.GameObjects[1].moveLeft, GameScene.GameObjects[1].moveDown = false, false, false
        elseif key == "down" then
            SfxMove:stop()
            SfxMove:play()
            GameScene.GameObjects[1].moveDown = true
            GameScene.GameObjects[1].moveRight, GameScene.GameObjects[1].moveUp, GameScene.GameObjects[1].moveLeft = false, false, false
        end
    end

    GameScene.listenerMousePressed = function (x, y, button, istouch )
    end

    GameScene.listenerMouseMoved = function (x, y, button, istouch )
    end

    GameScene.listenerMouseReleased = function (x, y, button, istouch )
    end

    GameScene.listenerTouchPressed = function (id, x, y, dx, dy, pressure)
    end

    GameScene.listenerTouchReleased = function (id, x, y, dx, dy, pressure)
    end

    GameScene.listenerTouchMoved = function (id, x, y, dx, dy, pressure)
    end

    -- ---------------------------------------------------------------------------- other functions

    GameScene.setBackground = function()
        love.graphics.setColor( math.abs( math.sin( love.timer.getTime() ) * 60 ), 0, 50, 255)
        love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(255,255,255,255)
        local coefficientX = (GameScene.Grid[GameScene.GameObjects[1].positionX][GameScene.GameObjects[1].positionY].x - love.graphics.getWidth()/2) / love.graphics.getWidth()/2
        local coefficientY = (GameScene.Grid[GameScene.GameObjects[1].positionX][GameScene.GameObjects[1].positionY].y - love.graphics.getHeight()/2) / love.graphics.getHeight()/2
        love.graphics.draw(ImageBackground3, love.graphics.getWidth()/2 + (coefficientX * 50),love.graphics.getHeight()/2 + (coefficientY * 50),0,1,1,ImageBackground3:getWidth()/2,ImageBackground3:getHeight()/2)
        love.graphics.draw(ImageBackground2, love.graphics.getWidth()/2 + (coefficientX * 100),love.graphics.getHeight()/2 + (coefficientY * 100),0,1,1,ImageBackground2:getWidth()/2,ImageBackground2:getHeight()/2)
        love.graphics.draw(ImageBackground1, love.graphics.getWidth()/2 + (coefficientX * 200),love.graphics.getHeight()/2 + (coefficientY * 200),0,1,1,ImageBackground1:getWidth()/2,ImageBackground1:getHeight()/2)

        love.graphics.setColor(255,255,255,20)
        for a = 1, GameScene.GridColumn do
            for b = 1, GameScene.GridRow do
                love.graphics.rectangle( "line", GameScene.Grid[a][b].x-(GameScene.GridSize/2), GameScene.Grid[a][b].y-(GameScene.GridSize/2), GameScene.GridSize, GameScene.GridSize)
            end
        end
        love.graphics.setColor(255,255,255)
    end

    GameScene.drawImages = function ()
        if GameScene.GameObjects then
            for a,b in ipairs(GameScene.GameObjects) do
                if b.active then
                    love.graphics.draw(b.image,GameScene.Grid[b.positionX][b.positionY].x ,GameScene.Grid[b.positionX][b.positionY].y,b.rotation,b.scaleX,b.scaleY,b.offsetX,b.offsetY)
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

    GameScene.drawUI = function ()
        if GameScene.ScoreEffectTimer > 0 then
            GameScene.ScoreEffectTimer = GameScene.ScoreEffectTimer - love.timer.getDelta()
            love.graphics.draw(ImageScore[GameScene.ScoreEffectType], GameScene.Grid[GameScene.ScoreEffectPosition[1]][GameScene.ScoreEffectPosition[2]].x, GameScene.Grid[GameScene.ScoreEffectPosition[1]][GameScene.ScoreEffectPosition[2]].y,0,0.5+GameScene.ScoreEffectTimer,0.5+GameScene.ScoreEffectTimer,ImageScore[GameScene.ScoreEffectType]:getWidth()/2,ImageScore[GameScene.ScoreEffectType]:getHeight()/2)
        end
        local text =  "Score :" .. string.format( "\n%d", GameScene.Score)
        love.graphics.printf(text, love.graphics.getWidth()/2, 20, 250,"center",0,1,1,125,0) -- score
        local text_ =  "Health :" .. string.format( " %d", GameScene.Health)
        love.graphics.printf(text_, love.graphics.getWidth()/2, love.graphics.getHeight()-20, 250,"center",0,1,1,125,50) -- score
    end

    GameScene.AddTail = function(enemyIndex)
        SfxScore:stop()
        SfxScore:play()
        GameScene.AddScore(enemyIndex)
        if(GameScene.TailsActive < GameScene.TailsMax - 1) then
            GameScene.TailsActive = GameScene.TailsActive + 1
            GameScene.GameObjects[GameScene.TailsActive + 1].active = true
            GameScene.GameObjects[GameScene.TailsActive + 1].positionX = GameScene.GameObjects[GameScene.GameObjects[GameScene.TailsActive + 1].parent].positionX
            GameScene.GameObjects[GameScene.TailsActive + 1].positionY = GameScene.GameObjects[GameScene.GameObjects[GameScene.TailsActive + 1].parent].positionY
        end
        GameScene.GameObjects[enemyIndex].reset()
    end

    GameScene.AddScore = function(enemyIndex)
        GameScene.ScoreEffectPosition = {GameScene.GameObjects[enemyIndex].positionX, GameScene.GameObjects[enemyIndex].positionY}
        GameScene.ScoreEffectTimer = 0.5
        GameScene.ScoreEffectType = GameScene.GameObjects[enemyIndex].type
        if GameScene.ScoreEffectType == 1 then
            GameScene.Score = GameScene.Score + 10
        elseif GameScene.ScoreEffectType == 2 then
            GameScene.Score = GameScene.Score + 15
        else
            GameScene.Score = GameScene.Score + 20
        end
    end

    GameScene.DecreaseHealth = function()
        SfxExplode:stop()
        SfxExplode:play()
        if GameScene.Health > 0 then
            GameScene.Health = GameScene.Health - 1
        else
            GameScene.GameOver()
        end
        SlowMotionActive = true
    end

    GameScene.SpawnEnemy = function(index)
        local enemy = {}
        local type = math.random( 1, 3)
        local pos = GameScene.GetRandomPosition(type)
        enemy = createGameObject(
            true,
            "Enemy",
            ImageEnemies[type],
            pos[1],
            pos[2],
            0,1,1,
            ImageEnemies[type]:getWidth()/2,
            ImageEnemies[type]:getHeight()/2
        )
        enemy.index = index
        enemy.animation = true
        enemy.animator = createScalingAnimator(
                enemy,true,
                0.75,0.75,
                1,1,0.05
        )
        enemy.type = type
        enemy.target = GameScene.GetRandomTargetPosition()
        enemy.reset = function()
            local type = math.random( 1, 3)
            local pos = GameScene.GetRandomPosition(type)
            
            enemy.type = type
            enemy.positionX = pos[1]
            enemy.positionY = pos[2]
            enemy.target = GameScene.GetRandomTargetPosition()
            enemy.image = ImageEnemies[type]

            GameScene.EnemyEndIndex = GameScene.EnemyEndIndex + 1
            GameScene.GameObjects[GameScene.EnemyEndIndex] = GameScene.SpawnEnemy(GameScene.EnemyEndIndex)
        end
        enemy.behaviour = function()
            GameScene.ClearGrid(enemy.positionX, enemy.positionY)
            if enemy.positionX ~= enemy.target[1] then
                if enemy.positionX < enemy.target[1] then
                    enemy.positionX = enemy.positionX + 1
                else
                    enemy.positionX = enemy.positionX - 1
                end
            end
            if enemy.positionY ~= enemy.target[2] then
                if enemy.positionY < enemy.target[2] then
                    enemy.positionY = enemy.positionY + 1
                else
                    enemy.positionY = enemy.positionY - 1
                end
            end
            if enemy.positionX == enemy.target[1] and enemy.positionY == enemy.target[2] then
                enemy.target = GameScene.GetRandomTargetPosition()
            end
            GameScene.RegisterGrid(enemy.positionX, enemy.positionY, enemy.index)
        end
        return enemy
    end

    GameScene.GetRandomPosition = function(index)
        if index == 1 then
            return {1, math.random( 1, GameScene.GridRow )}
        elseif index == 2 then
            return {math.random( 1, GameScene.GridColumn ), 1}
        elseif index == 3 then
            return {GameScene.GridColumn, math.random( 1, GameScene.GridRow )}
        else
            return {1, 1}
        end
    end

    GameScene.GetRandomTargetPosition = function()
        return {math.random( 1, GameScene.GridColumn ), math.random( 1, GameScene.GridRow )}
    end

    GameScene.RegisterGrid = function(column, row, index)
        GameScene.Grid[column][row].member = index
    end

    GameScene.ClearGrid = function(column, row)
        GameScene.Grid[column][row].member = 0
    end

    GameScene.CollisionDetected = function(column, row)
        GameScene.GridChecked[1] = column
        GameScene.GridChecked[2] = row
        if GameScene.Grid[column][row].member ~= 0 then
            local returnValue = GameScene.Grid[column][row].member
            GameScene.Grid[column][row].member = 0
            return returnValue
        else
            return 0
        end
    end

    GameScene.GameOver = function()
        BgSoundGameplay:stop()
        SfxOver:play()
        BgSoundMainMenu:play()
        changeScene(4)
    end