
function loadImages ( ... )
    -- load all your images here.
    -- Splash scene.
    ImagesSplash = loadSpritesAnimImages('assets/sprites/splash/%d.png',1,31)
    -- Main menu.
    ImageTitle = love.graphics.newImage("assets/sprites/Main Menu Title.png")
    ImageBox1 = love.graphics.newImage("assets/sprites/Main Menu Box 1.png")
    ImageBox2 = love.graphics.newImage("assets/sprites/Main Menu Box 2.png")
    -- Game scene.
    ImageBackground1 = love.graphics.newImage("assets/sprites/Background.png");
    ImageBackground2 = love.graphics.newImage("assets/sprites/Background_.png");
    ImageBackground3 = love.graphics.newImage("assets/sprites/Background__.png");
    ImagePlayer = love.graphics.newImage("assets/sprites/Player.png");
    ImageTail = love.graphics.newImage("assets/sprites/Player Tail.png")
    ImageEnemies = {}
    ImageEnemies[1] = love.graphics.newImage("assets/sprites/Enemy 1.png")
    ImageEnemies[2] = love.graphics.newImage("assets/sprites/Enemy 2.png")
    ImageEnemies[3] = love.graphics.newImage("assets/sprites/Enemy 3.png")
    ImageScore = {}
    ImageScore[1] = love.graphics.newImage("assets/sprites/Score 1.png")
    ImageScore[2] = love.graphics.newImage("assets/sprites/Score 2.png")
    ImageScore[3] = love.graphics.newImage("assets/sprites/Score 3.png")
    -- Game over scene
    ImageBox3 = love.graphics.newImage("assets/sprites/Game Over Box.png")

    -- use this code to load a single image : ImageTitle = love.graphics.newImage("assets/sprites/title.png")
    -- use this code to load animation images (all your images should be named 1.png, 2.png, etc...) : ImagesSplash = loadSpritesAnimImages('assets/sprites/splash/%d.png',1,31)
    
end

function loadSounds ( ... )
    -- load all your sounds here.
    -- Splash scene
    SfxSplash = love.audio.newSource('assets/sounds/Splash Effect.ogg','static')
    -- Main menu
    BgSoundMainMenu = love.audio.newSource('assets/sounds/Main Menu Theme.ogg','stream')
    BgSoundMainMenu:setLooping(true)
    BgSoundMainMenu:setVolume(0.75)
    SfxStart = love.audio.newSource('assets/sounds/Start Effect.ogg','static')
    -- Game scene
    BgSoundGameplay = love.audio.newSource('assets/sounds/Gameplay Theme.ogg','stream')
    BgSoundGameplay:setLooping(true)
    BgSoundGameplay:setVolume(0.85)
    SfxMove = love.audio.newSource('assets/sounds/Move Effect.ogg','static')
    SfxScore = love.audio.newSource('assets/sounds/Score Effect.ogg','static')
    SfxExplode = love.audio.newSource('assets/sounds/Explode Effect.ogg','static')
    SfxOver = love.audio.newSource('assets/sounds/Over Effect.ogg','static')

	-- use these codes to load a big sized sound :
        -- BgSoundMainMenu = love.audio.newSource('assets/sounds/main menu.mp3','stream')
        -- BgSoundMainMenu:setLooping(true)
        -- BgSoundMainMenu:setVolume(0.8)
    -- use these codes to load a small sized sound such as Sfx :
        -- SfxSelect = love.audio.newSource('assets/sounds/select.mp3','static')
        -- SfxSelect:setLooping(false)
        -- SfxSelect:setVolume(0.4)
end

function loadFonts ( ... )
    -- load all your fonts here.
    FontOCRAEXT1 = love.graphics.newFont("assets/fonts/OCRAEXT.TTF",15)
    FontOCRAEXT2 = love.graphics.newFont("assets/fonts/OCRAEXT.TTF",40)
    FontOCRAEXT3 = love.graphics.newFont("assets/fonts/OCRAEXT.TTF",100)
    love.graphics.setFont (FontOCRAEXT1)
end

function createGlobalVariables ()
    -- put all your scenes here.
    Scenes = {SplashScene, MainMenuScene, GameScene, GameOverScene}
    CounterSelectedScene = 1
    
    CounterTimer = 0
    -- this variable based on your game resolution.
    ScreenScaleFactor = love.graphics.getHeight()/800

    -- these lines are optional, needed a further tweaking to use.
    Highscore = {}
    for i=1, 5 do
        Highscore[i] = 0
    end

    loadSavedVariables()
end

-- ---------------------------------------------------------------------------- other functions

function loadSavedVariables ()
    -- if the file doesn't exist, we should create it first.
    local exist = love.filesystem.exists('data.txt')
    --print(love.filesystem.getSaveDirectory() .. '/progress.txt')
    if exist then
        -- read and pass it into proper global variables.
        local extractedData = extractDataFromFile ('data.txt','#000#')
        compareExtractedDataWithGlobalVariable(Highscore,extractedData)
    else
        -- create file.
        saveProgress()
    end
end

function loadSpritesAnimImages (nameFormat,startIndex,finishIndex)
    local theImages = {}
	for i=startIndex,finishIndex do
		theImages[i] = love.graphics.newImage(string.format(nameFormat,i))
	end

    return theImages
end

function saveProgress ()
    local FileToSave = love.filesystem.newFile('data.txt') 
    FileToSave:open('w')

    local dataToSave = ''
    for a,b in ipairs(Highscore) do
        b = b * 2 / 100 -- encode data.
        dataToSave = dataToSave .. b .. '#000#'
    end

    FileToSave:write(dataToSave)
    FileToSave:close()
end

function extractDataFromFile (fileName,parser)
    local savedData = love.filesystem.read(fileName) -- we got the data.
    local extractedData = {} -- this is where we store the extracted data.
    local dataCounter = 1
    local startIndex,endIndex = string.find(savedData,parser) -- startIndex is where we begin the search until the parser found.
    local tempIndex = 1 -- extra variable needed
    while startIndex do
        extractedData[dataCounter] = string.sub(savedData,tempIndex,startIndex-1)
        extractedData[dataCounter] = extractedData[dataCounter] / 2 * 100 -- decode data.
        dataCounter = dataCounter + 1
        tempIndex = endIndex + 1
        startIndex,endIndex = string.find(savedData,parser,tempIndex)
    end
    
    return extractedData
end

function compareExtractedDataWithGlobalVariable (globalVariable,extractedData)
    if #globalVariable == #extractedData then
        for i=1,#globalVariable do
            globalVariable[i] = tonumber(extractedData[i])
        end
        return true
    else
        for i=1,#globalVariable do
            globalVariable[i] = 0
        end
        return false
    end
end