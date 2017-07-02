
if not Battlefield then

	ViewConfig.viewPath["Battlefield"] = "app.modules.battlefield.Battlefield";

	local Battlefield = class("Battlefield", BaseLayer);
	cc.exports.Battlefield = Battlefield;

	function Battlefield:ctor(viewID, params)
	    self:initUI()
	end	

	function Battlefield:initUI( )
		self.battlerolemgr = BattleRoleMgr.new():addTo(self)
		self.tmxMap = cc.TMXTiledMap:create("map22.tmx"):addTo(self,-1)
		self.battlerolemgr:setStandMap(self.tmxMap)

		self.myObject = self.battlerolemgr:buildMyRole()
		self.myJoystick = self.battlerolemgr:buildJoystick()

		self.battlerolemgr:initEnemyRole()






-- 分类： cocos2d-lua  
 

-- local map = cc.TMXTiledMap:create("res/10.tmx")

--     self:addChild(map)




-- local group = map:getObjectGroup("board1")

-- local objects = group:getObjects()




-- local dict = nil

-- local i = 0

-- local len = table.getn(objects)




-- for i=0,len-1,1 do

--     dict = objects[i+1]

--     if dict == nil then

--         break

--     end

-- dump(dict)




		
	end

	




	function Battlefield:star(params)
		self.view = LoadingView.new(params,self)--阵容中武将
		self:addChild(self.view)

		print("加载了loading33333333333333")
	end

	return Battlefield;
end