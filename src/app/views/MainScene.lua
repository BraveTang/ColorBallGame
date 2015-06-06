--requier "LevelScene"
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local LevelScene = import(".LevelScene")
MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    local s = cc.Director:getInstance():getWinSize()
    printf("s.height = %d\n",s.height)
    printf("s.width = %d\n",s.width)
    
    --add main menu items
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=46
    local playLabel = cc.Label:createWithTTF(ttfConfig,"free play", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
    local settingLabel = cc.Label:createWithTTF(ttfConfig,"setting", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
    local aboutLabel = cc.Label:createWithTTF(ttfConfig,"about", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
   
    local function playMenuItemCallBack()
--        cclog("selected item: tag: %d, index:%d", tag, sender:getSelectedIndex() ) 
        self:getApp():enterScene("LevelScene", "fade", 1.0) 
       -- local levelScene = LevelScene:create()
        
        --cc.Director:getInstance():replaceScene(cc.TransitionFade:create(1, levelScene))
    end
    
    local playMenuItem = cc.MenuItemLabel:create(playLabel)
    playMenuItem:setColor(cc.c4b(255,255,255,255))
    playMenuItem:setDisabledColor(cc.c4b(255,255,0,255))
    playMenuItem:registerScriptTapHandler(playMenuItemCallBack)
    
    local settingMenuItem = cc.MenuItemLabel:create(settingLabel)    
    settingMenuItem:setColor(cc.c4b(255,255,255,255))
    settingMenuItem:setDisabledColor(cc.c4b(255,255,0,255))
    local aboutMenuItem = cc.MenuItemLabel:create(aboutLabel)    
    aboutMenuItem:setColor(cc.c4b(255,255,255,255))
    aboutMenuItem:setDisabledColor(cc.c4b(255,255,0,255))
    
    local mainMenu = cc.Menu:create()
    mainMenu:addChild(playMenuItem)  
    mainMenu:addChild(settingMenuItem) 
    mainMenu:addChild(aboutMenuItem)
    mainMenu:alignItemsVertically()
    
    self:addChild(mainMenu)
end
function MainScene:onEnter()

    print("MainScene onEnter")
	
end
return MainScene
