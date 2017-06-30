
if not BattleRoleMgr then

	local BattleRoleMgr = class("BattleRoleMgr", function() return display.newLayer() end)
	cc.exports.BattleRoleMgr = BattleRoleMgr

	function BattleRoleMgr:ctor(background)
		self.standMap = background

		self.enemyRoleList = {} --敌人列表
		self.playerRoleList = {}--玩家列表

		self.enemyInfoList = {}
		self.playerInfoList = {}

		self.playerRole = nil

		self.JoystickWheel_angle = 0
	end



	function BattleRoleMgr:buildMyRole(pos)
		if not self.playerRole then
	       	local Role = BattleActor.new()
	       	self:addChild(Role)
	       	Role:setPosition(pos or cc.p(display.cx,display.cy))
	       	self.playerRole = Role
	    end
	    return self.playerRole
	end

	function BattleRoleMgr:addEnemyRole(pos)
       	local Role = BattleActor.new()
       	self:addChild(Role)
       	Role:setPosition(pos or cc.p(display.cx,display.cy))
       	self:insertEnemy(Role)
	end

	function BattleRoleMgr:addPlayerRole(pos)
	end







	function BattleRoleMgr:setStandMap(node)
		self.standMap = node
	end

	function BattleRoleMgr:setEnemyRoleGroup(list)
		self.enemyRoleList = list
	end

	function BattleRoleMgr:setPlayerRoleGroup(list)
		self.playerRoleList = list
	end

	function BattleRoleMgr:setEnemyInfoList(list)
		self.enemyInfoList = list
	end

	function BattleRoleMgr:insertEnemy(enemy)
		table.insert(self.enemyRoleList, enemy)
	end
	--考虑网络玩家数据如何发送
	function BattleRoleMgr:setPlayerInfoList(list)
		self.playerInfoList = list
	end

	function BattleRoleMgr:getPlayerInfoList()
		return self.playerInfoList
	end








---------------
--遥感控制器---
---------------
	function BattleRoleMgr:buildJoystick(pos)
       	self.Joystick_Wheel = Joystick:new()
       	self:addChild(self.Joystick_Wheel)
       	self.Joystick_Wheel:setLocalPosition(100,100)
       	self.Joystick_Wheel:setFollowFinger(true)
       	self.Joystick_Wheel:onTouch(handler(self, self.touchJoyStickCallback))
	end

	function BattleRoleMgr:touchJoyStickCallback(eventName, angleScore)
		self.JoystickWheel_angle = self:toCocosRotation(angleScore)
		self.playerRole:setRoleAngle(self.JoystickWheel_angle)
		if eventName == Joystick.touchEvent.Moved then
			self.playerRole:setRoleMove()
		elseif eventName == Joystick.touchEvent.Ended then
			self.playerRole:setRoleStopMove()
		end
			
	end

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