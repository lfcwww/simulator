
if not BaseLayer then

	local BaseLayer = class("BaseLayer", function() return display.newLayer() end)
	cc.exports.BaseLayer = BaseLayer

	local maskLayerColor = cc.c4b(0,0,0,128)



	function BaseLayer:ctor(viewID, params, isShowCloseBtn, isEnableMask, isNotTouchEnable)
		-- self._viewID = viewID
		-- self._params = params
		-- self._listener = nil
		-- self._btnClose = nil
		-- self._maskLayer = nil
		-- self._txtTitle = nil
		
		-- --启用监听
		-- self:enableNodeEvents()
		-- --遮罩层
		-- self:initMaskLayer(isEnableMask)
		-- --屏蔽下层点击
		-- self:initBlockLayer(isNotTouchEnable)
		-- --自带关闭按钮
		-- self:initCloseButton(isShowCloseBtn)
		-- --自带标题
		-- self:initTitle()
		-- self:initResoureBar()
		
		-- --显示标头底条
		-- -- self:showReturnBg(viewID)
		-- self:showReturnButtonBg()
	end

	function BaseLayer:initMaskLayer(isEnableMask)
		if isEnableMask == true then
			self._maskLayer = display.newColorLayer(maskLayerColor)
			self._maskLayer:setContentSize(display.width * 100, display.height * 100)
			local size = self._maskLayer:getContentSize()
			self._maskLayer:setPosition(display.cx - size.width / 2, display.cy - size.height / 2)
			self:addChild(self._maskLayer)
		end
	end

	function BaseLayer:initBlockLayer(isNotTouchEnable)
		--print("触摸事件",isNotTouchEnable)
		if not isNotTouchEnable then
			local function onTouchBegan(touch, event)
				local ret = true
				if self.touchBegan then ret = self:touchBegan(touch, event) end
				return ret
			end
			local function onTouchEnded(touch, event)
				print("onTouchEnded : "..self._viewID)
				if self.touchEnd then self:touchEnd(touch, event) end
			end
			-- self._listener = cc.EventListenerTouchOneByOne:create()
			-- self._listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
			-- self._listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
		 --    self._listener:setSwallowTouches(true)
		 --    local eventDispatcher = self:getEventDispatcher()
		 --    eventDispatcher:addEventListenerWithSceneGraphPriority(self._listener, self)
		end
	end

	function BaseLayer:initUI(params)

	end

	function BaseLayer:updateUI(params)

	end

	function BaseLayer:closeView(params)
		g_dispatcher.dispatch(MainCityConfig.evtCloseView, self._viewID)
		g_viewMgr():removeView(self._viewID)
		g_viewMgr():closePop(self._viewID)
	end

	



	function BaseLayer:hideTitle()
		if self._txtTitle and self._spTitleBg then
			self._txtTitle:setVisible(false)
			self._spTitleBg:setVisible(false)
		end
	end

	function BaseLayer:showhideTitle()
		if self._txtTitle and self._spTitleBg then
			self._txtTitle:setVisible(true)
			self._spTitleBg:setVisible(true)
		end
	end





	-- function BaseLayer:_scaleCloseAction(node)
	-- 	return transition.create(cc.ScaleTo:create(0.15, 0), {easing = "RATEACTION"})
	-- end

	-- function BaseLayer:_FadeCloseAction(node)
	-- 	node:setCascadeOpacityEnabled(true)
	-- 	for k,v in pairs(node:getChildren()) do
	-- 		v:setCascadeOpacityEnabled(true)
	-- 	end

	-- 	local a1 = cc.FadeOut:create(0.2)
	-- 	local a2 = cc.MoveBy:create(0.2, cc.p(0, -50))
	-- 	local a3 = cc.Spawn:create(a1, a2)
	-- 	local a3 = transition.create(a3, {easing = "IN"})
	-- 	return a3
	-- end

	return BaseLayer

end