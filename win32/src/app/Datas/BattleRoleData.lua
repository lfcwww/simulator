--
-- Author: liufc
-- Date: 2016-04-12 11:04:05
--

if not RoleData then
	cc.exports.RoleData = class("RoleData")

	function RoleData:ctor(heroConfig)

		--封装主将
		if heroConfig then
			self.m_oId        =	0   ;								--对象id						--没用的
			self.m_id         =	heroConfig.m_heroID   				--基础id
			self.m_codeName   =	heroConfig.m_name 			--名称
			self.m_quality    =	heroConfig.m_quality   		--品质
			self.m_star    	  =	heroConfig.m_star
			-- self.m_quality 	  = HeroDataConfig.starToQuality[self.m_star]
			self.m_position   =	heroConfig.m_position			--位置, 攻方1-7，守方8-14
			self.m_type       =	0   ;							--类型, 0 武将 1 怪物 2 机器人  --没用的
			self.m_level      =	heroConfig.m_level  			--等级
			self.m_model      =	heroConfig.m_modelID			--模型
			self.m_profession     =	heroConfig.m_profession		--职业
			self.m_country = heroConfig.m_country --国家
			self.m_Gender = heroConfig.gender --性别
			self.m_power      =	heroConfig.m_power				--战斗力
			self.m_weapon     =	0   ;							--武器							--没用的字段
			self.isMainHero   =	heroConfig.m_isMain  
			self.m_curHp      		= heroConfig.m_HP 	--当前血量
			self.m_maxHp      		= heroConfig.m_HP	--满血量
			if not heroConfig.m_morale then
				self.m_curAnger = 0
			else
				self.m_curAnger   		= heroConfig.m_morale;--(heroConfig.m_position == BattleCamp.attack_Main_pos)  and 500 or  0  ;			--怒气
			end
			self.m_maxAnger   		= 1000  ;		--满怒气
			self.m_nearAttack		= heroConfig.m_ATN          	--物攻--
		    self.m_nearDefense		= heroConfig.m_DEF  			--物防--
		    self.m_strategyAttack	= heroConfig.m_INT   	    	--法攻--
		    self.m_strategyDefense	= heroConfig.m_RES  	    	--法防--
		    self.m_speed			= heroConfig.m_SPD				--速度
		    self.m_hitRate			= heroConfig.m_hit				--命中率--
		    self.m_dodgeRate		= heroConfig.m_dodge			--闪避率--
		    self.m_critRate			= heroConfig.m_crit		    	--暴击率--
		    self.m_blockRate		= heroConfig.m_block			--格挡率--
		    self.m_avoidHurtRate	= heroConfig.m_avoidHurtRate	--免伤率--
		    self.m_wreckRate		= heroConfig.m_wreck		    --破击率--
		    self.m_antiknockRate	= heroConfig.m_antiKnock	    --抗暴率--
		    self.m_hurtRate 		= heroConfig.m_hurtRate 		--伤害率--
		    self.m_attachRate 		= heroConfig.m_attachRate or 0	--攻击率--  
	    	self.m_defenceRate 		= heroConfig.m_defenceRate or 0	--防御率--
	    	self.m_recoverRate 		= heroConfig.m_remedyRate 	    --回复率--

	    	self.m_rateAdditions = {}; --记录加成值

			--普通技能
	    	self.m_normal = heroConfig.m_normalEffectID
	    	self.m_normalLv = 1
	    	--主动技能
	    	self.m_skillId = heroConfig.m_skillList[1]
	    	self.m_skillIdLv = heroConfig.m_skillLevelData[1]
	    	--天赋1
			--天赋技能
			-- 大于7星才有天赋技能
			self.m_talentskill = "";
			self.m_talentskillLv = 0;
			if heroConfig.m_star and heroConfig.m_star > 7 then
				self.m_talentskill = heroConfig.m_skillList[4]
				self.m_talentskillLv = heroConfig.m_skillLevelData[4];
			end
			--神兵技能
	    	-- local magicItem = MagicData.sharedData():getHeroOwnMagic(heroConfig.m_serverID)
	    	local magicItem = MagicalData.sharedData():getPetSkillByServerID(heroConfig.m_serverID)
	    	if magicItem then 
	    		self.m_magicId = magicItem.m_localId
	    		self.m_magicLv = magicItem.m_lv
	    	end
	   
	    	--绝学技能
	    	local superSkillList = OverSkillData:sharedData():getHeroOwnOverSkill(heroConfig.m_serverID)
	    	for _,skillItem in pairs(superSkillList) do
	    		if skillItem.m_isUsing == 1 then
	    			self.m_superskill  = skillItem.m_skillId
    			end
	    	end
			self.m_superskillLv = 1

			--天罡
			-- 可以有多个
			self:getlocalTianGangSkill(heroConfig.m_serverID)


			if (not self.m_normal) then
				self.m_normal = "S001"
			end
	    end
	    self.m_lastHitValue 	= 0;--最后一次受击数值
    	self.buff = {};
	 
	end

	function RoleData:getlocalTianGangSkill(heroServerId)
		--获取英雄的本地天罡技能
		self.m_TiangangskillLvList = {};
		self.m_TiangangskillList = {};
		-- local TGDataList = TianGangData.sharedData():getHeroOwnTianGang(heroServerId)
		-- for i,tgdata in ipairs(TGDataList) do
		-- 	table.insert(self.m_TiangangskillList, tgdata.m_skillId)
		-- 	self.m_TiangangskillLvList[tgdata.m_skillId] = ((tgdata.m_step or 0) + 1)
		-- end

	end
end


if not BattleRoleData then
	cc.exports.BattleRoleData = class("BattleRoleData",RoleData)

	function BattleRoleData:ctor(packet, data, heroConfig)
		
		self.super.ctor(self,heroConfig)


		if packet then
			self.m_oId       = packet[1]--'U32',	--对象id
			self.m_id        = packet[2]--'U32',	--基础id
			self.m_codeName  = packet[3]--'S',	--名称
			self.m_name = g_langUtils:getString(self.m_codeName)
			self.m_quality   = packet[4]--'U8',	--品质
			self.m_star      = self.m_quality
			-- self.m_quality 	  = HeroDataConfig.starToQuality[self.m_star]
			self.m_curHp     = packet[5]--'U32',	--当前血量
			self.m_maxHp     = packet[6]--'U32',	--满血量
			self.m_curAnger  = packet[7]--'U8',		--怒气 
			self.m_maxAnger  = packet[8]--'U8',		--满怒气
			self.m_position  = packet[9]--'U8',		--位置, 攻方1-7，守方8-14
			self.m_type      = packet[10]--'U8',	--类型, 0 武将 1 怪物 2 机器人
			self.m_level     = packet[11]--'U16',	--等级
			self.m_speed     = packet[12]--'U32',	--速度
			self.m_model     = packet[13]--'U16',	--模型
			self.m_career    = packet[14]--'U8',	--职业
			self.m_power     = packet[15]--'U32',	--战斗力
			self.m_skillId   = packet[16]--'S',		--技能
			self.m_skillIdLv = 1            		--技能等级
			-- self.m_weapon    = packet[17]--'U32',	--武器
			
			self.m_nearAttack		= packet[17] or self.m_nearAttack  --'U32',	--物理攻击
			self.m_nearDefense		= packet[18] or self.m_nearDefense --'U32',	--物理防御
			self.m_strategyAttack	= packet[19] or self.m_strategyAttack --'U32',	--策略攻击
			self.m_strategyDefense	= packet[20] or self.m_strategyDefense --'U32',	--策略防御
			self.m_hitRate			= packet[21] or self.m_hitRate --'U32',	--命中
			self.m_dodgeRate		= packet[22] or self.m_dodgeRate --'U32',	--闪避
			self.m_critRate			= packet[23] or self.m_critRate --'U32',	--暴击
			self.m_antiknockRate	= packet[24] or self.m_antiknockRate --'U32',	--抗暴
			self.m_blockRate		= packet[25] or self.m_blockRate --'U32',	--格挡
			self.m_wreckRate		= packet[26] or self.m_wreckRate --'U32',	--破击
			self.m_hurtRate			= packet[27] or self.m_hurtRate --'F',	--伤害率
			self.m_avoidHurtRate	= packet[28] or self.m_avoidHurtRate --'F',	--免伤率
			self.m_recoverRate		= packet[29] or self.m_recoverRate --'F',	--回复率
			self.m_backHurtRate		= packet[30] or self.m_backHurtRate --'F',	--反伤率                			--服务端新定义的基类没有的
			self.m_attachRate		= packet[31] or self.m_attachRate  --'F',	--攻击率
			self.m_defenceRate		= packet[32] or self.m_defenceRate --'F',	--防御率
			self.m_antiknockHurtRate= packet[33] or self.m_antiknockHurtRate--'F',	--暴击伤害率					--服务端新定义的基类没有的
			self.m_normal = packet[34] or self.m_normal
			-- if GlobalConfig.heroconfig[self.m_id] then
			-- 	self.m_normal = GlobalConfig.heroconfig[self.m_id].baseSkill
			-- end
		end

		if self.m_quality <=0 or self.m_quality>8 then
			print("ERROR! ---武将的品质错误",self.m_quality)
			self.m_quality = 1
		end

		--属性增量
		self:initRateAdditions()

		if not self.m_model then
			self.m_model = 17
		end
		
		if (not self.m_normal) then
			self.m_normal = "S001"
			self.m_normalLv = 1
		end

	    self.isMainHero = false;
	    self.m_Post = BattleCamp.getPositionPost(self.m_position);

		self.m_Camp = BattleCamp.getPosType(self.m_position);

		local modelConfig = GlobalConfig.s_modelconfig[self.m_model]
	    if not modelConfig then
	    	local str = "战报发的模型ID错误 = "..self.m_model
			g_tipsMgr:ShowErrorTips(str);
	    end

	    --性别
	    self.m_Gender = modelConfig.gender;

	    --标记主将
		if data and self.m_position == data.m_offenceMainGeneralPos then
	        self.isOffenceMain = true;
	    end;
	    if data and self.m_position == data.m_defenceMainGeneralPos then
	        if self.m_name ~= self.m_codeName then
	            self.isBoss = true;
	        end;
	        self.isDefenceMain = true;
	    end;

	    if data and self.m_id == self.m_model then
	    	local herodata = GlobalConfig.heroconfig[self.m_id]
	    	if herodata then
	    		self.m_model = herodata.modelId
	    	end
	    end

	    self.skillRule = true--默认优先施放技能

	end


	function BattleRoleData:getnearAttack()--物攻
		return self.m_nearAttack		
	end
	function BattleRoleData:getnearDefense()--物防
		return self.m_nearDefense		
	end
	function BattleRoleData:getstrategyAttack() --策攻
		return self.m_strategyAttack	
	end
	function BattleRoleData:getstrategyDefense() --策防
		return self.m_strategyDefense	
	end
	function BattleRoleData:getspeed()--速度
		return self.m_speed			
	end
	function BattleRoleData:gethurtRate()--伤害率
		return self.m_hurtRate			
	end
	function BattleRoleData:getattachRate()--攻击率
		return self.m_attachRate
	end
	function BattleRoleData:getdefenceRate()--防御率
		return self.m_defenceRate
	end
	function BattleRoleData:getrecoverRate()--回复率
		return self.m_recoverRate
	end
	function BattleRoleData:gethitRate()--命中率
		return self.m_hitRate			
	end
	function BattleRoleData:getdodgeRate()--闪避率
		return self.m_dodgeRate		
	end
	function BattleRoleData:getcritRate()--暴击率
		return self.m_critRate			
	end
	function BattleRoleData:getblockRate()--格挡率
		return self.m_blockRate		
	end
	function BattleRoleData:getavoidHurtRate()--免伤率
		return self.m_avoidHurtRate	
	end
	function BattleRoleData:getwreckRate()--破击率
		return self.m_wreckRate		
	end
	function BattleRoleData:getantiknockRate()--抗暴率
		return self.m_antiknockRate	
	end
	function BattleRoleData:getcurHp() --当前血量
		return self.m_curHp
	end
	function BattleRoleData:getcurAnger() --当前怒气
		return self.m_curAnger
	end
	function BattleRoleData:getskillId() --技能
		return self.m_skillId
	end
	function BattleRoleData:getfightbackRate() --反伤率
		return self.m_fightbackRate;
	end
	function BattleRoleData:getlastHitValue()--最后一次受击数值
		return self.m_lastHitValue;
	end


	function BattleRoleData:setnearAttack(value)--物攻
		self.m_nearAttack = value;
	end
	function BattleRoleData:setnearDefense(value)--物防
		self.m_nearDefense	= value;
	end
	function BattleRoleData:setstrategyAttack(value)  --策攻
		self.m_strategyAttack = value;
	end
	function BattleRoleData:setstrategyDefense(value) --策防
		self.m_strategyDefense = value;
	end
	function BattleRoleData:setspeed(value)--速度
		self.m_speed = value;
	end
	function BattleRoleData:sethurtRate(value)--伤害率
		self.m_hurtRate	= value;		
	end
	function BattleRoleData:setattachRate(value)--攻击率
		self.m_attachRate = value;
	end
	function BattleRoleData:setdefenceRate(value)--防御率
		self.m_defenceRate = value;
	end
	function BattleRoleData:setrecoverRate(value)--回复率
		self.m_recoverRate = value;
	end
	function BattleRoleData:sethitRate(value)--命中率
		self.m_hitRate = value;
	end
	function BattleRoleData:setdodgeRate(value)--闪避率
		self.m_dodgeRate = value;
	end
	function BattleRoleData:setcritRate(value)--暴击率
		self.m_critRate	= value;
	end
	function BattleRoleData:setblockRate(value)--格挡率
		self.m_blockRate = value;
	end
	function BattleRoleData:setavoidHurtRate(value)--免伤率
		self.m_avoidHurtRate = value;
	end
	function BattleRoleData:setwreckRate(value)--破击率
		self.m_wreckRate = value;
	end
	function BattleRoleData:setantiknockRate(value)--抗暴率
		self.m_antiknockRate = value;
	end
	function BattleRoleData:setcurHp(value) --当前血量
		self.m_curHp = value
	end
	function BattleRoleData:setcurAnger(value) --当前怒气
		self.m_curAnger = value
	end
	function BattleRoleData:setskillId(value) --技能
		self.m_skillId = value
	end
	function BattleRoleData:setfightbackRate(value) -- 反伤率
		self.m_fightbackRate = value
	end
	function BattleRoleData:setlastHitValue(value)--最后一次受击数值
		self.m_lastHitValue = value;
	end




	function BattleRoleData:processHp(value) --血量
		local val = self.m_curHp + value;

		if val < 0 then val = 0; end
		if val > self.m_maxHp then val = self.m_maxHp end

		self:setcurHp(val)
	end


	--return   
	--@param "rabbi"策略法师   
	--@param "Strength" 力量
	function BattleRoleData:getprofession() --获取职业分类

		if self.m_profession == 1 
			or self.m_profession == 2 
			or self.m_profession == 3 then
			return "Strength"

		elseif self.m_profession == 4
			or self.m_profession == 5 then
			return "rabbi"
		end

	end

	function BattleRoleData:setValueByType(propType, value)
		if propType == BattleConfig.propertyType.PROP_HP then-- HP
			self:setcurHp(value)
		elseif propType == BattleConfig.propertyType.PROP_ANGER then-- 士气
			self:setcurAnger(value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_HIT then-- 命中率
			self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_DODGY then-- 闪避率
			self:setdodgeRate(value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_CRIT then-- 暴击率
			self:setcritRate(value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_BLOCK then--格挡值-- 反伤
			self:setblockRate(value)
		elseif propType == BattleConfig.propertyType.PROP_STATUS then-- 晕眩 沉默
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_JOINT then -- 合击率
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_POSITION then -- 移位
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_SPEED then-- 速度
			self:setspeed(value)
		elseif propType == BattleConfig.propertyType.PROP_REWARD_ITEM then--死亡掉落
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_NEARATTACK then --物攻
			self:setnearAttack(value)
		elseif propType == BattleConfig.propertyType.PROP_NEARDEFENSE then --物防
	    	self:setnearDefense(value)
		elseif propType == BattleConfig.propertyType.PROP_STRATEGYATTACK then --法攻   
			self:setstrategyAttack(value)
		elseif propType == BattleConfig.propertyType.PROP_STRATEGYDEFENSE then --法防   
	    	self:setstrategyDefense(value)
		elseif propType == BattleConfig.propertyType.PROP_WRECKRATE then	--破击值
			self:setwreckRate(value)    
		elseif propType == BattleConfig.propertyType.PROP_HURTRATE then	--伤害值
			self:sethurtRate(value)    
		elseif propType == BattleConfig.propertyType.PROP_AVOIDHURTRATE then--免伤值
			self:setavoidHurtRate(value)
		elseif propType == BattleConfig.propertyType.PROP_ANTIKNOCKRATE then--抗暴值
			self:setantiknockRate(value)
		elseif propType == BattleConfig.propertyType.PROP_ATTACHRATE then--伤害率
			self:setattachRate(value)	    
		elseif propType == BattleConfig.propertyType.PROP_DEFENCERATE then--免伤率
			self:setdefenceRate(value)	    
		elseif propType == BattleConfig.propertyType.PROP_RECOVERRATE then--回复率 / 治疗率
			self:setrecoverRate(value)	    
		elseif propType == BattleConfig.propertyType.PROP_FIGHTBACKRATE then--反伤率
			self:setfightbackRate(value)	    
		end
	end

	function BattleRoleData:addValueByType(propType, value)
		if propType == BattleConfig.propertyType.PROP_HP then-- HP
			local resValue = self:getcurHp()+value
			resValue = math.min(self.m_maxHp, resValue)
			resValue = math.max(0, resValue)

				-- local str = self.m_position.." 伤害:  "..value.."剩余血量:"..resValue
				-- print("ERROR!!!!    ",str)
		
			self:setcurHp(resValue)
		elseif propType == BattleConfig.propertyType.PROP_ANGER then-- 士气
			local resValue = self:getcurAnger()+value
			resValue = self.m_position < BattleCamp.onlinePos_Scope and resValue or math.min(self.m_maxAnger, resValue)
			resValue = math.max(0, resValue)
			self:setcurAnger(resValue)
		elseif propType == BattleConfig.propertyType.PROP_RATE_HIT then-- 命中率
			self:sethitRate(self:gethitRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_DODGY then-- 闪避率
			self:setdodgeRate(self:getdodgeRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_CRIT then-- 暴击率
			self:setcritRate(self:getcritRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_BLOCK then--格挡值-- 反伤
			self:setblockRate(self:getblockRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_STATUS then-- 晕眩 沉默
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_RATE_JOINT then -- 合击率
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_POSITION then -- 移位
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_SPEED then-- 速度
			self:setspeed(self:getspeed() + value)
		elseif propType == BattleConfig.propertyType.PROP_REWARD_ITEM then--死亡掉落
			-- self:sethitRate(value)
		elseif propType == BattleConfig.propertyType.PROP_NEARATTACK then --物攻
			self:setnearAttack(self:getnearAttack() + value)
		elseif propType == BattleConfig.propertyType.PROP_NEARDEFENSE then --物防
			self:setnearDefense(self:getnearDefense() + value)
		elseif propType == BattleConfig.propertyType.PROP_STRATEGYATTACK then --法攻   
			self:setstrategyAttack(self:getstrategyAttack() + value)
		elseif propType == BattleConfig.propertyType.PROP_STRATEGYDEFENSE then --法防   
			self:setstrategyDefense(self:getstrategyDefense() + value)
		elseif propType == BattleConfig.propertyType.PROP_WRECKRATE then	--破击值
			self:setwreckRate(self:getwreckRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_HURTRATE then	--伤害值
			self:sethurtRate(self:gethurtRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_AVOIDHURTRATE then--免伤值
			self:setavoidHurtRate(self:getavoidHurtRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_ANTIKNOCKRATE then--抗暴值
			self:setantiknockRate(self:getantiknockRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_ATTACHRATE then--伤害率
			self:setattachRate(self:getattachRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_DEFENCERATE then--免伤率
			self:setdefenceRate(self:getdefenceRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_RECOVERRATE then--回复率 / 治疗率
			self:setrecoverRate(self:getrecoverRate() + value)
		elseif propType == BattleConfig.propertyType.PROP_FIGHTBACKRATE then--反伤率
			self:setfightbackRate(self:getfightbackRate() + value)
		end
	end


	function BattleRoleData:getValueByType(propType)
		if propType == BattleConfig.propertyType.PROP_HP then-- HP
			return self:getcurHp()
		elseif propType == BattleConfig.propertyType.PROP_ANGER then-- 士气
			return self:getcurAnger()
		elseif propType == BattleConfig.propertyType.PROP_RATE_HIT then-- 命中率
			return self:gethitRate()
		elseif propType == BattleConfig.propertyType.PROP_RATE_DODGY then-- 闪避率
			return self:getdodgeRate()
		elseif propType == BattleConfig.propertyType.PROP_RATE_CRIT then-- 暴击率
			return self:getcritRate()
		elseif propType == BattleConfig.propertyType.PROP_RATE_BLOCK then--格挡值-- 反伤
			return self:getblockRate()
		elseif propType == BattleConfig.propertyType.PROP_STATUS then-- 晕眩 沉默
			-- return self:gethitRate()
		elseif propType == BattleConfig.propertyType.PROP_RATE_JOINT then -- 合击率
			-- return self:gethitRate()
		elseif propType == BattleConfig.propertyType.PROP_POSITION then -- 移位
			-- return self:gethitRate()
		elseif propType == BattleConfig.propertyType.PROP_SPEED then-- 速度
			return self:getspeed()
		elseif propType == BattleConfig.propertyType.PROP_REWARD_ITEM then--死亡掉落
			-- return self:gethitRate()
		elseif propType == BattleConfig.propertyType.PROP_NEARATTACK then --物攻
			return self:getnearAttack()
		elseif propType == BattleConfig.propertyType.PROP_NEARDEFENSE then --物防
	    	return self:getnearDefense()
		elseif propType == BattleConfig.propertyType.PROP_STRATEGYATTACK then --法攻   
			return self:getstrategyAttack()
		elseif propType == BattleConfig.propertyType.PROP_STRATEGYDEFENSE then --法防   
	    	return self:getstrategyDefense()
		elseif propType == BattleConfig.propertyType.PROP_WRECKRATE then	--破击值
			return self:getwreckRate()    
		elseif propType == BattleConfig.propertyType.PROP_HURTRATE then	--伤害值
			return self:gethurtRate()    
		elseif propType == BattleConfig.propertyType.PROP_AVOIDHURTRATE then--免伤值
			return self:getavoidHurtRate()
		elseif propType == BattleConfig.propertyType.PROP_ANTIKNOCKRATE then--抗暴值
			return self:getantiknockRate()
		elseif propType == BattleConfig.propertyType.PROP_ATTACHRATE then--伤害率
			return self:getattachRate()	    
		elseif propType == BattleConfig.propertyType.PROP_DEFENCERATE then--免伤率
			return self:getdefenceRate()	    
		elseif propType == BattleConfig.propertyType.PROP_RECOVERRATE then--回复率 / 治疗率
			return self:getrecoverRate()	    
		elseif propType == BattleConfig.propertyType.PROP_FIGHTBACKRATE then--反伤率
			return self:getfightbackRate()	    
		end
	end

	--设置buff
	function BattleRoleData:AddBuff(type, value, roundNum) 
		local m_buff = {};
		m_buff.m_type = type;
		m_buff.m_value = value;
		m_buff.m_lift = roundNum;

		table.insert(self.buff,m_buff);
	end

	function BattleRoleData:cheackBuff(type, value, roundNum) 


	end

	--属性增量
	function BattleRoleData:initRateAdditions()
		self.m_rateAdditions = {}
		for k,v in pairs(BattleConfig.propertyType) do
			self.m_rateAdditions[v] = 0;
		end
	end

	function BattleRoleData:addRateAddition(prop, value)
		self.m_rateAdditions[prop] = self.m_rateAdditions[prop] + value
	end

	function BattleRoleData:getRateAddition(prop)
		return self.m_rateAdditions[prop]
	end

	function BattleRoleData:getValueByTypeWithAddtion(prop)
		if self:getValueByType(prop) and self:getRateAddition(prop) then
			return self:getValueByType(prop) + self:getRateAddition(prop)
		end
	end

	function BattleRoleData:isSkillUsed(skillId)
		if not self.skillUsedMap then
			self.skillUsedMap = {}
		end
		if self.skillUsedMap[skillId] then
			return true
		end
		self.skillUsedMap[skillId] = true;
	end

end