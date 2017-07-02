
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"


cc.FileUtils:getInstance():addSearchPath("res/pic/map/")
cc.FileUtils:getInstance():addSearchPath("res/pic/role/")
cc.FileUtils:getInstance():addSearchPath("res/pic/ui/")
cc.FileUtils:getInstance():addSearchPath("res/pic/fontpic/")
cc.FileUtils:getInstance():addSearchPath("res/pic/tiledMap/")

cc.FileUtils:getInstance():addSearchPath("res/music/")
cc.FileUtils:getInstance():addSearchPath("res/font/")

local function main()
    require("app.TanksWarApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
