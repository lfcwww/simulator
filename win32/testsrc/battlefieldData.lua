if not battlefieldData then

	local battlefieldData = class("battlefieldData")
	cc.exports.battlefieldData = battlefieldData

	local instance = nil;
	function battlefieldData:sharedData()
		if not instance then
			instance = battlefieldData.new()
		end
		return instance
	end

	function battlefieldData:ctor()
		self:init()
	end

	function battlefieldData:init()
		self.enemyRoleArray = {} --敌人列表
		self.playerRoleArray = {}--玩家列表

		self.setPlayerActor = nil --玩家自己

		self.enemyInfoList = {}
		self.playerInfoList = {}
	end


	function battlefieldData:setMyActor(Actor)
		self.setPlayerActor = Node
	end
	function battlefieldData:getMyActor()
		return self.setPlayerActor
	end


	function battlefieldData:getEnemyActor()
		return self.enemyRoleArray
	end
	function battlefieldData:insertEnemyActor(enemy)
		table.insert(self.enemyRoleArray, enemy)
	end
	function battlefieldData:removeEnemyActor(index)
		table.remove(self.enemyRoleArray,index)
	end

	function battlefieldData:getplayerActor()
		return self.playerRoleArray
	end
	function battlefieldData:insertplayerActor(enemy)
		table.insert(self.playerRoleArray, enemy)
	end


	function battlefieldData:setEnemyInfoList(list)
		self.enemyInfoList = list
	end
	--考虑网络玩家数据如何发送
	function battlefieldData:setPlayerInfoList(list)
		self.playerInfoList = list
	end
	function battlefieldData:getPlayerInfoList()
		return self.playerInfoList
	end
	


end