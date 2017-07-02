--[[

Copyright (c) 2014-2017 Chukong Technologies Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

local Node = cc.Node

function Node:add(child, zorder, tag)
    if tag then
        self:addChild(child, zorder, tag)
    elseif zorder then
        self:addChild(child, zorder)
    else
        self:addChild(child)
    end
    return self
end

function Node:addTo(parent, zorder, tag)
    if tag then
        parent:addChild(self, zorder, tag)
    elseif zorder then
        parent:addChild(self, zorder)
    else
        parent:addChild(self)
    end
    return self
end

function Node:removeSelf()
    self:removeFromParent()
    return self
end

function Node:align(anchorPoint, x, y)
    self:setAnchorPoint(anchorPoint)
    return self:move(x, y)
end

function Node:show()
    self:setVisible(true)
    return self
end

function Node:hide()
    self:setVisible(false)
    return self
end

function Node:move(x, y)
    if y then
        self:setPosition(x, y)
    else
        self:setPosition(x)
    end
    return self
end

function Node:moveTo(args)
    transition.moveTo(self, args)
    return self
end

function Node:moveBy(args)
    transition.moveBy(self, args)
    return self
end

function Node:fadeIn(args)
    transition.fadeIn(self, args)
    return self
end

function Node:fadeOut(args)
    transition.fadeOut(self, args)
    return self
end

function Node:fadeTo(args)
    transition.fadeTo(self, args)
    return self
end

function Node:rotate(rotation)
    self:setRotation(rotation)
    return self
end

function Node:rotateTo(args)
    transition.rotateTo(self, args)
    return self
end

function Node:rotateBy(args)
    transition.rotateBy(self, args)
    return self
end

function Node:scaleTo(args)
    transition.scaleTo(self, args)
    return self
end

function Node:onUpdate(callback)
    self:scheduleUpdateWithPriorityLua(callback, 0)
    return self
end

Node.scheduleUpdate = Node.onUpdate

function Node:onNodeEvent(eventName, callback)
    if "enter" == eventName then
        self.onEnterCallback_ = callback
    elseif "exit" == eventName then
        self.onExitCallback_ = callback
    elseif "enterTransitionFinish" == eventName then
        self.onEnterTransitionFinishCallback_ = callback
    elseif "exitTransitionStart" == eventName then
        self.onExitTransitionStartCallback_ = callback
    elseif "cleanup" == eventName then
        self.onCleanupCallback_ = callback
    end
    self:enableNodeEvents()
end

function Node:enableNodeEvents()
    if self.isNodeEventEnabled_ then
        return self
    end

    self:registerScriptHandler(function(state)
        if state == "enter" then
            self:onEnter_()
        elseif state == "exit" then
            self:onExit_()
        elseif state == "enterTransitionFinish" then
            self:onEnterTransitionFinish_()
        elseif state == "exitTransitionStart" then
            self:onExitTransitionStart_()
        elseif state == "cleanup" then
            self:onCleanup_()
        end
    end)
    self.isNodeEventEnabled_ = true

    return self
end

function Node:disableNodeEvents()
    self:unregisterScriptHandler()
    self.isNodeEventEnabled_ = false
    return self
end


function Node:onEnter()
end

function Node:onExit()
end

function Node:onEnterTransitionFinish()
end

function Node:onExitTransitionStart()
end

function Node:onCleanup()
end

function Node:onEnter_()
    self:onEnter()
    if not self.onEnterCallback_ then
        return
    end
    self:onEnterCallback_()
end

function Node:onExit_()
    self:onExit()
    if not self.onExitCallback_ then
        return
    end
    self:onExitCallback_()
end

function Node:onEnterTransitionFinish_()
    self:onEnterTransitionFinish()
    if not self.onEnterTransitionFinishCallback_ then
        return
    end
    self:onEnterTransitionFinishCallback_()
end

function Node:onExitTransitionStart_()
    self:onExitTransitionStart()
    if not self.onExitTransitionStartCallback_ then
        return
    end
    self:onExitTransitionStartCallback_()
end



function Node:addNodeTouchEventListener(callBack, swallow, isOpposite )
    if not callBack then
        print("callBack is not exist!")
        return
    end

    --已经有监听的情况下，移除旧的监听
    if self.touchNodeCallBack then
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:removeEventListener(self.touchListener)
        self.touchListener = nil
    end

    --因为继承widget的会重写这个方法,所以直接修改
    -- self:setTouchEnabled(true)
    self.m_touchEnabledFlag = true

    self.touchNodeCallBack = callBack
    --精灵添加点击事件的方法
    self.touchListener = cc.EventListenerTouchOneByOne:create()  
    if swallow or swallow == nil then
        self.touchListener:setSwallowTouches(true)
    else
        self.touchListener:setSwallowTouches(false)
    end

    --began
    self.touchListener:registerScriptHandler(function( touch, event)

        if self.m_touchEnabledFlag == false then
            return false
        end

        --没有这个的话，在不可视状态下也会响应
        if not self:isCapVisible() then
            return false
        end

        local location = touch:getLocation()
        local evt = {name = "began", x = location.x, y = location.y}
        location = self:getParent():convertToNodeSpace(location)

        --点击事件不在显示区域
        if not self:containsTouchLocation(location.x, location.y) then
            if isOpposite then
                return self.touchNodeCallBack(self, evt) or false
            end
            return false
        else
            if isOpposite then
                return true
            end
        end

        local boolValue = self.touchNodeCallBack(self, evt) or false
        return boolValue
    end, cc.Handler.EVENT_TOUCH_BEGAN )

    --moved
    self.touchListener:registerScriptHandler(function ( touch, event )
        local location = touch:getLocation()
        local evt = {name = "moved", x = location.x, y = location.y }
        self.touchNodeCallBack(self, evt)

    end, cc.Handler.EVENT_TOUCH_MOVED )

    --ended
    self.touchListener:registerScriptHandler(function ( touch, event )
        local location = touch:getLocation()
        local evt = { x = location.x, y = location.y }
        location = self:getParent():convertToNodeSpace(location)

        --取消时，触摸点不在显示区域内为cancel，否则为end
        if not self:containsTouchLocation(location.x, location.y) then
            -- MusicMgr.playSound(MusicType.UIEffect.btnClick)
            evt.name = "canceled"
        else
            -- MusicMgr.playSound(MusicType.UIEffect.btnClick)
            evt.name = "ended"
        end
        self.touchNodeCallBack(self, evt)

    end, cc.Handler.EVENT_TOUCH_ENDED )

    --获取精灵的事件分发器
    local eventDispatcher = self:getEventDispatcher()
    --注册监听到分发器中
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.touchListener, self) 
end


function Node:setTouchEnabled(enable)
    self.m_touchEnabledFlag = enable
end


--往祖先节点遍历，检查是否可视
function Node:isCapVisible()
    local node = self
    while node:getParent() ~= nil do
        if node:isVisible() then
            node = node:getParent()
        else
            return false
        end
    end

    return self:isVisible()
end

function Node:containsTouchLocation(x, y)
    local touchRect = self:getTouchRect()
    local b = cc.rectContainsPoint(touchRect, cc.p(x,y))
    return b
end


--获取该节点的触摸范围
function Node:getTouchRect()
    -- local s = self:getTexture():getContentSize()
    local size = self:getContentSize()
    size.width, size.height = size.width * self:getScaleX(), size.height * self:getScaleY()

    local anchor = self:getAnchorPoint()
    local x = self:getPositionX()
    local y = self:getPositionY()

    x = x - size.width * anchor.x
    y = y - size.height * anchor.y

    return cc.rect(x, y, size.width, size.height)
end


function Node:schedule(callback, interval)
    local seq = transition.sequence({
        cc.DelayTime:create(interval),
        cc.CallFunc:create(callback),
    })
    local action = cc.RepeatForever:create(seq)
    self:runAction(action)
    return action
end

function Node:onCleanup_()
    self:onCleanup()
    if not self.onCleanupCallback_ then
        return
    end
    self:onCleanupCallback_()
end
