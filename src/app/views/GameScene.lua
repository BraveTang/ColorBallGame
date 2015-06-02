local GameScene = class("GameScene", cc.load("mvc").ViewBase)
local ColorBall = import(".ColorBall")

function GameScene:initGameGird(row,col)
    local gameGird = {}
    local GameLayer = cc.Layer:create()
    for row=1,5 do
        gameGird[row] = {}
        for col = 1,5 do
            local tield = cc.DrawNode:create()
            tield:drawRect(cc.p(0,0), cc.p(100,100), cc.c4f(0,1,1,1))
            tield:setPosition(cc.p(100*(col-1),100*(row-1)))

            tield:setContentSize(100,100)
            gameGird[row][col] = tield            
            GameLayer:addChild(tield)
        end
    end 
    GameLayer:setPosition(cc.p(70,10))
    self:addChild(GameLayer)
    return gameGird
end

function GameScene:onCreate()
    local s = cc.Director:getInstance():getWinSize()
    printf("s.height = %d\n",s.height)
    printf("s.width = %d\n",s.width)
    
    
    --添加返回按钮
    local unselectedBackButton = cc.Sprite:create("LevelScene/button.back.unselected-hd.png")
    unselectedBackButton:setPosition(cc.p(50,900))
    unselectedBackButton:setScale(0.5)
    local selectedBackButton = cc.Sprite:create("LevelScene/button.back.selected-hd.png")
    selectedBackButton:setPosition(cc.p(50,900))
    selectedBackButton:setScale(0.5)
    selectedBackButton:setVisible(false)
    self:add(selectedBackButton)
    self:add(unselectedBackButton)


    --开始触摸事件处理
    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())

        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        printf("levlelTieldSize width = %s", tostring(s.width))
        printf("locationInNode x = %s,y=%s", tostring(locationInNode.x),tostring(locationInNode.y))
        if cc.rectContainsPoint(rect, locationInNode) then

            if target == unselectedBackButton then
                selectedBackButton:setVisible(true)
                unselectedBackButton:setVisible(false)            
                return true
            end
        end

        return false   
    end
    --结束触摸事件处理
    local function onTouchEnded(touch, event)
        selectedBackButton:setVisible(false)
        unselectedBackButton:setVisible(true)
        self:getApp():enterScene("LevelScene")
    end
    --添加事件监听器
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    self:setUserObject(listener)
    --注册事件处理
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    --添加事件分发器
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, unselectedBackButton)

    local segmentLine = cc.DrawNode:create()
    segmentLine:drawLine(cc.p(0,0),cc.p(s.width,0),cc.c4f(1,0,0,1))
    segmentLine:setPosition(cc.p(0,s.height/2+40))
    self:addChild(segmentLine)
    self.gameGrid = self:initGameGird(5,5)
   
--    GameTable[1][1]:setNumber(2)
--    GameTable[1][2]:setNumber(4)
--    GameTable[1][3]:setNumber(8)
--    GameTable[1][4]:setNumber(16)
--    GameTable[1][5]:setNumber(32)
--    GameTable[2][1]:setNumber(64)
--    GameTable[2][2]:setNumber(128)
--    GameTable[2][3]:setNumber(512)
--    GameTable[2][4]:setNumber(1024)
--    GameTable[2][5]:setNumber(2048)
    
end



return GameScene