
if not Loading then

	ViewConfig.viewPath["Loading"] = "app.modules.loading.Loading";

	local Loading = class("Loading", BaseLayer);
	cc.exports.Loading = Loading;

	print("加载了loading")

	function Loading:ctor(viewID, params)
	    cc.Label:createWithSystemFont("横扫三国", "Arial", 40)
	        :move(display.cx, display.cy + 200)
	        :addTo(self)
	        print("加载了loading22222222222222")
	end

	function Loading:star(params)
		self.view = LoadingView.new(params,self)--阵容中武将
		self:addChild(self.view)

		print("加载了loading33333333333333")
	end

	return Loading;
end