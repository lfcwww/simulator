if not BattleActor then
        cc.exports.BattleActor= class("BattleActor",ActorBase);

    local Animationspeed = 1.0/30.0;

    local movedir = 1

    BattleActor.state = {
    	stand = "stand",
    	run = "run",
	}

	function BattleActor:ctor(param)

		local modelId = 1 --模型ID

		self.m_AngleRad = 0

		self:BuilModel(modelId)

		self:schedule(handler(self, self.UpdataState), Animationspeed)
	end

	function BattleActor:BuilModel(modelId)
		print("1111111111111111")
		BattleActor.super.ctor(self, modelId);
	end

	

	function BattleActor:UpdataState()


	end


	function BattleActor:setRoleAngle(angle)
		self:setRotation(angle)
		self.m_AngleRad = math.rad(angle)
	end

	function BattleActor:setRoleMove()
		local curX,curY = self:getPosition()
		local pos = self:getAnglePosition(movedir)
		local newPos = cc.pAdd(pos,cc.p(curX,curY))
        self:setPosition(newPos)
	end	

    function BattleActor:getAnglePosition(r)
    	print("---",r,self.m_AngleRad)
        local y = r*math.cos(self.m_AngleRad)
        local x = r*math.sin(self.m_AngleRad)
        return cc.p(x , y)
    end


	function BattleActor:setRoleStopMove()
		
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