function loadShaderEffects()
    DefaultShader = love.graphics.getShader() -- save the default shader, to be used later 

    ShaderEffects = {} -- table contains all made shaders
    -- --------------------------------------------------------------------------------------------------------------------------------------------
            -- ------------------------------------------------------------
            -- shader number 1, gives red overlay around player.
            ShaderEffects[1] = {}
            ShaderEffects[1].theScript = love.graphics.newShader [[
                //uniform number time;
                uniform vec2 pos;
                vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
                {
                    float distanceToPlayer = distance(pixel_coords,pos);
                    float radius = 250.0;

                    return color * texture2D(texture,texture_coords) + vec4(((1.0 - color.r) * (distanceToPlayer / radius)) + 0.1,0.1,0.1,0.1);
                }
            ]]
            ShaderEffects[1].update = function () -- sending the parameter value to shader code, called every frame
                --ShaderEffects[CurrentShaderEffect].theScript:send("time",love.timer.getTime())
                ShaderEffects[CurrentShaderEffect].theScript:send("pos",{ GameScene.Grid[GameScene.GameObjects[1].positionX][GameScene.GameObjects[1].positionY].x , GameScene.Grid[GameScene.GameObjects[1].positionX][GameScene.GameObjects[1].positionY].y})
            end

            -- ------------------------------------------------------------
            -- shader number 2, gives a glitch effect
            ShaderEffects[2] = {}
            ShaderEffects[2].theScript = love.graphics.newShader [[
                uniform vec2 randomValue;
                vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
                {
                    // it returns the fragment of neighbours and added a random color based on random value given every frame.
                    return color * texture2D(texture,vec2(texture_coords.x+randomValue.x,texture_coords.y+randomValue.y)) *
                        vec4(randomValue.x,randomValue.y,randomValue.x,abs(randomValue.y));
                }
            ]]
            ShaderEffects[2].update = function () -- sending the parameter value of random integer to shader code, called every frame
                local x,y = math.random(-1,1),math.random(-1,1)
                ShaderEffects[CurrentShaderEffect].theScript:send("randomValue",{x,y})
            end

    -- --------------------------------------------------------------------------------------------------------------------------------------------

    CurrentShaderEffect = 0
    -- -----------------------------------------------------------------
end