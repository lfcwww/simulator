if not BattlefieldData then

	local BattlefieldData = class("BattlefieldData")
	cc.exports.BattlefieldData = BattlefieldData

	local instance = nil;
	function BattlefieldData:sharedData()
		if not instance then
			instance = BattlefieldData.new()
		end
		return instance
	end

	function BattlefieldData:ctor()
		self:init()
	end

	function BattlefieldData:init()
		self.enemyRoleArray = {} --敌人列表
		self.playerRoleArray = {}--玩家列表

		self.setPlayerActor = nil --玩家自己

		self.enemyInfoList = {}
		self.playerInfoList = {}
	end


	function BattlefieldData:setMyActor(Actor)
		self.setPlayerActor = Node
	end
	function BattlefieldData:getMyActor()
		return self.setPlayerActor
	end


	function BattlefieldData:getEnemyActor()
		return self.enemyRoleArray
	end
	function BattlefieldData:insertEnemyActor(enemy)
		table.insert(self.enemyRoleArray, enemy)
	end
	function BattlefieldData:removeEnemyActor(index)
		table.remove(self.enemyRoleArray,index)
	end

	function BattlefieldData:getplayerActor()
		return self.playerRoleArray
	end
	function BattlefieldData:insertplayerActor(enemy)
		table.insert(self.playerRoleArray, enemy)
	end


	function BattlefieldData:setEnemyInfoList(list)
		self.enemyInfoList = list
	end
	--考虑网络玩家数据如何发送
	function BattlefieldData:setPlayerInfoList(list)
		self.playerInfoList = list
	end
	function BattlefieldData:getPlayerInfoList()
		return self.playerInfoList
	end
	


end