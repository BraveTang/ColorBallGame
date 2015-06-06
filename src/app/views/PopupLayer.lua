local PopupLayer = class("PopupLayer",function()
return display.newLayer(cc.c4b(0,0,0,50))end)

function PopupLayer:ctor()
    print("popupLayer")
    self:init()
end

function PopupLayer:init()
    local s = cc.Director:getInstance():getWinSize()
    
    self:setContentSize(500,300)
    self:ignoreAnchorPointForPosition(false)
    self:setAnchorPoint(cc.p(0.5,0.5))
    self:setPosition(cc.p(s.width/2,s.height/2))
    
    
    local draw = cc.DrawNode:create()
    draw:drawRect(cc.p(0,0), cc.p(500,400), cc.c4f(1,1,1,1))
    draw:setPosition(cc.p(0,0))
    draw:setContentSize(500,300)
    self:addChild(draw)
end

function PopupLayer:display(action)
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=40
    if action == "game over" then
        local label = cc.Label:createWithTTF(ttfConfig,"Game Over!", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 500)
        label:setPosition(cc.p(250,200))
        label:setColor(cc.c4b(255,255,0,255))
        self:addChild(label)
        
        local function backMenuItemCallBack()
            --        cclog("selected item: tag: %d, index:%d", tag, sender:getSelectedIndex() ) 
            self:getApp():enterScene("LevelScene")   
        end
        ttfConfig.fontSize=30
        local backLabel = cc.Label:createWithTTF(ttfConfig,"Back", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,500)
        local backMenuItem = cc.MenuItemLabel:create(backLabel)
        backMenuItem:setColor(cc.c4b(255,255,255,255))
        backMenuItem:setDisabledColor(cc.c4b(255,255,0,255))
        backMenuItem:registerScriptTapHandler(backMenuItemCallBack)
        local menu = cc.Menu:create()
        menu:addChild(backMenuItem) 
        menu:alignItemsVertically() 
        menu:setPosition(cc.p(250,100))
        self:addChild(menu)

    end
end
return PopupLayer 