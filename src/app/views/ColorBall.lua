local ColorBall = class("ColorBall")

function ColorBall:ctor()
    self._ball = nil 
    self:init()
end

function ColorBall:init()
	self._number = 2
	self._ball = cc.Sprite:create("circle-hd.png")
    self._ball:setPosition(cc.p(62.5,62.5))
    self._ball:setScale(1)
    self._ball:setColor(cc.c4b(0,0,255,255))
    local ttfConfig = {}
    ttfConfig.fontFilePath="fonts/arial.ttf"
    ttfConfig.fontSize=46
    self.numberLabel = cc.Label:createWithTTF(ttfConfig,tostring(2), cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 100)
    self.numberLabel:setPosition(cc.p(50,50))
    self.numberLabel:setVisible(true)
    self._ball:addChild(self.numberLabel)  
end

function ColorBall:getBall()
	return self._ball
end

function ColorBall:getNumber()
    return self._number
end

function ColorBall:setNumber(n)
    self._number = n
    self.numberLabel:setString(tostring(n))
    self:setColorFromNumber(n)
end

function ColorBall:doubleNumber()
	self._number = self._number*2
	self:setNumber(self._number)
end

function ColorBall:setColorFromNumber(n)
	if n == 2 then
        self._ball:setColor(cc.c4b(0,0,255,255))
	elseif n == 4 then
        self._ball:setColor(cc.c4b(0,137,0,255))
    elseif n == 8 then
        self._ball:setColor(cc.c4b(142,0,128,255))
    elseif n == 16 then
        self._ball:setColor(cc.c4b(221,0,96,255))
    elseif n == 32 then
        self._ball:setColor(cc.c4b(255,0,0,255))
    elseif n == 64 then
        self._ball:setColor(cc.c4b(225,146,0,255))
    elseif n == 128 then
        self._ball:setColor(cc.c4b(224,0,224,255))
    elseif n == 256 then
        self._ball:setColor(cc.c4b(159,99,42,255))
    elseif n == 512 then
        self._ball:setColor(cc.c4b(222,0,151,255))
    elseif n == 1024 then
        self._ball:setColor(cc.c4b(166,0,42,255))
    elseif n == 2048 then
        self._ball:setColor(cc.c4b(255,0,255,255))
	end
end

function ColorBall:setPosition(row,col)
    self._ball:setPosition(cc.p(125*(col-1)+62.5,125*(row-1)+62.5))
end

return ColorBall