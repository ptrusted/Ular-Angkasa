
function createSpriteAnimator(object,delay,loopable,animTable,startFrame,endFrame,soundEffect)
   local animator = {}
    animator.gameObject = object
    animator.delay = delay
    animator.timer = -0.1
    animator.loopable = loopable
    animator.animTable = animTable
    animator.startFrame = startFrame
    animator.endFrame = endFrame
    animator.currentFrame = startFrame
    animator.soundEffect = soundEffect
    animator.updateAnimator = function ()
        if animator.gameObject.animation then
            if animator.timer < 0 then
                if animator.currentFrame == animator.startFrame and animator.soundEffect then
                    animator.soundEffect:stop()
                    animator.soundEffect:play()
                end
                if animator.currentFrame < animator.endFrame then
                    animator.currentFrame = animator.currentFrame + 1
                    animator.gameObject.image = animator.animTable[animator.currentFrame]
                else
                    if loopable then
                        animator.currentFrame = animator.startFrame
                        animator.gameObject.image = animator.animTable[animator.currentFrame]
                    else
                        animator.gameObject.animation = false
                    end
                end
                animator.timer = animator.delay
            else
                animator.timer = animator.timer - love.timer.getDelta()
            end
        end
    end
    animator.play = function (startIndex,endIndex)
        animator.startFrame = startIndex
        animator.currentFrame = startIndex
        animator.endFrame = endIndex
        animator.gameObject.image = animator.animTable[animator.currentFrame]
        animator.gameObject.animation = true
    end

    return animator
end

function createScalingAnimator(object,scaleToMax,minScaleX,minScaleY,maxScaleX,maxScaleY,speed)
    local animator = {}
    animator.gameObject = object
    animator.scaleToMax = scaleToMax
    animator.minScaleX = minScaleX
    animator.minScaleY = minScaleY
    animator.maxScaleX = maxScaleX
    animator.maxScaleY = maxScaleY
    animator.speed = speed
    
    animator.updateAnimator = function ()
        if not animator.scaleToMax then
            if animator.gameObject.scaleX > animator.minScaleX then
                animator.gameObject.scaleX = animator.gameObject.scaleX - animator.speed
            end
            if animator.gameObject.scaleY > animator.minScaleY then
                animator.gameObject.scaleY = animator.gameObject.scaleY - animator.speed
            end
            if animator.gameObject.scaleX <= animator.minScaleX and animator.gameObject.scaleY <= animator.minScaleY then
                animator.scaleToMax = true
            end
        else
            if animator.gameObject.scaleX < animator.maxScaleX then
                animator.gameObject.scaleX = animator.gameObject.scaleX + animator.speed
            end
            if animator.gameObject.scaleY < animator.maxScaleY then
                animator.gameObject.scaleY = animator.gameObject.scaleY + animator.speed
            end
            if animator.gameObject.scaleX >= animator.maxScaleX and animator.gameObject.scaleY >= animator.maxScaleY then
                animator.scaleToMax = false
            end
        end
            
    end

    return animator
end

function createMovingAnimator(object,loopable,defaultPosX,defaultPosY,targetPosX,targetPosY,speed,resetAfterFinish)
    local animator = {}
    animator.gameObject = object
    animator.loopable = loopable
    animator.defaultPosX = defaultPosX
    animator.defaultPosY = defaultPosY
    animator.stationaryPosX = defaultPosX
    animator.stationaryPosY = defaultPosY
    animator.targetPosX = targetPosX
    animator.targetPosY = targetPosY
    animator.speed = speed
    animator.resetAfterFinish = resetAfterFinish
    animator.reaching = false
    
    animator.updateAnimator = function ()
        if not animator.reaching then
            local deltaPosition = {
                (animator.targetPosX - animator.gameObject.positionX),
                (animator.targetPosY - animator.gameObject.positionY)}
            local magnitude = math.sqrt ((deltaPosition[1]*deltaPosition[1]) + (deltaPosition[2]*deltaPosition[2]))
            if magnitude <= animator.speed or magnitude == 0 then
                animator.gameObject.positionX = animator.targetPosX
                animator.gameObject.positionY = animator.targetPosY
                animator.reaching = true
            else
                local temp = {(deltaPosition[1]/magnitude*animator.speed),(deltaPosition[2]/magnitude*animator.speed)}
                animator.gameObject.positionX = animator.gameObject.positionX + temp[1]
                animator.gameObject.positionY = animator.gameObject.positionY + temp[2]
            end
        else
            if animator.loopable then
                animator.reaching = false
                local temp = {
                    animator.stationaryPosX,
                    animator.stationaryPosY
                }
                animator.stationaryPosX = animator.gameObject.positionX
                animator.stationaryPosY = animator.gameObject.positionY
                animator.targetPosX = temp[1]
                animator.targetPosY = temp[2]
            else
                animator.gameObject.animation = false
                if animator.resetAfterFinish then
                    local temp = {animator.gameObject.positionX,animator.gameObject.positionY}
                    animator.gameObject.positionX = animator.defaultPosX
                    animator.gameObject.positionY = animator.defaultPosY
                    animator.targetPosX = temp[1]
                    animator.targetPosY = temp[2]
                    animator.reaching = false
                end
            end
        end
    end

    animator.reset = function ()
        animator.gameObject.positionX = animator.defaultPosX
        animator.gameObject.positionY = animator.defaultPosY
        animator.stationaryPosX = animator.defaultPosX
        animator.stationaryPosY = animator.defaultPosY
        animator.targetPosX = animator.defaultPosX
        animator.targetPosY = animator.defaultPosY
        animator.reaching = false
    end

    return animator
end