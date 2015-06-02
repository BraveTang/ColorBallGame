local GameScene = class("GameScene", cc.load("mvc").ViewBase)
local ColorBall = import(".ColorBall")


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
    --初始化游戏网格,并随机产生两个彩球
    self.gameGrid,self.gameLayer = self:initGameGird(5,5)

    --开始触摸事件处理
    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())

        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
       -- printf("levlelTieldSize width = %s", tostring(s.width))
        
        if cc.rectContainsPoint(rect, locationInNode) then

            if target == unselectedBackButton then
                selectedBackButton:setVisible(true)
                unselectedBackButton:setVisible(false)            
                return true
            elseif target == self.gameLayer then
                self.m_x = locationInNode.x
                self.m_y = locationInNode.y
                printf("locationInNode x = %s,y=%s", tostring(locationInNode.x),tostring(locationInNode.y))
                self.m_startMove = true
                return true;
            end            
        end
        return false   
    end
    --结束触摸事件处理
    local function onTouchEnded(touch, event)
        local target = event:getCurrentTarget()
        if target == unselectedBackButton then
             print("world")
            selectedBackButton:setVisible(false)
            unselectedBackButton:setVisible(true)
            self:getApp():enterScene("LevelScene")
        elseif target == self.gameLayer then
            
        end
    end
    --移动触摸事件处理
    local function onTouchMoved(touch,event)
        local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        if target == unselectedBackButton then
            --
        elseif target == self.gameLayer then
            if self.m_startMove == true and math.abs(self.m_x-locationInNode.x)>10 or math.abs(self.m_y-locationInNode.y)>10 then
            	self.m_startMove = false
                if math.abs(self.m_x-locationInNode.x)>math.abs(self.m_y-locationInNode.y) then
                    if self.m_x<locationInNode.x then
                        print("right")
                    else
                        print("left")
                    end   
                else
                    if self.m_y<locationInNode.y then
                        print("up")
                    else
                        print("down")
                    end                 
                end
            end
        end
    end
    
    --添加事件监听器
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    self:setUserObject(listener)
    --注册事件处理
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    --添加事件分发器
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, unselectedBackButton)
    local listener2 = listener:clone()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener2, self.gameLayer)
    --屏幕分隔线
    local segmentLine = cc.DrawNode:create()
    segmentLine:drawLine(cc.p(0,0),cc.p(s.width,0),cc.c4f(1,0,0,1))
    segmentLine:setPosition(cc.p(0,s.height/2+40))
    self:addChild(segmentLine)
   
    
end
--初始化游戏网格
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
    self:addNewball(gameGird)
    self:addNewball(gameGird)
    GameLayer:setContentSize(500,500)
    GameLayer:setPosition(cc.p(70,10))
    self:addChild(GameLayer)
    
    return gameGird,GameLayer
end

function GameScene:createRandomPosition(gameGird)
	local row = #gameGird
	local col = #gameGird[1]
	local zeros = {}
	for i = 1,row do
	   for j =1 ,col do
	       if gameGird[i][j]:getChildrenCount() == 0 then
	           table.insert(zeros,{i=i,j=j})    
	       end
	   end
	end
	if #zeros>0 then
	   local r = math.random(1,#zeros)
	   return zeros[r].i,zeros[r].j
	end
end
--在随机位置添加新彩球
function GameScene:addNewball(gameGird)
   
    local row,col = self:createRandomPosition(gameGird)
    if row and col then
	   local r = math.random()
	   if r < 0.9 then
	       local colorBall = ColorBall:create()
	       colorBall:setNumber(2)
            gameGird[row][col]:addChild(colorBall:getBall())
	   else
            local colorBall = ColorBall:create()
            colorBall:setNumber(4)
            gameGird[row][col]:addChild(colorBall:getBall())
	   end
	end
end
--向上移动
function doUp(gameGird)
    local isMove = false
    for row,5 do
        for
end

return GameScene