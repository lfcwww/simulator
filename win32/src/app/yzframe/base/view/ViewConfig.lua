--
-- Author: xjz
-- Date: 2016-02-23 15:36:04
--

if not ViewConfig then

	local ViewConfig = {}
	cc.exports.ViewConfig = ViewConfig


	--定时检测删除间隔, 秒
	ViewConfig.timingDeleteInterval = 15

	--loading界面延迟显示秒数
	ViewConfig.loadingDelayShowSec = 0.3

	--根节点的顺序
	ViewConfig.rootOrder = {
		BG = 99, 				--背景
		UI = 100, 				--UI
		POP = 101,				--弹窗
		NOTICE = 102,			--跑马灯公告
		GUIDE = 103,			--引导&剧情
		LOADING = 104, 			--等待
		TIPS = 105,				--提示&公告
	}

	--子节点顺序
	ViewConfig.childOrder = {
		BG = -2, 				--背景
		NORMAL = 0, 			--正常的
	}


	--背景文件路径
	ViewConfig.bgPath = "pic/map/"

	--界面文件路径
	ViewConfig.viewPath = {}

	ViewConfig.data = {
	}


	

end