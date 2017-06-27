if not BattleActor then
        cc.exports.BattleActor= class("BattleActor",ActorBase);
    local Animationspeed = 1.0/30.0;

	function BattleActor:ctor(param)

		local modelId = 1 --模型ID
		self:BuilModel(modelId)

		self:schedule(handler(self, self.UpdataState), Animationspeed)
	end

	function BattleActor:BuilModel(modelId)
		print("1111111111111111")
		BattleActor.super.ctor(self, modelId);
	end



	function BattleActor:init()
		self:setName()
		self:setHp()
	end


	function BattleActor:setName()

	end

	function BattleActor:setHp()

	end



end