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
    self:addChild(selectedBackButton)
    self:addChild(unselectedBackButton)
    --显示关卡数
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=40
    local number = 3
    local level = "level " .. number
    local levelLabel = cc.Label:createWithTTF(ttfConfig,level, cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
    levelLabel:setPosition(cc.p(150,900))
    levelLabel:setColor(cc.c4b(255,255,0,255))
    self:addChild(levelLabel)
    --剩余步数
    ttfConfig.fontSize=35
    local steps = 100
    local step = "steps:  " .. steps
    local stepsLabel = cc.Label:createWithTTF(ttfConfig,step, cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
    stepsLabel:setPosition(cc.p(550,900))
    stepsLabel:setColor(cc.c4b(255,255,0,255))
    self:addChild(stepsLabel)
    
    local goal = {{Count=10,Sum=10},
                           {Count=1,Sum=10},
                           {Count=1,Sum=10},
                           {Count=1,Sum=10}}
                            
    --目标
    ttfConfig.fontSize=20
    for i=1,4 do
        local goalBall = cc.Sprite:create("circle-hd.png")
        goalBall:setPosition(cc.p(140*(i-1)+105,820))
        goalBall:setScale(0.2)
        goalBall:setColor(cc.c4b(0,0,255,255))
        local goalLabel = cc.Label:createWithTTF(ttfConfig, goal[i].Count .. "/" .. goal[i].Sum, cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
        goalLabel:setPosition(cc.p(140*(i-1)+105,840))
        self:addChild(goalLabel)
        self:addChild(goalBall)
    end
    
    
    local draw = cc.DrawNode:create()
    draw:drawLine(cc.p(55,550),cc.p(155,550),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(55,550),cc.p(55,800),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(155,550),cc.p(155,800),cc.c4f(1,1,1,1))
    
    draw:drawLine(cc.p(195,550),cc.p(295,550),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(195,550),cc.p(195,800),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(295,550),cc.p(295,800),cc.c4f(1,1,1,1))
    
    draw:drawLine(cc.p(335,550),cc.p(435,550),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(335,550),cc.p(335,800),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(435,550),cc.p(435,800),cc.c4f(1,1,1,1))
    
    draw:drawLine(cc.p(475,550),cc.p(575,550),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(475,550),cc.p(475,800),cc.c4f(1,1,1,1))
    draw:drawLine(cc.p(575,550),cc.p(575,800),cc.c4f(1,1,1,1))
    self:addChild(draw)    
    
    --初始化游戏网格,并随机产生两个彩球
    self.gameGrid,self.gameLayer = self:initGameGrid(5,5)
    self:addNewball()
    self:addNewball()
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
            if self.m_startMove == true and (math.abs(self.m_x-locationInNode.x)>10 or math.abs(self.m_y-locationInNode.y)>10) then
            	self.m_startMove = false
                if math.abs(self.m_x-locationInNode.x)>math.abs(self.m_y-locationInNode.y) then
                    if self.m_x<locationInNode.x then
                        if self:moveRight() then
                        	self:addNewball()
                        end
                        print("right")
                    else
                        if self:moveLeft() then
                        	self:addNewball()
                        end
                        print("left")
                    end   
                else
                    if self.m_y<locationInNode.y then                                     
                        if self:moveUp() then
                            print("up")   
                            self:addNewball()   
                        end
                    else
                        if self:moveDown() then
                            self:addNewball() 
                            print("down")
                        end
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
    segmentLine:drawLine(cc.p(0,0),cc.p(s.width,0),cc.c4f(1,1,1,1))
    segmentLine:setPosition(cc.p(0,s.height/2+40))
    self:addChild(segmentLine)
   
    
end
--初始化游戏网格
function GameScene:initGameGrid(row,col)
    local gameGrid = {}
    local GameLayer = cc.Layer:create()
    for row=1,5 do
        gameGrid[row] = {}
        for col = 1,5 do
            local tield = cc.DrawNode:create()
            tield:drawRect(cc.p(0,0), cc.p(100,100), cc.c4f(1,0,1,1))
            tield:setPosition(cc.p(100*(col-1),100*(row-1)))
            tield:setContentSize(100,100)
            gameGrid[row][col] = 0            
            GameLayer:addChild(tield)
        end
    end     
    GameLayer:setContentSize(500,500)
    GameLayer:setPosition(cc.p(70,10))
    self:addChild(GameLayer)
    
    return gameGrid,GameLayer
end

function GameScene:createRandomPosition()
	local row = #self.gameGrid
    local col = #self.gameGrid[1]
    
	local zeros = {}
	for i = 1,row do
	   for j =1 ,col do
            if self.gameGrid[i][j] == 0 then
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
function GameScene:addNewball()
    local row,col = self:createRandomPosition()
   
    if row and col then
	   local r = math.random()
	   if r < 0.9 then
	       local colorBall = ColorBall:create()
	        colorBall:setNumber(2)
	        colorBall:setPosition(row,col)
            self.gameGrid[row][col] = colorBall
            
            self.gameLayer:addChild(colorBall:getBall())
	   else
            local colorBall = ColorBall:create()
            colorBall:setNumber(4)
            colorBall:setPosition(row,col)
            self.gameGrid[row][col] = colorBall
            self.gameLayer:addChild(colorBall:getBall())
	   end
	end
end
--向上移动
function GameScene:moveUp()
    local isMove = false
    local row = #self.gameGrid
    local col = #self.gameGrid[1]
    for c = 1,col do
        local line = {}
        for r = row,1,-1 do
            if self.gameGrid[r][c] ~= 0 then
                table.insert(line,self.gameGrid[r][c])
            end
        end
        local count = #line
        for r = row,1,-1 do
            --判断是否可移动
            for i = row,2,-1 do
                if self.gameGrid[i][c] == 0 and self.gameGrid[i-1][c] ~= 0 then
                	isMove = true
                end
            end            
            if row-r+1 <= count then
                
                self.gameGrid[r][c] = line[row-r+1]
                self.gameGrid[r][c]:setPosition(r,c)
            else
                 self.gameGrid[r][c] = 0
            end
        end
        for r = row, row-count+2,-1 do
            if self.gameGrid[r][c] ~= 0 and self.gameGrid[r-1][c] ~= 0 and self.gameGrid[r][c]:getNumber() ==  self.gameGrid[r-1][c]:getNumber() then
                isMove = true
                self.gameGrid[r][c]:doubleNumber()
                self.gameGrid[r-1][c]:getBall():removeFromParent()
                self.gameGrid[r-1][c] = 0
                for x = r-1, 2, -1 do
                    self.gameGrid[x][c] = self.gameGrid[x-1][c]
                    if self.gameGrid[x][c] ~= 0 then
                        self.gameGrid[x][c]:setPosition(x,c)
                    end
                    self.gameGrid[x-1][c] = 0
                end
            end
        end
        
    end	
    return isMove
end

--向下移动
function GameScene:moveDown()
    local isMove = false
    local row = #self.gameGrid
    local col = #self.gameGrid[1]
    for c = 1,col do
        local line = {}
        for r = 1,row do
            if self.gameGrid[r][c] ~= 0 then
                table.insert(line,self.gameGrid[r][c])
            end
        end
        local count = #line
        for r = 1,row do
            --判断是否可移动
            for i = 1,row-1 do
                if self.gameGrid[i][c] == 0 and self.gameGrid[i+1][c] ~= 0 then
                    isMove = true
                end
            end            
            if r <= count then

                self.gameGrid[r][c] = line[r]
                self.gameGrid[r][c]:setPosition(r,c)
            else
                self.gameGrid[r][c] = 0
            end
        end
        for r = 1, count-1 do
            if self.gameGrid[r][c] ~= 0 and self.gameGrid[r+1][c] ~= 0 and self.gameGrid[r][c]:getNumber() ==  self.gameGrid[r+1][c]:getNumber() then
                isMove = true
                self.gameGrid[r][c]:doubleNumber()
                self.gameGrid[r+1][c]:getBall():removeFromParent()
                self.gameGrid[r+1][c] = 0
                for x = r+1, row-1 do
                    self.gameGrid[x][c] = self.gameGrid[x+1][c]
                    printf("row = %s,col =%s",tostring(x),tostring(c))
                    if(self.gameGrid[x][c] ~= 0) then
                        self.gameGrid[x][c]:setPosition(x,c)
                    end
                    self.gameGrid[x+1][c] = 0
                end
            end
        end

    end 
    return isMove
end

--向右移动
function GameScene:moveLeft()
    local isMove = false
    local row = #self.gameGrid
    local col = #self.gameGrid[1]
    for r = 1,row do
        local line = {}
        for c = 1,col do
            if self.gameGrid[r][c] ~= 0 then
                table.insert(line,self.gameGrid[r][c])
            end
        end
        local count = #line
        for c = 1,col do
            --判断是否可移动
            for j = 1,col-1 do
                if self.gameGrid[r][j] == 0 and self.gameGrid[r][j+1] ~= 0 then
                    isMove = true
                end
            end            
            if c <= count then

                self.gameGrid[r][c] = line[c]
                self.gameGrid[r][c]:setPosition(r,c)
            else
                self.gameGrid[r][c] = 0
            end
        end
        for c = 1, count-1 do
            if self.gameGrid[r][c] ~= 0 and self.gameGrid[r][c+1] ~= 0 and self.gameGrid[r][c]:getNumber() ==  self.gameGrid[r][c+1]:getNumber() then
                isMove = true
                self.gameGrid[r][c]:doubleNumber()
                self.gameGrid[r][c+1]:getBall():removeFromParent()
                self.gameGrid[r][c+1] = 0
                for x = c+1, col-1 do
                    self.gameGrid[r][x] = self.gameGrid[r][x+1]
                    printf("row = %s,col =%s",tostring(x),tostring(c))
                    if(self.gameGrid[r][x] ~= 0) then
                        self.gameGrid[r][x]:setPosition(r,x)
                    end
                    self.gameGrid[r][x+1] = 0
                end
            end
        end
    end 
    return isMove
end

--向右移动
function GameScene:moveRight()
    local isMove = false
    local row = #self.gameGrid
    local col = #self.gameGrid[1]
    for r = 1,row do
        local line = {}
        for c = col,1,-1 do
            if self.gameGrid[r][c] ~= 0 then
                table.insert(line,self.gameGrid[r][c])
            end
        end
        local count = #line
        for c = col,1,-1 do
            --判断是否可移动
            for i = col,2,-1 do
                if self.gameGrid[r][i] == 0 and self.gameGrid[r][i-1] ~= 0 then
                    isMove = true
                end
            end            
            if col-c+1 <= count then

                self.gameGrid[r][c] = line[col-c+1]
                self.gameGrid[r][c]:setPosition(r,c)
            else
                self.gameGrid[r][c] = 0
            end
        end
        for c = col, col-count+2,-1 do
            if self.gameGrid[r][c] ~= 0 and self.gameGrid[r][c-1] ~= 0 and self.gameGrid[r][c]:getNumber() ==  self.gameGrid[r][c-1]:getNumber() then
                isMove = true
                self.gameGrid[r][c]:doubleNumber()
                self.gameGrid[r][c-1]:getBall():removeFromParent()
                self.gameGrid[r][c-1] = 0
                for x = c-1, 2, -1 do
                    self.gameGrid[r][x] = self.gameGrid[r][x-1]
                    if self.gameGrid[r][x] ~= 0 then
                        self.gameGrid[r][x]:setPosition(r,x)
                    end
                    self.gameGrid[r][x-1] = 0
                end
            end
        end

    end 
    return isMove
end
return GameScene