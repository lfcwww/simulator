
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("pic/map/chuangjiao_ditu.jpg")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("横扫三国", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

end

return MainScene
