--
-- Author: Liufc
-- Date: 2017-05-17 18:04:52
-- 每日积分奖励
if not GroupRewardViewtest then

	local GroupRewardViewtest = class("GroupRewardViewtest", function() return display.newLayer() end)
	cc.exports.GroupRewardViewtest = GroupRewardViewtest

	function GroupRewardViewtest:ctor(viewID, params)
		print("111111111")
		self.battlerolemgr = BattleRoleMgr.new():addTo(self)
		self.myObject = self.battlerolemgr:buildMyRole()
		print("2222222222")

		self.myJoystick = self.battlerolemgr:buildJoystick()

	end


	-- --只做初始化工作
	-- function GroupRewardViewtest:initUI(params)
	-- 	BattleRoleLayerMgr.new()


	-- 	local studio = CcFuns.uiloaderAndMatchScreen("Instance.InstanceRewardView", true)
	-- 	self:addChild(studio.root)
	-- 	self.txtStar = CcFuns.seekNodeByName(studio.root, "txtStar")
	-- 	self.rewardListView = CcFuns.seekNodeByName(studio.root, "rewardListView")
	-- end

	-- --赋值等改变的操作都在这里
	-- function GroupRewardViewtest:updateUI(params)
 --       	self.Joystick_Wheel = Joystick:new()
 --       	self:addChild(self.Joystick_Wheel)
 --       	self.Joystick_Wheel:setLocalPosition(100,100)
 --       	self.Joystick_Wheel:setFollowFinger(true)



 --       	self.role = BattleActor.new()
 --       	self:addChild(self.role)
 --       	self.role:setPosition(display.cx, display.cy)


	-- end




	return GroupRewardViewtest

end