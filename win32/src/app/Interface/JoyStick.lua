-- http://www.tuicool.com/articles/eEnMr2I
if not Joystick then

    local Joystick = class("Joystick", function() return display.newLayer() end)
    cc.exports.Joystick = Joystick

    local FollowFinger = false --是否跟随手指
    local defaultPos = cc.p(50,50)

    function Joystick:ctor(param)
        self:init()
    end

    function Joystick:init()
        --摇杆背景层
        -- self.frame = display.newSprite("JoystickContainer.png")--TODO
        self.frame = display.newSprite("#gongyong_2anniu_6.png")--TODO
        self.frame:setOpacity(100)
        self.frame:setAnchorPoint(0.5 , 0.5)
        self.frame:setPosition(defaultPos)
        ccui.Helper:doLayout(self.frame)
        self:addChild(self.frame)

        --摇杆层
        -- self.stick = display.newSprite("JoystickNorm.png")--TODO
        self.stick = display.newSprite("#gongyong_dian_2.png")--TODO
        self.stick:setPosition(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2)
        self.stick:setScale(0.8)
        self.frame:addChild(self.stick , 1)

        self.controlDiameter = self.frame:getContentSize().width - self.stick:getContentSize().width
        self.angle = 0
        --添加点击事件
        local function onTouchesBegan(touches ,event)
            if FollowFinger then
                self.frame:setPosition(touches[1]:getLocation())
            end

            if cc.rectContainsPoint(self:getBoundingBox(),touches[1]:getLocation()) then
                return true
            end
            return false    
        end

        local function onTouchesMoved(touches , event)
            if cc.rectContainsPoint(self:getBoundingBox(),touches[1]:getLocation()) then
                local point = touches[1]:getLocation()
                -- dump(point)
                local x = point.x - self.frame:getPositionX()
                local y = point.y - self.frame:getPositionY()
                local pos = cc.p(self.frame:getPositionX(),self.frame:getPositionY())--cc.p(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2)
                if math.sqrt(math.pow(x , 2) + math.pow( y , 2)) >= self.frame:getContentSize().width/2 then
                    --得到触点与摇杆背景圆心形成的角度
                    self.angle = self:handleTouchChange(pos , point)
                    -- print("====",point.x, point.y, self.angle)
                    --确保小圆的运动范围在背景园内
                    -- if self.angle > 1.51046 or self.angle < -0.8075908 then
                    --     return
                    -- end
                    -- print("···",self.angle)
                    -- dump(self:getAnglePosition(self.frame:getPositionX() , self.angle))
                    -- dump(cc.p(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2))
                    -- dump(self:getAnglePosition(cc.p(self.frame:getPositionX() , self.frame:getPositionY()))
                    self.stick:setPosition(cc.pAdd(self:getAnglePosition(self.frame:getContentSize().width/2 , self.angle) , cc.p(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2)))
                else
                    self.angle = self:handleTouchChange(pos , point)
                    --触点在背景圆内跟随触点运动
                    -- if self.angle > 1.51046 or self.angle < -0.8075908 then
                    --     return
                    -- end
                    self.stick:setPosition(point.x-pos.x+self.frame:getContentSize().width/2, point.y-pos.y+self.frame:getContentSize().height/2)
                end
                -- self:changeAngleForBone()
                local kx_paodan = self.stick:getPositionX() / math.sqrt(math.pow(self.stick:getPositionX() , 2) + math.pow(self.stick:getPositionY() , 2 ))
                local ky_paodan = self.stick:getPositionY() / math.sqrt(math.pow(self.stick:getPositionX() , 2) + math.pow(self.stick:getPositionY() , 2 ))
               -- print("kx : "..kx_paodan..", ky : "..ky_paodan)
               print("self.angle==",self.angle)
            end 
        end

        local function onTouchesEnded(touches , event)
            self.frame:setPosition(defaultPos)
            local origin = cc.p(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2)
            self.stick:setPosition(origin)
        end

        local function onTouchesCancelled(touches , event)
            onTouchEnded(touch , event)
        end

        local listener = cc.EventListenerTouchAllAtOnce:create()
        listener:registerScriptHandler(onTouchesBegan , cc.Handler.EVENT_TOUCHES_BEGAN)
        listener:registerScriptHandler(onTouchesMoved , cc.Handler.EVENT_TOUCHES_MOVED)
        listener:registerScriptHandler(onTouchesEnded , cc.Handler.EVENT_TOUCHES_ENDED)
        listener:registerScriptHandler(onTouchesCancelled , cc.Handler.EVENT_TOUCHES_CANCELLED)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener , self)
    end



    --获取当前摇杆与用户触屏点的角度
    function Joystick:handleTouchChange(_posA , _posB)
        --得到两点坐标的x，y坐标值
        local px1 = _posA.x
        local py1 = _posA.y
        local px2 = _posB.x
        local py2 = _posB.y

        --求出两边的长度
        local x = px2 - px1
        local y = py1 - py2

        --求出距离 及 角度
        local xie = math.sqrt(math.pow(x , 2) + math.pow( y , 2))
        local cos = x/xie

        --反余弦定理 ， 知道两边长求角度 cos = 邻边/斜边
        local rad = math.acos(cos)

        --当触屏Y坐标 < 摇杆的Y坐标时，取反值
        if py1 > py2 then
            rad = -rad
        end
        return rad
    end

    --得到与角度对应的半径为r的圆上一坐标点
    function Joystick:getAnglePosition(r , angle)
        local x = r*math.cos(self.angle)
        local y = r*math.sin(self.angle)
        return cc.p(x , y)
    end

    function Joystick:setLocalPosition(_x, _y)
        defaultPos = cc.p(_x, _y)
        self.frame:setPosition(defaultPos)
    end

    function Joystick:setFollowFinger(bool)
        FollowFinger = bool
    end

    return Joystick
end