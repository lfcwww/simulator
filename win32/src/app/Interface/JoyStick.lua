
-- http://blog.csdn.net/lee_homi/article/details/45248815
if not Joystick then

    local Joystick = class("Joystick", function() return display.newLayer() end)
    cc.exports.Joystick = Joystick

    function Joystick:ctor()
        self.visibleSize = cc.Director:getInstance():getVisibleSize()
        self.frame = nil
        self.stick = nil
        self.controlDiameter = nil    --直径
        self.isCanMove = nil
        self.angle = nil
    end

    function Joystick:handleTouchChange(pos1 , pos2)
        --得到两点坐标的x，y坐标值
        local px1 = pos1.x
        local py1 = pos1.y
        local px2 = pos2.x
        local py2 = pos2.y

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

    function Joystick:load()
        --摇杆背景层

        self.frame = display.newSprite("JoystickContainer.png")--cc.Sprite:createWithSpriteFrameName("JoystickContainer_norm-hd.png")
        self.frame:setAnchorPoint(0 , 0)
        self.frame:setPosition(cc.p(25 , 25))
        ccui.Helper:doLayout(self.frame)
        self:addChild(self.frame)

        --摇杆层
        self.stick = display.newSprite("JoystickNorm.png")--cc.Sprite:createWithSpriteFrameName("Joystick_norm.png")
        self.stick:setPosition(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2)
        self.stick:setScale(0.8)
        self.frame:addChild(self.stick , 1)

        self.controlDiameter = self.frame:getContentSize().width - self.stick:getContentSize().width
        self.angle = 0
        --添加点击事件
        local function onTouchesBegan(touches ,event)
            if cc.rectContainsPoint(self:getBoundingBox(),touches[1]:getLocation()) then
                return true
            end
            return false    
        end

        local function onTouchesMoved(touches , event)
            if cc.rectContainsPoint(self:getBoundingBox(),touches[1]:getLocation()) then
                local point = touches[1]:getLocation()

                local x = point.x - self.frame:getContentSize().width/2
                local y = point.y - self.frame:getContentSize().height/2
                local pos = cc.p(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2)
                if math.sqrt(math.pow(x , 2) + math.pow( y , 2)) >= self.frame:getContentSize().width/2 then
                    --得到触点与摇杆背景圆心形成的角度
                    self.angle = self:handleTouchChange(pos , point)
                    --确保小圆的运动范围在背景园内
                    if self.angle > 1.51046 or self.angle < -0.8075908 then
                        return
                    end
                    self.stick:setPosition(cc.pAdd(self:getAnglePosition(self.frame:getContentSize().width/2 , angle) , cc.p(self.frame:getContentSize().width/2 , self.frame:getContentSize().height/2)))
                else
                    self.angle = self:handleTouchChange(pos , point)
                    --触点在背景圆内跟随触点运动
                    if self.angle > 1.51046 or self.angle < -0.8075908 then
                        return
                    end
                    self.stick:setPosition(point)
                end
                self:changeAngleForBone()
                kx_paodan = self.stick:getPositionX() / math.sqrt(math.pow(self.stick:getPositionX() , 2) + math.pow(self.stick:getPositionY() , 2 ))
                ky_paodan = self.stick:getPositionY() / math.sqrt(math.pow(self.stick:getPositionX() , 2) + math.pow(self.stick:getPositionY() , 2 ))
                -- cclog("kx : "..kx_paodan..", ky : "..ky_paodan)
            end 
        end

        local function onTouchesEnded(touches , event)
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

    function Joystick:init()
        self:load()
    end

    function Joystick:create()
        local newLayer = Joystick.new()
        newLayer:init()
        return newLayer
    end

    return Joystick
end