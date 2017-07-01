if not Bullet then
	cc.exports.Bullet = class("Bullet", function() return display.newNode() end)
	local Animationspeed = 1.0/30.0;

	Bullet.Status = {
		ready = 1,
		fly = 2,
		boom = 3,
	}


	function Bullet:ctor(param)
		self.bulletId = param.bulletId --配置ID
		self.parentAddr = param.parent --
		self.Angle = param.Angle	   --
		self.startpos = param.startpos

		self._state = Bullet.Status.ready
		self._curFlyDist = 0

		self:initSprite()

		self:setContentSize(self.BulletSp:getContentSize())
	
		self:schedule(handler(self, self.UpdataMachine), Animationspeed)
	end

	function Bullet:initSprite(_modelId)
		self.BulletSp = display.newSprite("#gongyong_liaotian_jiantou_1.png")
		self.BulletSp:setAnchorPoint(cc.p(0.5,0.5))
		-- self.BulletSp:setPosition(self.startpos)
		self:addChild(self.BulletSp)
		self.BulletSp:setScale(1.2)

		self.BulletSp:setRotation(math.deg(self.Angle))
		self._state = Bullet.Status.fly
	end


	function Bullet:UpdataMachine()
		if Bullet.Status.ready == self._state then

		elseif Bullet.Status.fly == self._state then
			self:updateBulletFly()
		elseif Bullet.Status.boom == self._state then

		end

		self:CheckboundingBox()
	end

	function Bullet:CheckboundingBox()
		local EnemyArray = BattlefieldData:sharedData():getEnemyActor()
		local BulletRect = self:getTouchRect()
		-- dump(EnemyArray)
		for i,v in ipairs(EnemyArray) do
			local EnemyRect = v:getTouchRect()
			-- dump(EnemyRect)
			-- dump(BulletRect)
			if cc.rectIntersectsRect(EnemyRect, BulletRect) then
				g_tipsMgr:ShowTips("尚未弄跳转")
				if v.setBoom then
					v:setBoom()
					BattlefieldData:sharedData():removeEnemyActor(i)
				end
			end
		end

	end

	function Bullet:updateBulletFly()
		local moveLength = 4 --这个取配置
		local MaxLength = 300 --这个取配置
		local curX,curY = self:getPosition()
		local pos = self:getAnglePosition(moveLength)
		local newPos = cc.pAdd(pos,cc.p(curX,curY))
        self:setPosition(newPos)

        self._curFlyDist = self._curFlyDist + moveLength
        if self._curFlyDist > MaxLength then
        	self:removeSelf();
        end

        -- print("-------------------",self.Angle,curX,curY,pos.x,pos.y)
	end
	

    function Bullet:getAnglePosition(r)
        local y = r*math.cos(self.Angle)
        local x = r*math.sin(self.Angle)
        return cc.p(x , y)
    end
    return Bullet
end