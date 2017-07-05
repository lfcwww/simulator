
if not Battlefield then

	ViewConfig.viewPath["Battlefield"] = "app.modules.battlefield.Battlefield";

	local Battlefield = class("Battlefield", BaseLayer);
	cc.exports.Battlefield = Battlefield;

	function Battlefield:ctor(viewID, params)
		-- self:Physics()
	    self:initUI() 
	end	

	function Battlefield:initUI()

		self.BackGroundTmx = cc.TMXTiledMap:create("background.tmx"):addTo(self,-1)
		self.BackGroundTmx:setOpacity(50)

		self._RoleMgr = BattleRoleMgr.new(self.BackGroundTmx):addTo(self)
		self._myRole = self._RoleMgr:buildMyRole()
		self._RoleMgr:initEnemyRole()
		self._myJoystick = self._RoleMgr:buildJoystick()
		











		
	end


	--http://www.cocos2d-x.org/wiki/Physics
	--http://www.tuicool.com/articles/NfQjq2V
	--http://www.benmutou.com/archives/944
	function Battlefield:Physics(params)
		local visibleSize = cc.Director:getInstance():getVisibleSize();
		local body = cc.PhysicsBody:createEdgeBox(visibleSize,  cc.PHYSICSBODY_MATERIAL_DEFAULT,3)

		local edgeShape = display.newNode()
		edgeShape:setPhysicsBody(body)
		self:addChild(edgeShape)
		edgeShape:setPosition(display.cx, display.cy)


		local body = display.newSprite("JoystickNorm.png")
		body:setPhysicsBody(cc.PhysicsBody:createBox(body:getContentSize()));
		body:setPosition(edgeShape:getContentSize().width*0.5,edgeShape:getContentSize().height*0.5)
		self:addChild(body)


		local function onTouchBegan(touch, event)

			local pt = touch:getLocation();  
			print("11111111",pt.x,pt.y)
			local body = display.newSprite("JoystickNorm.png")
			body:setPhysicsBody(cc.PhysicsBody:createBox(body:getContentSize()));
			body:setPosition(pt.x,pt.y)
			self:addChild(body)
			return ret
		end
		local function onTouchEnded(touch, event)
			print("onTouchEnded : "..self._viewID)
			if self.touchEnd then self:touchEnd(touch, event) end
		end
		self._listener = cc.EventListenerTouchOneByOne:create()
		self._listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
		self._listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	    self._listener:setSwallowTouches(true)
	    local eventDispatcher = self:getEventDispatcher()
	    eventDispatcher:addEventListenerWithSceneGraphPriority(self._listener, self)

	end


	




	function Battlefield:star(params)
		self.view = LoadingView.new(params,self)--阵容中武将
		self:addChild(self.view)

		print("加载了loading33333333333333")
	end

	return Battlefield;
end