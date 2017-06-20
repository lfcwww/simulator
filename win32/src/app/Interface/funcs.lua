--
-- Author: liufc
-- Date: 2015-7-7
-- function: 零散的公共接口
--

if not funcs then
    funcs = class("funcs");


--创建动画
--format 格式化的图片名，例如M_25D_%d.png，通过string.format把%d赋值
--delay 图片播放间隔时间
--begin 图片名开始的帧ID，默认最大ID是20 
--返回 cc.Animation
function funcs.createAnimation(format,delay,begin)
    begin = begin or 0
    local ret
    local maxFrame = 20
    for i=begin,maxFrame do
        local spriteFrameName = string.format(format,i)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(spriteFrameName)
        if not frame then
            break
        end
        if not ret then
            ret = cc.Animation:create()
        end
        ret:addSpriteFrame(frame)
    end
    if ret then
        ret:setDelayPerUnit(delay)
    end
    return ret
end


--功能：获取文件全路径
--path：绝对路径
--返回：全路径
function funcs.isFileExist(path)
    if path == nil then
        return false
    end

    local cfile = cc.FileUtils:getInstance();
    return cfile:isFileExist(cfile:fullPathForFilename(path))
end



--通过品质，返回颜色，做武将名字颜色处理
function funcs.getQualitycolor(quality)
    -- body
   return baseTypes.QuantityToColor[tonumber(quality)]
end


---------------------传入1970-01-01 8am 到现在的秒数，转为"%Y-%m-%d %H:%M:%S" 如12秒返回1970-01-01 08:00:12@vinyin
---------------------小知识：1970-01-01是uinx诞生时间，北京位于东八区，北京时间8am即格林威治0点整，
function funcs.getDateBysecond(seconds, dateformat)
    local temp = dateformat or "%Y-%m-%d %H:%M:%S";
    return os.date(temp, seconds)
end
---------------------根据基姆拉尔森公式计算服务器属于星期几 @vinyin-----------------------
function funcs.getDaythBySecond(seconds)
    local date  = funcs.getDateBysecond(seconds);
    local year  = tonumber(string.sub(date,1,4));
    local month = tonumber(string.sub(date,6,7));
    local day   = tonumber(string.sub(date,9,10));

    local dayth = funcs.getDaythByYMD(year,month,day);
    return dayth;
end
---------------------根据基姆拉尔森公式计算yyyy-mm--dd属于星期几 @vinyin-----------------------
--{"1表示星期天","2是星期一","3是星期二","4是星期三","5是星期四","6是星期五","7是星期六"};
function funcs.getDaythByYMD(year,month,day)
    local y,m,d = year,month,day;
    local t = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if    m < 3 then--------- 一月，二月当上成上一年的13 14月处理
          y = y - 1;
    end
    local w = y + math.floor(y/4) - math.floor(y/100) +  math.floor(y/400) + t[m] + d;
    return math.mod(w,7) + 1;
end

function funcs.randomFloat(min, max, precision)
    precision = precision or 1
    local p = math.pow(10, precision)
    local r = math.random(min * p, max * p)
    return r / p
end
---------------------数组的逆序-----------------------
function funcs.reverseTable(tab)
  local tmp = {}
  for i = 1, #tab do
    local key = #tab
    tmp[i] = table.remove(tab)
  end

  return tmp
end
end


----------------------------------------------------------------
-- 以下是旧文件Functions.lua的实现方法,需要用到的请归类调出至manager文件中的各个方法集合中；
----------------------------------------------------------------
--[[
function funcs.splitNum(num,splitNum,retTable)
    local tempTable = {} ;

    if num==0 then
       for i=1,splitNum do 
          table.insert(retTable,0);
       end
       return retTable;
    end

    if num<0 then
       num = math.abs(num);
    end

    retTable = retTable or {};

    if splitNum<2 then
       table.insert(retTable,num);

       return retTable;
    end
    
    local ranTemp = 0;
    
    for i=1,splitNum-1 do 
       ranTemp= math.random(num);

       table.insert(tempTable,ranTemp);
    end

    table.sort(tempTable);

    table.insert(tempTable,num);

    local temp  = 0;
    local tempV = 0;
    for i,v in pairs(tempTable) do        
        tempV = v - temp;
        table.insert(retTable,tempV);
        
        temp = v;
    end

    table.sort(retTable);
    
    return retTable;
end

function funcs.splitStr(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
   if not nFindLastIndex then
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
    break
   end
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
   nSplitIndex = nSplitIndex + 1
  end
  return nSplitArray
end

--@return true if the file exists, otherwise it will return false.
function funcs.isFileExist(path)
    if path == nil then
        return false
    end

    local cfile = cc.FileUtils:getInstance();
    return cfile:isFileExist(cfile:fullPathForFilename(path))
end

function funcs.loadccb(owner,classname,path,obj)
    ccb[classname] = owner
    if obj then
        return CCBuilderReaderLoad(path, CCBProxy:create(), owner)
    end
    return CCBuilderReaderLoad(path, CCBProxy:create(), owner)
end

function funcs.ccbclass(classname,path,obj)
    local ret 
    ret = class(classname, function() return funcs.loadccb(ret,classname,path,obj) end)
    ret.__index = ret
    return ret
end

function funcs.loadPics(format)
    local maxFrame = 50
    for i=0,maxFrame do
        local filename = string.format(format,i)
        local tex = CCTextureCache:sharedTextureCache():addImage(filename)
        if not tex then
            break
        end
        local frame = CCSpriteFrame:createWithTexture(tex, CCRect(0, 0, tex:getContentSize().width, tex:getContentSize().height))
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFrame(frame, filename)
    end
end

function funcs.string2size(text,labelsize,stokesize)
    if(text==nil)then
        return CCSizeMake(stokesize*2, stokesize*2)
    end 

    local label=nil
    label =  CCLabelTTF:create(text, GlobalData.G_DEFAULT_FONT, 16)
    label:setAnchorPoint(ccp(0,0));
    label:setString(text);
            
    return CCSizeMake(label:getContentSize().width+stokesize*2, label:getContentSize().height+stokesize*2);
end

-- 以utf8字串长度分割字串
function funcs.splitutfstr(str,pos)
    local len  = #str
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(str, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
        if cnt == pos then 
            return {string.sub(str,1,len - left),string.sub(str,len - left+1)}
        end 
    end
    return {str}
end

-- 非日常任务，和特殊任务
function funcs.isSpecial(taskid)
    local head = string.sub(taskid,1,1)
    if head ~= "G" and head ~= "D" then 
        return false
    end 

    return true
end

function funcs.sortAttribute( attribute1,  attribute2)
    if(string.find(attribute1,"力量"))then 
        return true
    elseif(string.find(attribute2,"力量")) then
        return false
    end

   if(string.find(attribute1,"敏捷"))then 
        return true
    elseif(string.find(attribute2,"敏捷")) then
        return false
    end

   if(string.find(attribute1,"智力"))then 
        return true
    elseif(string.find(attribute2,"智力")) then
        return false
    end

   if(string.find(attribute1,"生命"))then 
        return true
    elseif(string.find(attribute2,"生命")) then
        return false
    end

   if(string.find(attribute1,"命中率"))then 
        return true
    elseif(string.find(attribute2,"命中率")) then
        return false
    end
   if(string.find(attribute1,"闪避率"))then 
        return true
    elseif(string.find(attribute2,"闪避率")) then
        return false
    end

   if(string.find(attribute1,"暴击率"))then 
        return true
    elseif(string.find(attribute2,"暴击率")) then
        return false
    end


   if(string.find(attribute1,"格档率"))then 
        return true
    elseif(string.find(attribute2,"格档率")) then
        return false
    end

    return true
end


--second格式化转换 如1800得到 00：30：00
function funcs.getHourMinSec(inputSec)
    inputSec = math.ceil(inputSec);
    local temp = inputSec/3600;
    local h = temp - temp%1;
    inputSec = inputSec - h*3600;
    temp = inputSec/60;
    local min = temp - temp%1;
    inputSec = inputSec - min*60;
    local hourMinSec = nil;
    if h > 9 then
        hourMinSec = h;
    else
        hourMinSec = "0"..h;
    end
    
    if min > 9 then
        hourMinSec = hourMinSec..":"..min;
    else
        hourMinSec = hourMinSec..":0"..min;
    end
    if inputSec > 9 then
        hourMinSec = hourMinSec..":"..inputSec;
    else
        hourMinSec = hourMinSec..":0"..inputSec;
    end

    return hourMinSec;
end

function funcs.upDataSprite(src,dest,zorder)
    local csrc = tolua.cast(src,"CCSprite")
    local cdest = tolua.cast(dest,"CCSprite")

    if not csrc or not cdest then 
        return 
    end 

    local posx = csrc:getPositionX() 
    local posy = csrc:getPositionY()
    local ant = csrc:getAnchorPoint()
    local par = csrc:getParent()

    csrc:removeFromParentAndCleanup(true)
    cdest:setAnchorPoint(ant)
    cdest:setPosition(ccp(posx,posy))
    if par then 
        if zorder then 
            par:addChild(cdest,zorder)
        else 
            par:addChild(cdest)
        end
    end 

    return dest
end 

function funcs.GetAttributeName(s)
    -- body
    local mytable = {
       POWER =  "力量";
       INTELLIGENCE = "智力";
       AGILE = "敏捷";
       PATTACK = "物理攻击";
       PDEFENSE = "物理防御";
       MDEFENSE = "策略防御";
       MATTACK = "策略攻击";
       HP = "血量";
       WRECK = "破击率";
       ANTIKNOCK = "抗暴率";
       CRIT = "暴击率";
       DODGE = "闪避率";
       BLOCK = "格挡率";
       HIT = "命中率";
       PUNCH = "合击率";
       HELP = "救援率";
       HURTRATE = "伤害率";
       AVOIDHURTRATE ="免伤率";
       SPEED = "速度";
       PHYSICSATTACK = "物理攻击";
       PHYSICSDEFENSE = "物理防御";
       MAGICATTACK = "策略攻击";
       MAGICDEFENSE = "策略防御";
       WRECKRATE = "破击率";
       ANTIKNOCKRATE = "抗暴率";
       ATTACKRATE = "攻击率";
       CRITRATE = "暴击率";
       DODGERATE = "闪避率";
       BLOCKRATE = "格挡率";
       HITRATE = "命中率";
       PUNCHRATE = "合击率";
       HELPRATE = "救援率";
       DEFENCERATE = "防御率";
       RECOVERRATE = "回复率";
       LIFE = "生命";
       ----------------龙将归来8种主属性类型来源baseequip.xls mainType字段-----------------------
       NEAR_ATTACK          = "物攻";
       NEAR_DEFENSE         = "物防";
       FAR_ATTACK           = "远程攻击";------远程的好像没用过 
       FAR_DEFENSE          = "远程防御";------
       STRATEGY_ATTACK      = "法攻";
       STRATEGY_DEFENSE     = "法防";
       SPEED                = "速度";
       LIFE                 = "生命";
       -----------------主属性类型 添加完毕@vinyin 2014-9-10----------------------
    }

    local id = string.upper(s)
    return mytable[id] 

end


--获取主将的模型id
function funcs.getMainModelid( )
    return 1
end

--通过品质，返回颜色，做武将名字颜色处理
function funcs.getQualitycolor(quality)
    -- body
   return baseTypes.QuantityToColor[tonumber(quality)]
end

local tipstable = {}
local gScene = nil
function funcs.ShowTips(str,color)  
    --切换场景时清空table
    if gScene ~= nil and gScene ~= CCDirector:sharedDirector():getRunningScene() then
        tipstable = {}
    end  

    local colorstr = nil 
    if color then
        colorstr = color
    else
        colorstr = FontsMgr.Color.QGreen
    end
    -- body
    local rewardtips = CCLabelTTF:create(str,GlobalData.G_DEFAULT_FONT,FontsMgr.Content.Middle)
    rewardtips:setColor(colorstr)

    local labelColorLayer = display.newScale9Sprite("#U_G_XC1_heidi.png")-- CCScale9Sprite:create("#U_G_XC1_heidi.png") --CCLayerColor:create(ccc4(210,210,210,40));
    local bgX = rewardtips:getContentSize().width > 181 and rewardtips:getContentSize().width + 10 or 181
    local bgY = rewardtips:getContentSize().height + 10 ;
    labelColorLayer:setContentSize(CCSizeMake(bgX, bgY));
    labelColorLayer:ignoreAnchorPointForPosition(false);
    labelColorLayer:setAnchorPoint(ccp(.5,0));
    labelColorLayer:setPosition(rewardtips:getContentSize().width*.5, -5)
    rewardtips:addChild(labelColorLayer,-1);

    local wins = CCDirector:sharedDirector():getWinSize()

    local num = #tipstable
    if next(tipstable) ~= nil then
        for i,v in ipairs(tipstable) do
            v:setPosition(ccp(v:getPositionX(),v:getPositionY()+rewardtips:getContentSize().height+5))
        end
    end
    table.insert(tipstable,1,rewardtips)

    rewardtips:setPosition(wins.width*.50,wins.height*.5-100)
    rewardtips:setAnchorPoint(ccp(0.5,0))
    gScene = CCDirector:sharedDirector():getRunningScene()
    gScene:addChild(rewardtips,2000000)

    local a1 = CCSequence:createWithTwoActions(CCMoveBy:create(0.1, ccp(0, 100)),CCFadeIn:create(0.1))
    --local a1 = CCFadeIn:create(0.2)
    local a2 = CCDelayTime:create(1.5)
    --local a3 = CCFadeOut:create(0.8)
    --local a3 = CCSequence:createWithTwoActions(CCMoveBy:create(0.8, ccp(0, 80)),CCFadeOut:create(0.3))
    local a3 = CCMoveBy:create(0.1, ccp(0, 100))
    local a4 = CCCallFunc:create(function() 
        if  next(tipstable) ~= nil then
           table.remove(tipstable)
        end
        rewardtips:removeFromParentAndCleanup(true) 
        rewardtips = nil 
        end)
    local action1 =CCSequence:createWithTwoActions(a1,a2)
    local action2 = CCSequence:createWithTwoActions(a3,a4)
    rewardtips:runAction(CCSequence:createWithTwoActions(action1,action2))
end

---node漂字，包括图片等
function funcs.floatNode( tipNodeFloat,pos )
        floatTip.new(tipNodeFloat,pos )
end

-- 显示当前结点的范围
function funcs.debug_node( node, color )
    display.newColorLayer(color or ccc4(0, 255, 0, 100)):size(node:getContentSize()):addTo(node);
end;

-- extend tobool
function funcs.tobool( value )
    return (value ~= "0" and value ~= nil and value ~= false)
end

-- 可传参数的回调，回调中第一个参数为 table
function funcs.handler_N(target, method, ...)
    local args = {...};
    return function()
        return method(target, args)
    end
end;



function funcs.getHashLength(t)
    local count = 0;
    for k, v in pairs(t) do
        count = count + 1;
    end;

    return count;
end;

function funcs.AdjustPos(selfPanel,pos,retrictRect)
    -- body

    local Maxwidth,MaxHeight = retrictRect.size.width,retrictRect.size.height
    local selfWidth,selfHeight = selfPanel:getContentSize().width,selfPanel:getContentSize().height
    local adjustX,adjustY = pos.x,pos.y
    if pos.x + selfWidth > Maxwidth then
        adjustX = Maxwidth - selfWidth

    end

    if pos.y < 0  then
        adjustY = 0 

    end
    return ccp(math.floor(adjustX),math.floor(adjustY))
end

-- for test by Sowyer
function funcs.debug_write_json( content )
    local str = json.encode(content); 
    -- io.writefile("/Users/Sowyer/Desktop/reportFile.log", str, "w+");
    io.writefile("E:\\reportFile.json", str, "w+");
end;


function funcs.isSpecialProp( ltype)

        if not  ltype then
          return false
        end

        for i = 1,#baseTypes.SpecialProp do
           if tostring(ltype) == baseTypes.SpecialProp[i] then
               return true
           end

        end
end

----------计算heroFormationList阵位上的战斗力----------------
function funcs.calcuateFightValue(heroFormationList)
    local heroList = GlobalData.g_heroList
    local totalFighting = 0 --总战斗力
    if next(heroFormationList) then
        for i, v in ipairs(heroFormationList["heroPositions"]) do
            local id = v["heroId"];
            for k, u in ipairs(heroList) do
                if id == u["id"] then
                     totalFighting = totalFighting + u["fighting"];
                     break;
                end
            end
        end
    end
    return totalFighting;
end

-----------------传入当前等级及当前经验值，返回其经验进度条比例--------------------
local upLevelExp =  require("config.HeroExp")
function funcs.calcuateExpProcess(level,exp)
    local e = 0;
    for i,v in pairs(upLevelExp) do
        if level == tonumber(v["level"]) then
            e     = v["needExp"];
            break;
        end
    end
    
    local progressText = string.format("%d/%d",exp,e)
    if e ~= 0 and exp <= e then
        return exp/e,progressText
    end
end

---------------格式化数字，传入数字＞=100000时，返回字符串10万----------
function funcs.numFormat(num)
    if num < 100000 then
        return num;
    else
        return math.floor(num/10000).. "万";
    end
end

-- 字符串转json对象
function funcs.str2Json(string)
    return json.decode(string);
end;    

-- json对象转字符串
function funcs.json2Str(vjson)
    return json.encode(vjson);
end;

-- 读取图片名
-- param : 要读的文件名
-- return value : 对应的文件名
function funcs.loadPic(str, flag)
    local ret = str;

    if ret and string.find(ret, "/") then
        if not CONFIG_IS_DEBUG then
            ret = "#" .. string.match(ret, ".+/(.+)");
        end;
    end;

    return ret;
end;
------------------------拆分格式"53301_3|53306_1"字符串，得到数字 53301 3 53306 1---------------@vinyin~2014-9-18
function    funcs.getStuffAndNum(str)
    local pattern  = "|";
    local pattern1 = "_";
    local divi     = string.find(str,pattern);

    local str1     = string.sub(str,1,divi-1);
    local str2     = string.sub(str,divi+1);

    local divi1    = string.find(str1,pattern1);
    local stuff1   = tonumber(string.sub(str1,1,divi1-1));
    local num1     = tonumber(string.sub(str1,divi1+1));

    divi1          = string.find(str2,pattern1);
    local stuff2   = tonumber(string.sub(str2,1,divi1-1));
    local num2     = tonumber(string.sub(str2,divi1+1));
    return stuff1,num1,stuff2,num2;
end
---------------传入装备ID,判断是否可神铸 @vinyin 2014-9/18---------------------------------------------------------------------------
function funcs.equipmentCanUpgrade(id)
    local isUpgrade    = false;
    local value;
    local equipUpgrade =  import("config.EquipUpgrade");
    for k,v in pairs(equipUpgrade) do
        if id == v["equipId"] then
            isUpgrade  = true;
            value      = v;
            break;
        end
    end
    return isUpgrade,value;
end
--------------通过params["modelId"] 生成小头像，若有回调params["func"]函数，则单击后会调用@vinyin 2014-8-7----------------------------
function funcs.getHeroHead(params)
    local filename = params["imagePath"] or "pic/head/M_"..params["modelId"].."_head.png";  
    -- if funcs.isFileExist(filename) == false then
    --     filename = "pic/head/M_2_head.jpg"
    -- end
 
    if funcs.isFileExist(filename)  == false then--没有这图
        filename = "pic/head/M_13_round_head.png"
    end
    local sprite   = display.newSprite(filename);
    if    not params["imagePath"] then
        local x,y      = params["x"] or sprite:getContentSize().width/2+3,params["y"] or sprite:getContentSize().height/2+3;
        sprite:setPosition(ccp(x,y));
    end

    if params["func"] then
        local func = params["func"];
        sprite:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE); -- 单点触摸
        sprite:setTouchEnabled(true);
        local nomove = true;
        function ClickEvent( event)
            if event.name == "began" then
               nomove = true
               return  true;
            end
            if event.name == "moved" then
               nomove = false; 
               return true;
            end
            if event.name == "ended" and nomove then
               func();
               return true;
            end             
        end
        sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, ClickEvent);
    end

    return sprite;
end

local modelConfig = require("config.ModelConfig")
--通过modelId获取人物圆头像
function funcs.getHeroRoundHeadByModelId(modelId)
    local newid = modelConfig[modelId].newid
    local headpic = string.format("pic/head/M_%d_round_head.png",newid)
    --调试，没有的头像模型暂时替代
    if funcs.isFileExist(headpic)  == false then
        headpic = "pic/head/M_13_round_head.png"
    end

    return display.newSprite(headpic)
end

--通过baseheroid获取方头像
function funcs.getHeroHeadByBaseheroId(baseHeroId)
    local baseHero = require("config.BaseHero")
    local modelId = baseHero[baseHeroId].modelId
    local modelNewId = modelConfig[modelId].newid or 1;
    local headImage = funcs.getHeroHead({modelId = modelNewId});

    return headImage
end
-----------------------------------------站立人物优先取只有ready状态的PNG*@vinYin2014-11-6 -------------------------
function funcs.getHeroByModelId(id)
    local hero = nil
    if id == -1 then
        local mainHero = HeroListData.sharedHeroListData().m_mainHero
        hero = Hero.new(mainHero)
    else
        local heroData = {}
        heroData["modelId"] = id
        local newModelId = modelConfig[id].newid or 1;
        local filename = "pic/role/R" ..newModelId.."U"
        local isExist = funcs.isFileExist(filename ..".plist");
     
        if isExist then--存在不带U的png
            hero  = Hero.new(heroData,baseTypes.RoleType.OnlyReady)--
            hero:setStatus(ActorDef.state.ready);
        else --没有的话再去战斗模型里去取
            hero  = Hero.new(heroData,baseTypes.RoleType.Bat)--
            hero:setStatus(ActorDef.state.ready);
        end
    end

    hero:setName("")

    return hero
end

--通过模型ID获取方头像
function funcs.getHeroHeadByModelId(nModelId)
    local modelNewId = modelConfig[nModelId].newid or 1;
    local headImage = funcs.getHeroHead({modelId = modelNewId});

    return headImage
end

----------------------依据一个军衔ID 得到它的table----
function funcs.getMilitaryById(id)
    local military =  import("config.Military");
    local temp;
    for i,v in pairs(military) do 
        if v["code"] == id then
            temp     =  v;
            break;
        end
    end
    return temp;
end

---------------------传入1970-01-01 8am 到现在的秒数，转为"%Y-%m-%d %H:%M:%S" 如12秒返回1970-01-01 08:00:12@vinyin
---------------------小知识：1970-01-01是uinx诞生时间，北京位于东八区，北京时间8am即格林威治0点整，
function funcs.getDateBysecond(seconds, dateformat)
    local temp = dateformat or "%Y-%m-%d %H:%M:%S";
    return os.date(temp, seconds)
end
---------------------根据基姆拉尔森公式计算服务器属于星期几 @vinyin-----------------------
function funcs.getDaythBySecond(seconds)
    local date  = funcs.getDateBysecond(seconds);
    local year  = tonumber(string.sub(date,1,4));
    local month = tonumber(string.sub(date,6,7));
    local day   = tonumber(string.sub(date,9,10));

    local dayth = funcs.getDaythByYMD(year,month,day);
    return dayth;
end
---------------------根据基姆拉尔森公式计算yyyy-mm--dd属于星期几 @vinyin-----------------------
--{"1表示星期天","2是星期一","3是星期二","4是星期三","5是星期四","6是星期五","7是星期六"};
function funcs.getDaythByYMD(year,month,day)
    local y,m,d = year,month,day;
    local t = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if    m < 3 then--------- 一月，二月当上成上一年的13 14月处理
          y = y - 1;
    end
    local w = y + math.floor(y/4) - math.floor(y/100) +  math.floor(y/400) + t[m] + d;
    return math.mod(w,7) + 1;
end

function funcs.getTaskStateValue(state)
    if state == "CANCEL" then           
        return TaskUIConfig.TaskState.CANCEL
    elseif state == "SHOW" then 
        return TaskUIConfig.TaskState.SHOW
    elseif state == "ACCEPT" then 
        return TaskUIConfig.TaskState.ACCEPT
    elseif state == "IN_PROGRESS" then 
        return TaskUIConfig.TaskState.IN_PROGRESS
    elseif state == "COMPLETED" then 
        return TaskUIConfig.TaskState.COMPLETED
    elseif state == "FINISH" then 
        return TaskUIConfig.TaskState.FINISH
    else 
        return -1
    end
end

--显示道具奖励
function funcs.getPropReward(propRewardTable)
    local data =RewardItemData.create(propRewardTable);
    local itemname = data.itemName
    local myitems =RewardsManager.RewardItemSprite( data)
    --amount
    if propRewardTable.amount > 1 then
        local amountlabel = CCLabelTTF:create(propRewardTable.amount, GlobalData.G_DEFAULT_FONT, FontsMgr.Content.Small);
        amountlabel:setAnchorPoint(ccp(1,0));
        amountlabel:setPosition(myitems:getContentSize().width*0.9, myitems:getContentSize().height*0.1);
        myitems:addChild(amountlabel);
    end
    ---name 
    local namelabel = CCLabelTTF:create(itemname, GlobalData.G_DEFAULT_FONT,FontsMgr.Content.Small);
    namelabel:setPosition(myitems:getContentSize().width*.5, -myitems:getContentSize().height*.2);
    namelabel:setColor(funcs.getQualitycolor(data.quality));
    myitems:addChild(namelabel);

    return myitems
end

------判断背包是否已经满了。返回true为满了
function funcs.checkBagVolume()
    -- body
    if HeroAndBagItemListManager.mOverflow then
        funcs.ShowTips(BagConfig.bagOverflow,FontsMgr.Color.White);
        return true;
    else
        return false;
    end
end

--获取主将的职业
function funcs.getMainHeroProfession()
   local mainHeroBaseId =  GlobalData.g_mainHeroData.baseHeroId
   local baseHero = require("config.BaseHero")
   local mainHeroProfession = baseHero[mainHeroBaseId]["profession"]
   return mainHeroProfession
end


--获取物品名称
--@item table 物品数据,内含字段 
--type 物品类型
--code 不同类型表示的意义不同
--amount 一般是表示物品的数量、个别类型表示的意义不同
function funcs.getItemName(item)
    if item.type == 0 then
        -- 货币
        if item.code == 0 then
            return "银币x"..item.amount
        elseif item.code == 1 then
            return "金币x"..item.amount
        elseif item.code == 2 then
            return "礼券x"..item.amount
        elseif item.code == 3 then
            return "内币x"..item.amount
        end
    elseif item.type == 1 then
        -- 道具
        local article = import("config.Article")[tonumber(item.code)]
        return article.name.."x"..item.amount
    elseif item.type == 2 then
        return "经验x"..item.amount
    elseif item.type == 3 then
        return "军令x"..item.amount
    elseif item.type == 4 then
        -- code BaseHero id
        local baseHero = import("config.BashHero")[tonumber(item.code)]
        return "武将["..baseHero.name.."]"
    elseif item.type == 5 then
        return "声望x"..item.amount
    elseif item.type == 6 then
        return "将魂x"..item.amount
    elseif item.type == 7 then
        -- code 武魂的品阶
        if item.code == 3 then
            return "蓝魂x"..item.amount
        elseif item.code == 4 then
            return "紫魂x"..item.amount
        elseif item.code == 5 then
            return "橙魂x"..item.amount
        elseif item.code == 6 then
            return "金魂x"..item.amount
        end
    elseif item.type == 8 then
        return "军团经验x"..item.amount
    elseif item.type == 9 then
        -- code 等级 amount 持续的小时 content 结束时间 
        return "临时VIP"..item.code.."级"
    elseif item.type == 10 then
        -- code 形象标识 amount 持续小时
        return "骑宠形象id["..item.code.."]"
    elseif item.type == 11 then
        -- 灯油
    elseif item.type == 12 then
        -- 称号 code 称号名称 amount 持续小时
        return "称号["..item.code.."]"
    else 
        return "无法识别"
    end
end

function funcs.bytes2number(t,endian,signed)
    if endian == "big" then
        local tt = {}
        for k = 1, #t do
            tt[#t - k + 1] = t[k]
        end
        t = tt
    end
    local n = 0
    for k = 1, #t do
        n = n + t[k] * 2 ^ ((k - 1) * 8)
    end
    if signed then
        n = (n > 2 ^ (#t * 8 - 1) -1) and (n - 2 ^ (#t * 8)) or n -- if last bit set, negative.
    end
    return n
end

function funcs.dealWithRewards(content)
    -- body
    local tips = "";
    local nums = table.nums(content);
    local j = 1;
    for i ,v in pairs(content) do 
        local rewardItemData = RewardItemData.create(v);
        if j < nums then
            tips = tips..rewardItemData.itemName.."+"..rewardItemData.amount.."\n";
        else
            tips = tips..rewardItemData.itemName.."+"..rewardItemData.amount;
        end
        RewardsManager.dealWithRewardItem(rewardItemData);
        j = j + 1;
    end
    funcs.ShowTips(tips);
end
----添加装备动态边框
function funcs.addEquilEffect(item,quality)
    -- body
    funcs.addBagItemEffect(item,quality)
    if item:getChildByTag(121244) then
        item:getChildByTag(121244):removeFromParentAndCleanup(true);
    end
    local effectid = nil;
    local lizinums = 0
    if quality == 4 then
        effectid = "e3023_u"
        lizinums = 2
    elseif quality == 5 then
        effectid = "e3025_u"
        lizinums = 3
    elseif quality == 6 then
        effectid = "e3024_u"
        lizinums = 6
    end
    if effectid then
        
        local myeffectid = "ui/"..effectid..".ccbi";
        ccb[effectid] = {}
        local myeffect = effect.get(myeffectid,true)
        if myeffect then
            myeffect:setPosition(item:getContentSize().width*.5, item:getContentSize().height*.5);
            item:addChild(myeffect,1,121244);
        end
        
        for i =1,lizinums do
            local ccbName = string.format("ccb_lz%d",i)
            if ccb[effectid][ccbName] then
                ccb[effectid][ccbName]:setPositionType(kCCPositionTypeRelative);
            end 
        end
        return myeffect;
    else
        return nil
    end
    
end
----添加道具静态边框
function funcs.addBagItemEffect(item,quality)
    -- body
    local kuanid = nil;
    if quality == 2 then
        kuanid = "#U_G_kuang_01.png"
    elseif quality == 3 then
        kuanid = "#U_G_kuang_02.png"
    elseif quality == 4 then
        kuanid = "#U_G_kuang_03.png"
    elseif quality == 5 then
        kuanid = "#U_G_kuang_04.png"
    elseif quality == 6 then
        kuanid = "#U_G_kuang_05.png"
    elseif quality == 7 then
        kuanid = "#U_G_kuang_06.png"
    end
    if kuanid then
        local myeffect = display.newSprite(kuanid)
        myeffect:setPosition(item:getContentSize().width*.5, item:getContentSize().height*.5);
        item:addChild(myeffect);
        return myeffect;
    else
        return nil
    end
    
end


function funcs.getMilitaryNameByRank(nRank)
    local name = MilitaryConfig.MilitaryTable[nRank]["name"]
    return name
end



--参数如下
-- labeltable ={
--     label = CClabel,--CCLabelTTF:create();
--     font = GlobalData.G_DEFAULT_FONT_FZSZ, --可不传
--     size = FontsMgr.Content.Middle,--建议传
--     color = FontsMgr.Color.QRed,--可不传
--     text = "龙将归来"--可不传
--     outLine = true --如果需要描边填true，返回一个CClabel，直接用之前的变量等于该label就行了
-- }
function funcs.dealwithLabel(labeltable)
    -- body
    local label = labeltable.label ;
    local mei = nil;
    mei = labeltable.size and label:setFontSize(labeltable.size);
    --mei = labeltable.font and label:setFontName(labeltable.font);
    label:setFontName(GlobalData.G_DEFAULT_FONT)
    mei = labeltable.text and label:setString(labeltable.text);
    if labeltable.color then
        label:setColor(labeltable.color)
    else
        label:setColor(FontsMgr.Color.MidYellow)
    end
    if labeltable.outLine then 
       return funcs.labelChangeOutline(label)
    end

end

function funcs.labelChangeOutline(labeltable)
    -- body
    local params = {
        text = labeltable.label:getString();
        font = labeltable.font or GlobalData.G_DEFAULT_FONT;
        size = labeltable.size or labeltable.label:getFontSize();
        dimensions = labeltable.label:getDimensions();
        align =  labeltable.label:getHorizontalAlignment();
        valign = labeltable.label:getVerticalAlignment();
        --x = label:getPositionX();
        --y = label:getPositionY();
        color = labeltable.color or nil --label:getColor();
        --align =      ui.TEXT_ALIGN_CENTER
    }
    local newlabel = ui.newTTFLabelWithOutline(params);
    local myx = labeltable.label:getPositionX();
    if labeltable.label:getHorizontalAlignment() == kCCTextAlignmentLeft then
        myx = myx - labeltable.label:getContentSize().width*.5;
    elseif labeltable.label:getHorizontalAlignment() == kCCTextAlignmentRight then
        myx = myx + labeltable.label:getContentSize().width*.5;
    end
    newlabel:setAnchorPoint(ccp(labeltable.label:getAnchorPoint().x,labeltable.label:getAnchorPoint().y));
    local parent = labeltable.label:getParent();
    newlabel:setPosition(myx,labeltable.label:getPositionY())
    labeltable.label:removeFromParentAndCleanup(true);
    parent:addChild(newlabel);
    return newlabel;

end
-------错误提示码
function funcs.errorShowTips(code)
    -- body
    log.error("====错误提示码===："..code)
    local errorCode  = require("config.ErrorCode");

    local errorStr = "失败"
    if errorCode[tonumber(code)] then
        errorStr = errorCode[tonumber(code)]["info"]
    end
    funcs.ShowTips(errorStr,FontsMgr.Color.White);

end

function funcs.updateHeroSoulList(rewardsList)
    local msg = ""
    local soul = {[RecruitConfig.grades.blue] = 0,[RecruitConfig.grades.purple] = 0,[RecruitConfig.grades.gold] = 0,[RecruitConfig.grades.red] = 0,}
    for _,reward in pairs(rewardsList) do
        if reward.type == baseTypes.Rewards.Soul then
            if reward.code == RecruitConfig.grades.blue then 
                msg = msg.."获得蓝色武魂"..reward.amount 
                soul[RecruitConfig.grades.blue] = soul[RecruitConfig.grades.blue] + reward.amount
            end                                 
            if reward.code == RecruitConfig.grades.purple then 
                msg = msg.."获得紫色武魂"..reward.amount 
                soul[RecruitConfig.grades.purple] = soul[RecruitConfig.grades.purple] + reward.amount
            end
            if reward.code == RecruitConfig.grades.gold then 
                msg = msg.."获得金色武魂"..reward.amount
                soul[RecruitConfig.grades.gold] = soul[RecruitConfig.grades.gold] + reward.amount
            end
            if reward.code == RecruitConfig.grades.red then 
                msg = msg.."获得橙色武魂"..reward.amount 
                soul[RecruitConfig.grades.red] = soul[RecruitConfig.grades.red] + reward.amount
            end
        else
            log.debug('其他物品，待处理')
        end
    end
    RecruitData.sharedRecruitData():changeSouls(soul)
    funcs.ShowTips(msg)
end

-----屏蔽敏感词接口@vinYin 2014-11-3 ------------------------------------------------------------------------------------------------------------------
local senstive = require("local_config.Senstive");----加载世界上最脏的东西
function funcs.filterSenstive(inputStr,donotFilter,useMeToPlace)
    local useMeToReplace = useMeToPlace or "*"
    local result = inputStr;
  
    if donotFilter then---不需要过滤
        return result;
    else------------------开启过滤算法
        for k,v in pairs(senstive) do
            result,n = string.gsub(result,v,useMeToReplace)
        end
    end
    return result;
end
---------node结点数字的动态改变 结点名 新值 刷新次数 每次刷新时间间隔@vinYin 2014-12-16--------------------------------------------
function funcs.rolltoNewValue(node,newValue,times,interval)

    times = times or 20;---------刷新次数
    interval = interval or 0.05;--刷新时间间隔
    local oldValue;
    if node then
       oldValue = tonumber(node:getString());
    end
    --newValue = newValue or oldValue;
    if not newValue or not oldValue then
        return;
    end

    local delta = math.floor((newValue - oldValue)/times);---等差
    local array = CCArray:create();
    for i = 1,times do
        local cur = oldValue + i*delta;
        if i == times then--最后一个了
            cur = newValue;
        end
        local act = CCCallFunc:create(function()
                        node:setString(cur);
                end)
        array:addObject(act);
        array:addObject(CCDelayTime:create(interval));
    end
    node:runAction(CCSequence:create(array));
end

--全屏弹出的效果
function funcs.popTipsEffect(nodeName,closeBack)
    nodeName:setScale(0.1)
    local arrayIn = CCArray:create();
    arrayIn:addObject(CCScaleTo:create(0.2,1))
    nodeName:runAction(CCSpawn:create(arrayIn))

    nodeName:setTouchEnabled(true)
    nodeName:setTouchSwallowEnabled(true)
    nodeName:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            local array = CCArray:create();
            array:addObject(CCScaleTo:create(0.2,0.1))
            array:addObject(CCFadeOut:create(0.2))
            local act1 = CCSpawn:create(array)
            local act2 = CCCallFunc:create(function()
                    if closeBack then closeBack() end
                end)
            nodeName:runAction(CCSequence:createWithTwoActions(act1,act2))
    end)
end
----------------------通用加红点精灵 初衷:后期红点可能有runAction@vinYin 2014-12-17------------------------------------
function funcs.addRedPointSprite(x,y,fileName)
    fileName = fileName or "#U_XM0_dian.png";
    x = x or 0;
    y = y or 0;
    local redPoint = display.newSprite(fileName);
    redPoint:setPosition(x,y);
    return redPoint;
end



--]]





