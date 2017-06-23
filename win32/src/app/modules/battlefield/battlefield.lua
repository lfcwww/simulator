
if not battlefield then

	ViewConfig.viewPath["battlefield"] = "app.modules.battlefield.battlefield";

	local battlefield = class("battlefield", BaseLayer);
	cc.exports.battlefield = battlefield;

	function battlefield:ctor(viewID, params)
	       self:initUI()
	end

	function battlefield:initUI( )
		self.background = display.newSprite("guozhan_new.jpg")
		self:addChild(self.background)
		self.background:setPosition(display.cx, display.cy)

	   	cc.Label:createWithSystemFont("战场", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)


       	self.Joystick_Wheel = Joystick:create()
       	self:addChild(self.Joystick_Wheel)
       	self.Joystick_Wheel:setPosition(100,100)

       	self.Joystick_Aim = Joystick:create()
       	self:addChild(self.Joystick_Aim)
       	self.Joystick_Aim:setPosition(display.width-300,100)
	end


	




	function battlefield:star(params)
		self.view = LoadingView.new(params,self)--阵容中武将
		self:addChild(self.view)

		print("加载了loading33333333333333")
	end

	return battlefield;
end