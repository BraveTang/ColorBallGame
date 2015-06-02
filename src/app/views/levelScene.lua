local LevelScene = class("LevelScene", cc.load("mvc").ViewBase)

--LevelScene.RESOURCE_FILENAME = "LevelScene.csb"

function LevelScene:onCreate()

    local levelTable = {}
    --加载关卡场景
    local root = cc.CSLoader:createNode("LevelScene.csb")
    root:addTo(self)
    
    --获取返回图片控件
    local unselectedButton = root:getChildByName("unselectedButton")
    local selectedButton = root:getChildByName("selectedButton")
    
    --初始化关卡列表
    local winSize = cc.Director:getInstance():getWinSize()
    local draw = cc.DrawNode:create()
    draw:drawRect(cc.p(0,0), cc.p(540, 600), cc.c4f(1,1,1,0))
    draw:setPosition(cc.p(50,50))
    --创建关卡表
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=40


    for row=1,6 do
        levelTable[row] = {}
        for col = 1,5 do
            local tield = cc.DrawNode:create()
            tield:drawRect(cc.p(0,0), cc.p(100, 100), cc.c4f(1,0,0,1))
            tield:setPosition(cc.p(100*(col-1)+10*(col-1),100*(row-1)+10*(row-1)))

            local number = cc.Label:createWithTTF(ttfConfig,tostring(30-row*5+col), cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 100)
            number:setPosition(cc.p(50,50))
            tield:addChild(number)
            tield:setContentSize(100,100)
            levelTable[row][col] = tield            
            draw:addChild(tield)
        end
    end 
 

    --开始触摸事件处理
    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        
        
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        printf("levlelTieldSize width = %s", tostring(s.width))
        printf("locationInNode x = %s,y=%s", tostring(locationInNode.x),tostring(locationInNode.y))
        if cc.rectContainsPoint(rect, locationInNode) then
            
            if target == unselectedButton then
                selectedButton:setVisible(true)
                unselectedButton:setVisible(false)            
                return true
            elseif target == levelTable[6][1] then
                print("OK")
                self:getApp():enterScene("GameScene") 
                return true  
            end
        end

        return false   
    end
    --结束触摸事件处理
    local function onTouchEnded(touch, event)
        selectedButton:setVisible(false)
        unselectedButton:setVisible(true)
        self:getApp():enterScene("MainScene")
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
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, unselectedButton)
    
    local listener2 = listener:clone()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener2, levelTable[6][1])
 
    local layer = cc.Layer:create()
    layer:addChild(draw) 
    self:addChild(layer) 
end

return LevelScene