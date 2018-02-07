function love.conf(t)
    t.window.title = "Ular Angkasa"
    t.window.fullscreen = true
    t.window.fullscreentype = "exclusive"
    t.window.width = 1366
    t.window.height = 768
    t.console = true
    t.modules.physics = false
    t.modules.touch = false
    love.filesystem.setIdentity("Ular_Angkasa")
end