
local GameScene = class("GameScene",cc.load("mvc").ViewBased)
local ColorBall = import(".ColorBall")

function GameScene:onCreate()
     print("onCreate")
    local s = cc.Director:getInstance():getWinSize()    
    --添加返回按钮
    local unselectedBackButton = cc.Sprite:create("LevelScene/button.back.unselected-hd.png")
    unselectedBackButton:setPosition(cc.p(50,900))
    unselectedBackButton:setScale(0.5)
    local selectedBackButton = cc.Sprite:create("LevelScene/button.back.selected-hd.png")
    selectedBackButton:setPosition(cc.p(50,900))
    selectedBackButton:setScale(0.5)
    selectedBackButton:setVisible(false)
  
    self:addChild(unselectedBackButton)
    self.level=2
    --加载游戏数据
    self.steps,self.stepsLabel,self.gameData,self.goalLabel1,self.goalLabel2,self.goalLabel3,self.goalLabel4,self.goalSum1,self.goalSum2,self.goalSum3,self.goalSum4=self:loadGameStatus(self.level)
    
    --完成目标彩球数量
    self.goalNumber1 = 0
    self.goalNumber2 = 0
    self.goalNumber3 = 0
    self.goalNumber4 = 0
   -- print(self.steps)
    
    --绘制目标槽
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
    self.gameGrid,self.gameLayer = self:initGameGrid(4,4)
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
                            self:updateSteps()
                            self:addNewball()
                        end
                        print("right")
                    else
                        if self:moveLeft() then
                            self:updateSteps()
                            self:addNewball()
                        end
                        print("left")
                    end   
                else
                    if self.m_y<locationInNode.y then                                     
                        if self:moveUp() then
                            self:updateSteps()
                            print("up")   
                            self:addNewball()   
                        end
                    else
                        if self:moveDown() then
                            self:updateSteps()
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

function GameScene:init()
   
end



--初始化游戏网格
function GameScene:initGameGrid(row,col)
    local gameGrid = {}
    local GameLayer = cc.Layer:create()
    for r=1,row do
        gameGrid[r] = {}
        for c = 1,col do
            local tield = cc.DrawNode:create()
            tield:drawRect(cc.p(0,0), cc.p(125,125), cc.c4f(1,0,1,1))
            tield:setPosition(cc.p(125*(c-1),125*(r-1)))
            tield:setContentSize(125,125)
            gameGrid[r][c] = 0            
            GameLayer:addChild(tield)
        end
    end     
    GameLayer:setContentSize(500,500)
    GameLayer:setPosition(cc.p(70,10))
    self:addChild(GameLayer)

    return gameGrid,GameLayer
end
--产生随机位置
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
        --合并相同彩球
        for r = row, row-count+2,-1 do
            if self.gameGrid[r][c] ~= 0 and self.gameGrid[r-1][c] ~= 0 and self.gameGrid[r][c]:getNumber() ==  self.gameGrid[r-1][c]:getNumber() then
                isMove = true
                self.gameGrid[r][c]:doubleNumber()
                --更新目标信息
                self:updateGoal(self.level,self.gameGrid[r][c]:getNumber())
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
                --更新目标信息
                self:updateGoal(self.level,self.gameGrid[r][c]:getNumber())
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
                --更新目标信息
                self:updateGoal(self.level,self.gameGrid[r][c]:getNumber())
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
                --更新目标信息
                self:updateGoal(self.level,self.gameGrid[r][c]:getNumber())
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




--加载游戏状态
function GameScene:loadGameStatus(level)
    local s = cc.Director:getInstance():getWinSize()
    --加载关卡数据
    local configFile = device.writablePath .."gameData.config"
    local str = io.readfile(configFile)
    local f = loadstring(str)
    local gameData = f()   
    
 
    --显示关卡数
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=40
    local levelLabel = cc.Label:createWithTTF(ttfConfig,"level " .. gameData[level].levels, cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
    levelLabel:setPosition(cc.p(150,900))
    levelLabel:setColor(cc.c4b(255,255,0,255))
    self:addChild(levelLabel)    
    --剩余步数
    ttfConfig.fontSize=35
    local steps = gameData[level].steps
    local stepsLabel = cc.Label:createWithTTF(ttfConfig,"steps:  " .. steps, cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
    stepsLabel:setPosition(cc.p(550,900))
    stepsLabel:setColor(cc.c4b(255,255,0,255))
    self:addChild(stepsLabel)
    
     --目标
    ttfConfig.fontSize=20
    local i = 1   
    local goalTable = {} 
    for k in pairs(gameData[level]) do
        if k ~= "levels" and k ~= "steps"  then
            local goalBall = cc.Sprite:create("circle-hd.png")
            goalBall:setPosition(cc.p(140*(i-1)+105,820))
            goalBall:setScale(0.2)
            if k == "ball_2" then
                goalBall:setColor(cc.c4b(0,0,255,255))
            elseif k == "ball_4" then
                goalBall:setColor(cc.c4b(0,137,0,255))
            elseif k == "ball_8" then
                goalBall:setColor(cc.c4b(142,0,128,255))
            elseif k == "ball_16" then
                goalBall:setColor(cc.c4b(221,0,96,255))
            elseif k == "ball_32" then
                goalBall:setColor(cc.c4b(255,0,0,255))
            elseif k == "ball_64" then
                goalBall:setColor(cc.c4b(225,146,0,255))
            elseif k == "ball_128" then
                goalBall:setColor(cc.c4b(224,0,224,255))
            elseif k == "ball_256" then
                goalBall:setColor(cc.c4b(159,99,42,255))
            elseif k == "ball_512" then
                goalBall:setColor(cc.c4b(222,0,151,255))
            elseif k == "ball_1024" then
                goalBall:setColor(cc.c4b(166,0,42,255))
            elseif k == "ball_2048" then
                goalBall:setColor(cc.c4b(255,0,255,255))
            end 
            table.insert(goalTable,gameData[level][k])
            self:addChild(goalBall)
            i = i +1
        end
    end 
    local goalLabel1 = cc.Label:createWithTTF(ttfConfig, 0 .. "/" .. goalTable[1], cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
    goalLabel1:setPosition(cc.p(140*(1-1)+105,840))
    self:addChild(goalLabel1)
    local goalLabel2 = cc.Label:createWithTTF(ttfConfig, 0 .. "/" .. goalTable[2], cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
            goalLabel2:setPosition(cc.p(140*(2-1)+105,840))
            self:addChild(goalLabel2)
    local goalLabel3 = cc.Label:createWithTTF(ttfConfig, 0 .. "/" .. goalTable[3], cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
            goalLabel3:setPosition(cc.p(140*(3-1)+105,840))
            self:addChild(goalLabel3)
    local goalLabel4 = cc.Label:createWithTTF(ttfConfig, 0 .. "/" .. goalTable[4], cc.VERTICAL_TEXT_ALIGNMENT_CENTER, s.width)
            goalLabel4:setPosition(cc.p(140*(4-1)+105,840))
            self:addChild(goalLabel4)
    return steps,stepsLabel,gameData,goalLabel1,goalLabel2,goalLabel3,goalLabel4,goalTable[1],goalTable[2],goalTable[3],goalTable[4]
end






--更新游戏剩余步数
function GameScene:updateSteps()
	self.steps = self.steps - 1
	if self.steps < 0 then
		print("game over")
		self:createMaskLayer("game over")
	end
	self.stepsLabel:setString("steps: " .. tostring(self.steps))
end








--更新游戏目标
function GameScene:updateGoal(level,number)
    local numberTable={}
	for k in pairs(self.gameData[level]) do
		if k == "ball_2" then
		   table.insert(numberTable,2)
		elseif k == "ball_4" then
		   table.insert(numberTable,4)
		elseif k == "ball_8" then
           table.insert(numberTable,8)
        elseif k == "ball_16" then
           table.insert(numberTable,16)  
        elseif k == "ball_32" then
           table.insert(numberTable,32)
        elseif k == "ball_64" then
           table.insert(numberTable,64)
        elseif k == "ball_128" then
           table.insert(numberTable,128) 
        elseif k == "ball_256" then
           table.insert(numberTable,256)
        elseif k == "ball_512" then
           table.insert(numberTable,512)
        elseif k == "ball_1024" then
           table.insert(numberTable,1024)  
        elseif k == "ball_2048" then
           table.insert(numberTable,2048)  
		end
	end
	
	if(self.goalNumber1 == self.goalSum1 and self.goalNumber2 == self.goalSum2 and self.goalNumber3 == self.goalSum3 and self.goalNumber4 == self.goalSum4) then
	   self:createMaskLayer("perfect")
	end
	
	if numberTable[1] == number then
	   if self.goalNumber1 <  self.goalSum1 then
	       self.goalNumber1 = self.goalNumber1 +1
	       self.goalLabel1:setString(self.goalNumber1 .. "/" .. self.goalSum1)
	   else
	       print("goal1 ok")
	   end
	elseif numberTable[2] == number then
	   if self.goalNumber2 <  self.goalSum2 then
           self.goalNumber2 = self.goalNumber2 +1
           self.goalLabel2:setString(self.goalNumber2 .. "/" .. self.goalSum2)
       else
           print("goal2 ok")
       end
    elseif numberTable[3] == number then
       if self.goalNumber3 <  self.goalSum3 then
           self.goalNumber3 = self.goalNumber3 +1
           self.goalLabel3:setString(self.goalNumber3 .. "/" .. self.goalSum3)
       else
           print("goal3 ok")
       end
    elseif numberTable[4] == number then
       if self.goalNumber4 <  self.goalSum4 then
           self.goalNumber4 = self.goalNumber4 +1
           self.goalLabel4:setString(self.goalNumber4 .. "/" .. self.goalSum4)
       else
           print("goal2 ok")
       end
    end 
end







--
function GameScene:createMaskLayer(action)

    local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    local s = cc.Director:getInstance():getWinSize()
    
    layer:setContentSize(500,300)
    layer:ignoreAnchorPointForPosition(false)
    layer:setAnchorPoint(cc.p(0.5,0.5))
    layer:setPosition(cc.p(s.width/2,s.height/2))
    
    
    local draw = cc.DrawNode:create()
    draw:drawRect(cc.p(0,0), cc.p(500,300), cc.c4f(1,1,1,1))
    draw:setPosition(cc.p(0,0))
    draw:setContentSize(500,300)
    layer:addChild(draw)
    
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=40
    if action == "game over" then
        local label = cc.Label:createWithTTF(ttfConfig,"Game Over!", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 500)
        label:setPosition(cc.p(250,200))
        label:setColor(cc.c4b(255,255,0,255))
        layer:addChild(label)
        
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
        layer:addChild(menu)
        
    elseif action == "perfect" then 
        local label = cc.Label:createWithTTF(ttfConfig,"Perfect!", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 500)
        label:setPosition(cc.p(250,200))
        label:setColor(cc.c4b(255,255,0,255))
        layer:addChild(label)
        
        local function nextMenuItemCallBack()
            --        cclog("selected item: tag: %d, index:%d", tag, sender:getSelectedIndex() ) 
            self:getApp():enterScene("GameScene")   
        end
        ttfConfig.fontSize=30
        local nextLabel = cc.Label:createWithTTF(ttfConfig,"next level", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,500)
        local nextMenuItem = cc.MenuItemLabel:create(nextLabel)
        nextMenuItem:setColor(cc.c4b(255,255,255,255))
        nextMenuItem:setDisabledColor(cc.c4b(255,255,0,255))
        nextMenuItem:registerScriptTapHandler(nextMenuItemCallBack)
        local menu = cc.Menu:create()
        menu:addChild(nextMenuItem) 
        menu:alignItemsVertically() 
        menu:setPosition(cc.p(250,100))
        layer:addChild(menu)
    end
    --吞并下层事件
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    layer:setUserObject(listener)
     --注册事件处理
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    --添加事件分发器
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    self:addChild(layer)
end


function GameScene:onEnter()
    print("onEnter")
    --游戏关卡
    self.level=2
    --加载游戏数据
    self.steps,self.stepsLabel,self.gameData,self.goalLabel1,self.goalLabel2,self.goalLabel3,self.goalLabel4,self.goalSum1,self.goalSum2,self.goalSum3,self.goalSum4=self:loadGameStatus(self.level)
end



return GameScene

