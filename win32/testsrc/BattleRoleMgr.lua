--瓦片地图
--不能行走区
--碰撞检测
--AI
-- http://www.cocoachina.com/bbs/read.php?tid=221969     Cocos2d-x3.2总结(四)使用物理引擎进行碰撞检测   
if not BattleRoleMgr then

	local BattleRoleMgr = class("BattleRoleMgr", function() return display.newLayer() end)
	cc.exports.BattleRoleMgr = BattleRoleMgr

	function BattleRoleMgr:ctor(background)
		self.standMap = background

		battlefieldData:sharedData():init()

		self.playerRole = nil

		self.JoystickWheel_angle = 0

		self:initEnemyRole()
	end

	function BattleRoleMgr:setStandMap(node)
		self.standMap = node
	end


	function BattleRoleMgr:buildMyRole(pos)
		if not self.playerRole then
	       	local Role = BattleActor.new()
	       	self:addChild(Role)
	       	Role:setPosition(pos or cc.p(display.cx,display.cy))
	       	self.playerRole = Role
	       	battlefieldData:sharedData():setMyActor(self.playerRole)
	    end
	    return self.playerRole
	end

	function BattleRoleMgr:initEnemyRole(pos)
		local poslist = {
			[1] = cc.p(100,500),
			[2] = cc.p(300,200),
			[3] = cc.p(700,550),
		}

		for i=1,3 do
			local posx = poslist[i].x--math.random(0,960)
			local posy = poslist[i].y--math.random(0,640)
			local role = self:addEnemyRole(cc.p(posx,posy))
			battlefieldData:sharedData():insertEnemyActor(role)
		end
	end


	


	function BattleRoleMgr:addEnemyRole(pos)
       	local Role = BattleActor.new()
       	self:addChild(Role)
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