
if not ViewMgr then

	import(".BaseLayer")
	local ViewMgr = class("ViewMgr")
	cc.exports.ViewMgr = ViewMgr

	local instance = nil
	function ViewMgr.getInstance()
	   	if instance == nil then
	   	  	instance = ViewMgr.new()
	   	end
	   	return instance
	end

	cc.exports.g_viewMgr = ViewMgr.getInstance

	function ViewMgr:ctor()
		--根节点
		self._root = nil
		--背景列表
		self._bgList = {}
		--view列表
		self._viewList = {}
		--记录打开的界面
		self._recordViewList = {}
	end

	function ViewMgr:printView()
		for k, v in pairs(self._viewList) do print("view : "..tostring(v._viewID)) end
	end

	--初始化
	function ViewMgr:initMgr(root)
		self._root = root
	end

	function ViewMgr:runView(viewID)
		print("加载view",viewID)

		local view = self:getViewByID(viewID, params)
		if view ~= nil then
			view:removeFromParent()
			self._root:addChild(view)
			self._viewList[viewID] = view
			self:recordOpenView(viewID)
		end
		return view
	end

	function ViewMgr:getViewByID(viewID, params)
		local view = self._viewList[viewID]
		if view == nil then
			view = self:createViewByID(viewID, params)
			if view then view:retain() end
		else
			view:updateUI(params)
		end
		return view
	end

	function ViewMgr:createViewByID(viewID, params)
		local view = nil
		local path = ViewConfig.viewPath[viewID]
		local ret, viewClass = pcall(require, path)
        print(viewClass)
		if ret then
			view = viewClass.new(viewID, params)
		else
			print("can not find the view path : "..viewID)
		end
		return view
	end

	function ViewMgr:recordOpenView(viewID)
		--先移除有可能重复的
		self:removeViewFromRecord(viewID)
		table.insert(self._recordViewList, viewID)
	end

	--从记录中移除
	function ViewMgr:removeViewFromRecord(viewID)
		local removeIndex = 0
		for index, id in pairs(self._recordViewList) do
			if viewID == id then removeIndex = index end
		end
		if removeIndex > 0 then
			table.remove(self._recordViewList, removeIndex)
		end
	end



end