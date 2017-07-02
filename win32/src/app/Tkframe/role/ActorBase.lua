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
		self:setContentSize(self.BodySprite:getContentSize())
	end

	function ActorBase:initSprite(_modelId)
		self:initBodySprite()
		self:initWeaponSprite()
	end

	function ActorBase:initBodySprite()

		self.BodySprite = display.newSprite(PictureConfig.pngPath[3])
		self.BodySprite:setAnchorPoint(cc.p(0.5,0.5))
		self:addChild(self.BodySprite)
	end

	function ActorBase:initWeaponSprite()
		self.EquipSprite = display.newSprite(PictureConfig.pngPath[5])
		self.EquipSprite:setAnchorPoint(cc.p(0.5,0.3))
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