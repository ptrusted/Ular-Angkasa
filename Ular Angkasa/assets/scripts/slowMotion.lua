function loadSlowMotionEffect()
    -- slow motion constant and flag.
    SlowMotionScale = 1 / 10
    SlowMotionTimer = 1.0
    SlowMotionTimerCounter = SlowMotionTimer
    SlowMotionActive = false
end

function slowMotionEffectSwitcher()
    if SlowMotionActive then
        if SlowMotionTimerCounter > 0 then
            CurrentShaderEffect = 1
            SlowMotionTimerCounter = SlowMotionTimerCounter - love.timer.getDelta()
            love.timer.sleep(SlowMotionScale - love.timer.getDelta())
        else
            CurrentShaderEffect = 0
            SlowMotionTimerCounter = SlowMotionTimer
            SlowMotionActive = false
        end
    end
end