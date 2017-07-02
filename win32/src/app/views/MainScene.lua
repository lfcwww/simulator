
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
     g_viewMgr():initMgr(self)
     g_viewMgr():runView("Battlefield")
end


return MainScene
