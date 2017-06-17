

require "app.includeApp"

local TanksWarApp = class("TanksWarApp", cc.load("mvc").AppBase)

function TanksWarApp:onCreate()
    math.randomseed(os.time())
end

return TanksWarApp
