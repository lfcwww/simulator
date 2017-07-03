--瓦片地图 --http://happysoul.iteye.com/blog/2279627
--不能行走区
--碰撞检测 http://www.cocoachina.com/bbs/read.php?tid=221969     Cocos2d-x3.2总结(四)使用物理引擎进行碰撞检测 
--AI 	1--http://blog.csdn.net/itcastcpp/article/details/17533421
--		2--http://www.cocoachina.com/game/20150810/12962.html
--
--
if not BattleRoleMgr then

	local BattleRoleMgr = class("BattleRoleMgr", function() return display.newLayer() end)
	cc.exports.BattleRoleMgr = BattleRoleMgr

	function BattleRoleMgr:ctor(node)
		self.standMap = node
		self.playerRole = nil
		self.FollowPointRole = nil

		BattlefieldData:sharedData():init()

		self.JoystickWheel_angle = 0
	end

	function BattleRoleMgr:registerFollowPoint(role)
		if self.FollowPointRole then
			self.FollowPointRole:_registerFollow(nil)
		end
		if role then
			role:_registerFollow(handler(self, self.UpdateMapFollowPoint))
			self.FollowPointRole = role
		end
	end

	function BattleRoleMgr:UpdateMapFollowPoint(pos)
		local worldPoint = self.standMap:convertToWorldSpace(pos)
		local offsetX = display.cx - worldPoint.x
		local offsetY = display.cy - worldPoint.y
		local destX = self.standMap:getPositionX() + offsetX
		local destY = self.standMap:getPositionY() + offsetY
		if destX > 0 then
			destX = 0
		end
		if destX < -(self.standMap:getContentSize().width - display.width) then
			destX = -(self.standMap:getContentSize().width - display.width)
		end
		if destY > self.standMap:getContentSize().height / 2 then
			destY = self.standMap:getContentSize().height / 2
		end
		if destY < display.height - self.standMap:getContentSize().height / 2 then
			destY = display.height - self.standMap:getContentSize().height / 2
		end
		self.standMap:setPositionX(destX)
		self.standMap:setPositionY(destY)
	end

	function BattleRoleMgr:buildMyRole(pos)
		if not self.playerRole then
	       	local Role = BattleActor.new()
	       	self.standMap:addChild(Role)
	       	Role:setPosition(pos or cc.p(display.cx,display.cy))
	       	self.playerRole = Role
	       	BattlefieldData:sharedData():setMyActor(self.playerRole)
	       	self:registerFollowPoint(self.playerRole)
	    end
	    return self.playerRole
	end

	function BattleRoleMgr:initEnemyRole(pos)
		local poslist = {
			[1] = cc.p(100,500),
			-- [2] = cc.p(300,200),
			-- [3] = cc.p(700,550),
		}
		for i=1,#poslist do
			local posx = poslist[i].x--math.random(0,960)
			local posy = poslist[i].y--math.random(0,640)
			local role = self:addEnemyRole(cc.p(posx,posy))
			BattlefieldData:sharedData():insertEnemyActor(role)
		end
	end

	function BattleRoleMgr:addEnemyRole(pos)
       	local Role = BattleActor.new()
       	self.standMap:addChild(Role)
       	Role:setPosition(pos or cc.p(display.cx,display.cy))
       	return Role
	end

	function BattleRoleMgr:addPlayerRole(pos)

	end




	function BattleRoleMgr:check(pos)

	end


---------------
--遥感控制器---
---------------
	function BattleRoleMgr:buildJoystick(pos)
       	self.Joystick_Wheel = Joystick:new()
       	self:addChild(self.Joystick_Wheel)
       	self.Joystick_Wheel:setWorldPosition(100,100)
       	self.Joystick_Wheel:setFollowFinger(true)
       	self.Joystick_Wheel:onTouch(function ( eventName, angleScore )
       		self.JoystickWheel_angle = self:toCocosRotation(angleScore)
			self.playerRole:_setRoleBodyAngle(self.JoystickWheel_angle)
			if eventName == Joystick.touchEvent.Moved then
				self.playerRole:_setMoveState(BattleActor.state.run)
			elseif eventName == Joystick.touchEvent.Ended then
				self.playerRole:_setMoveState(BattleActor.state.stand)
			end
			
       	end)

       	self.Joystick_Weapon = Joystick:new()
       	self:addChild(self.Joystick_Weapon)
       	self.Joystick_Weapon:setPosition(display.cx, 0)
       	self.Joystick_Weapon:setWorldPosition(display.width-100,100)
       	self.Joystick_Weapon:setFollowFinger(true)
       	self.Joystick_Weapon:onTouch(function ( eventName, angleScore )
       		self.JoystickWeapon_angle = self:toCocosRotation(angleScore)
			self.playerRole:_setRoleWeaponAngle(self.JoystickWeapon_angle)
			if eventName == Joystick.touchEvent.Ended then
				self.playerRole:_setWeaponEnd()
			end
			-- self.playerRole:set
       	end)
	end


	-- gongyong_xuanxiangka_jiantou.png


	function BattleRoleMgr:toCocosRotation(_Score)
		local Score = math.deg(_Score)
		Score = 90-Score
		if Score > 180 then
			Score = Score - 360
		end
		return Score
	end



	return BattleRoleMgr

end