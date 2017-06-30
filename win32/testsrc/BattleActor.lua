if not BattleActor then
        cc.exports.BattleActor= class("BattleActor",ActorBase);

    local Animationspeed = 1.0/30.0;

    local moveLength = 4 

    local bulletInterval = 1 --发射间隔

    BattleActor.state = {
    	stand = "stand",
    	run = "run",
	}

	function BattleActor:ctor(param)

		local modelId = 1 --模型ID

		self.m_AngleRad = 0

		self._state = BattleActor.state.stand

		self._sendBullet = false
		self.curUpdatetime = 0
		self.sandBulletTime = 0

		self:BuilModel(modelId)

		self:schedule(handler(self, self.UpdataMachine), Animationspeed)
	end

	function BattleActor:BuilModel(modelId)
		BattleActor.super.ctor(self, modelId);
	end

	
	function BattleActor:UpdataMachine()
		self.curUpdatetime = self.curUpdatetime + Animationspeed
		if self._state ==  BattleActor.state.stand then

		elseif self._state ==  BattleActor.state.run then
			self:setRoleMove()
		end

		if self._sendBullet then
			if self.curUpdatetime - self.sandBulletTime > bulletInterval then
				self:Shooting()
				self.sandBulletTime = self.curUpdatetime
			end
		end
		
	end

	function BattleActor:_setMoveState(state)
		self._state = state
	end
	function BattleActor:_setRoleBodyAngle(angle)
		self.BodySprite:setRotation(angle)
		self.m_AngleRad = math.rad(angle)
	end


	function BattleActor:_setWeaponEnd()
		self._sendBullet = false
	end
	function BattleActor:_setRoleWeaponAngle(angle)
		self.EquipSprite:setRotation(angle)
		self.m_WeaponAngle = math.rad(angle)

		self._sendBullet = true
	end


	function BattleActor:setRoleMove()
		local curX,curY = self:getPosition()
		local pos = self:getAnglePosition(moveLength)
		local newPos = cc.pAdd(pos,cc.p(curX,curY))
        self:setPosition(newPos)
	end	

	function BattleActor:setRoleStopMove()
		print("停止移动,")
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

	--被炸
	function BattleActor:setBoom()
		return self:removeSelf();
	end

	
--------
--射击--
--------	
	function BattleActor:Shooting()
		local paramTab = {}
		paramTab.parentAddr = self
		paramTab.bulletId = 1002
		paramTab.Angle = self.m_WeaponAngle

		g_tipsMgr:ShowTips("111   "..self.m_WeaponAngle)
		-- paramTab.startpos = cc.p(self.getPositionX(),self:getPositionY())

		local bullet = Bullet.new(paramTab)
		bullet:setPosition(self:getPositionX(), self:getPositionY())
		self:getParent():addChild(bullet)
	end
	

	





end