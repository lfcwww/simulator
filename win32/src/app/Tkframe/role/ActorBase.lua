if not ActorBase then
	cc.exports.ActorBase = class("ActorBase", function() return display.newNode() end)
	ActorBase.Animationspeed = 1.0/30.0;
	local Zorder = {}

	ActorBase.Status = {
		--待机
		stand = 1,
		--跑步
		run = 3,

	}

	ActorBase.Status = {
		--
		
	}

	function ActorBase:ctor()
		self:initSprite()
	end

	function ActorBase:initSprite(_modelId)
		self:initBodySprite()
		self:initEquipSprite()
	end

	function ActorBase:initBodySprite()

		self.BodySprite = display.newSprite("#gongyong_goumaikuang_4.png")
		self.BodySprite:setAnchorPoint(cc.p(0.5,0.5))
		self:addChild(self.BodySprite)
		self.BodySprite:setScale(0.7)
	end

	function ActorBase:initEquipSprite()
		self.EquipSprite = display.newSprite("#gongyong_di_3.png")
		self.EquipSprite:setAnchorPoint(cc.p(0.5,0.5))
		self:addChild(self.EquipSprite)

	end


	function ActorBase:setBodyModel(ModelId)

	end

	function ActorBase:setEquipModel(ModelId)

	end

	--设置身体旋转
	function ActorBase:setEquipRotation()

	end
	--设置武器旋转
	function ActorBase:setBodyRotation()

	end



end