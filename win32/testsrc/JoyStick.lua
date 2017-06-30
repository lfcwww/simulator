-- http://www.tuicool.com/articles/eEnMr2I
if not Joystick then

    local Joystick = class("Joystick", function() return display.newLayer() end)
    cc.exports.Joystick = Joystick

    local FollowFinger = false --是否跟随手指
    local defaultdifValue =  0.01 --遥感滑动距离--遥感灵敏度调节

    Joystick.touchEvent = {
        Began = "Began",
        Moved = "Moved",
        Ended = "Ended",
        Cancelled = "Cancelled",
    }


    function Joystick:ctor(param)
        self.touchCallback = nil
        self.defaultPos = cc.p(50,50)
        self:init()
        self:touchContainer()
    end

    function Joystick:init()
        --摇杆背景层
        -- self.BasePlate = display.newSprite("JoystickContainer.png")--TODO
        self.BasePlate = display.newSprite("#gongyong_2anniu_6.png")--TODO
        self.BasePlate:setAnchorPoint(0.5 , 0.5)
        self.BasePlate:setPosition(self.defaultPos)
        ccui.Helper:doLayout(self.BasePlate)
        self:addChild(self.BasePlate)
        self.BasePlate:setOpacity(20)
        self:setContentSize(display.cx, display.height)
        --摇杆层
        -- self.stick = display.newSprite("JoystickNorm.png")--TODO
        self.stick = display.newSprite("#gongyong_dian_2.png")--TODO
        self.stick:setPosition(self.BasePlate:getContentSize().width/2 , self.BasePlate:getContentSize().height/2)
        self.stick:setScale(0.8)
        self.BasePlate:addChild(self.stick , 1)
        self.stick:setOpacity(100)
    end

    function Joystick:touchContainer()
        self.angle = 0
        --添加点击事件
        local function onTouchesBegan(event)
            if FollowFinger then
                self.BasePlate:setPosition(cc.pSub(cc.p(event.x,event.y), cc.p(self:getPositionX(), self:getPositionY()) ))
            end
            if cc.rectContainsPoint(self:getBoundingBox(),cc.p(event.x,event.y)) then
                return true
            end
            self:onTouchesHandler(Joystick.touchEvent.Began)
            return false    
        end

        local function onTouchesMoved(event)
            local point = cc.p(event.x, event.y)
            if cc.rectContainsPoint(self:getBoundingBox(),point) then
                local stickWorldPosX = self.BasePlate:getPositionX()+self:getPositionX()
                local stickWorldPosY = self.BasePlate:getPositionY()+self:getPositionY()

                local x = point.x - stickWorldPosX
                local y = point.y - stickWorldPosY

                local pos = cc.p(stickWorldPosX, stickWorldPosY)
                if math.sqrt(math.pow(x , 2) + math.pow( y , 2)) >= self.BasePlate:getContentSize().width/2 then
                    self.angle = self:handleTouchChange(pos , point)
                    self.stick:setPosition(cc.pAdd(self:getAnglePosition(self.BasePlate:getContentSize().width/2 , self.angle) , cc.p(self.BasePlate:getContentSize().width/2 , self.BasePlate:getContentSize().height/2)))
                else
                    self.angle = self:handleTouchChange(pos , point)
                    self.stick:setPosition(point.x-pos.x+self.BasePlate:getContentSize().width/2, point.y-pos.y+self.BasePlate:getContentSize().height/2)
                end
                local kx_paodan = self.stick:getPositionX() / math.sqrt(math.pow(self.stick:getPositionX() , 2) + math.pow(self.stick:getPositionY() , 2 ))
                local ky_paodan = self.stick:getPositionY() / math.sqrt(math.pow(self.stick:getPositionX() , 2) + math.pow(self.stick:getPositionY() , 2 ))
               self:onTouchesHandler(Joystick.touchEvent.Moved)
            end 
        end

        local function onTouchesEnded(event)
            self.BasePlate:setPosition(self.defaultPos)
            local origin = cc.p(self.BasePlate:getContentSize().width/2 , self.BasePlate:getContentSize().height/2)
            self.stick:setPosition(origin)
            self:onTouchesHandler(Joystick.touchEvent.Ended)
        end

        self.TouchNode = display.newNode():addTo(self)
        self.TouchNode:setTouchEnabled(true)
        self.TouchNode:setContentSize(self:getContentSize())
        self.TouchNode:addNodeTouchEventListener(function (sender, event)
            if event.name == "began" then
                onTouchesBegan(event)
                return true
            elseif event.name == "moved" then
                onTouchesMoved(event)
            elseif event.name == "ended" then
                onTouchesEnded(event)
            elseif event.name == "canceled" then
                onTouchesEnded(event)
            end
        end)
    end
    
    function Joystick:onTouchesHandler(eventName)
        if eventName == Joystick.touchEvent.Moved then
            self.histroyAngle = self.histroyAngle or 0
            if math.abs(self.histroyAngle-self.angle) > defaultdifValue then
                if self.touchCallback then
                    self.touchCallback(eventName,self.angle)
                end
                self.histroyAngle = self.angle
            end
        elseif eventName == Joystick.touchEvent.Ended then
            if self.touchCallback then
                self.touchCallback(eventName, self.angle)
            end
        end
    end

    function Joystick:onTouch(callback)
        self.touchCallback = callback
    end

    --获取当前摇杆与用户触屏点的角度
    function Joystick:handleTouchChange(_posA, _posB)
        --求出两边的长度
        local x = _posB.x - _posA.x
        local y = _posA.y - _posB.y

        --求出距离 及 角度
        local bevel = math.sqrt(math.pow(x , 2) + math.pow( y , 2))
        local cos = x/bevel

        --反余弦定理 ， 知道两边长求角度 cos = 邻边/斜边
        local rad = math.acos(cos)
        if _posA.y > _posB.y then
            rad = -rad
        end
        -- print("rad=",math.deg(rad))
        return rad
    end

    --得到与角度对应的半径为r的圆上一坐标点
    function Joystick:getAnglePosition(r , angle)
        local x = r*math.cos(self.angle)
        local y = r*math.sin(self.angle)
        return cc.p(x , y)
    end

    function Joystick:setWorldPosition(_x, _y)
        print("···",self:getPositionX(),self:getPositionY())
        self.defaultPos = cc.pSub(cc.p(_x,_y), cc.p(self:getPositionX(), self:getPositionY()))
        self.BasePlate:setPosition(self.defaultPos)
    end

    function Joystick:setFollowFinger(bool)
        FollowFinger = bool
    end



    return Joystick
end