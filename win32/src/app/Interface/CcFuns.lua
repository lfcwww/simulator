if not CcFuns then
    local CcFuns = {}
    cc.exports.CcFuns = CcFuns

 ------创建帧动画(精灵帧方式)
 --[[
    function CcFuns.createAnimationByFrame(format,delay,begin)

        begin = begin or 0
        local ret
        local maxFrame = 20
        
        for i=begin,maxFrame do
            local frame = cc.SpriteFrameCache:getInstance():spriteFrameByName(string.format(format,i))
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

--]]


--@return true if the file exists, otherwise it will return false.
function CcFuns.isFileExist(path)
    if path == nil then
        return false
    end

    local cfile = cc.FileUtils:getInstance();
    return cfile:isFileExist(cfile:fullPathForFilename(path))
end

-- 字符串转json对象
function CcFuns.str2Json(string)
    return json.decode(string);
end;

-- json对象转字符串
function CcFuns.json2Str(vjson)
    return json.encode(vjson);
end;


--字符串分割
function CcFuns.splitutfstr(str,pos)
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

--字符获取
function CcFuns.getp(str, pos)
    
    local find = str
    local data = str

    for i = 1, string.utf8len(str) do
        if pos == i then
            data = self:splitutfstr(find, 1)[1]
            break
        end
        find = self:splitutfstr(find, 1)[2]
    end

    return data
end

    --从小到大分割字一个数字
   --num:待分割的数字
   --splitNum:分割的次数
   --retTable:缓存的tabe
  function CcFuns.splitNum(num,splitNum,retTable)
    local tempTable = {} ;

    if num==0 then
       for i=1,splitNum do
          table.insert(retTable,num);
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

    --减少0的出现
    if num > splitNum then
        local i = 1;
        local j = splitNum;
        while retTable[j] <= 1 do
            j = j-1;
        end;

        while i<j do
            if(retTable[i]<1) then
                retTable[i] = retTable[i]+1;
                i = i+1;
                retTable[j] = retTable[j]-1;
                if retTable[j] <= 1 then
                    j = j-1;
                end;
            else
                break;
            end;
        end;
    end;

    table.sort(retTable);

    return retTable;
  end

    function CcFuns.filterFileExtendName(fileName, extendName)
        extendName = extendName or ".png"
        if not string.find(fileName, "%.") then
            fileName = fileName .. extendName
        end
        return fileName
    end

    -- 淡入
    -- @params direct:方向
    function CcFuns.createEaseBackOut(distance, time, eachDelayTime, direct, callback)
        local moveBy = nil
        local delay = eachDelayTime or 0
        if direct and direct == 1 then 
            moveBy = cc.MoveBy:create(time, cc.p(0, distance))
        else
            moveBy = cc.MoveBy:create(time, cc.p(distance, 0))
        end
        local action = nil
        local spawnAction = cc.Spawn:create({
               cc.EaseBackOut:create(moveBy), 
                cc.FadeIn:create(time)
            })
        if callback then 
            action = transition.sequence({
                cc.DelayTime:create(delay),
                spawnAction,
                cc.CallFunc:create(callback),
            })
        else
            action = transition.sequence({
                cc.DelayTime:create(delay),
                spawnAction,
            })
        end
        return action
    end

    -- 游戏通用艺术字提示+光效
    -- @params:picName是艺术字图片的名字， callback是回调函数，可不传
    function CcFuns.runNoticeWordAction(picName, callback)
        local successPic = display.newSprite("pic/icon/word/" .. picName)
        display.getRunningScene():addChild(successPic, deZorder["MsgBox"])
        successPic:setPosition(cc.p(display.cx, display.height -150))
        successPic:setScale(2)
        local lightEff = nil
        local function clearRes()
            if successPic then 
                successPic:removeFromParent()
                successPic = nil
            end
            if lightEff then 
                lightEff:removeFromParent()
                lightEff = nil
            end
            if callback then
                callback()
            end
        end

        local function createLight()
            lightEff = EffectPlay.playEffectByName("eff_qianghuachenggongguangxiao.xml", false, clearRes)
            :addTo(display.getRunningScene(), deZorder["MsgBox"])
            :pos(display.cx, display.height -150)
        end

        local actionBigToSmall = CcFuns.createActionBigToSmall(1, 0.1, createLight)
        successPic:runAction(actionBigToSmall)
    end

    -- 类似盖章效果
    -- @param:org是想先放大的系数，des是目标大小系数，tims是时间
    -- function CcFuns.createActionBigToSmall(org, des, time, callback)
    function CcFuns.createActionBigToSmall(des, time, callback, eachDelayTime)
        local delay = eachDelayTime or 0
        local action = nil
        local actionEase = cc.EaseOut:create(cc.ScaleTo:create(time, des, des, des), 0.37)
        local actionSpawn = cc.Spawn:create(actionEase, cc.FadeIn:create(time))
        if callback then 
           action = transition.sequence({
            -- 做不到绝对的0秒变大，所以放大的步骤不在动画中做
            -- cc.ScaleTo:create(0, org, org, org),
            cc.DelayTime:create(delay),
            actionSpawn,
            cc.CallFunc:create(callback),
            })
        else
            action = transition.sequence({
                cc.DelayTime:create(delay),
                actionSpawn,
            })
        end
        return action
    end

    -- 通用呼吸动画
    -- params:item是要播动画的node, time是单次动画的时间， section1, section2是变化区间，可不填，默认是0.95到1
    function CcFuns.runBreathAction(item, time, section1, section2)
        local orgScale = item:getScale()
        local actionTime = time or 1.5
        local scaleSection1 = section1 or 0.95
        local scaleSection2 = section2 or 1
        item:setScale(scaleSection1 * orgScale)
        local sequence = transition.sequence({
                cc.ScaleTo:create(actionTime, scaleSection2 * orgScale),
                cc.ScaleTo:create(actionTime, scaleSection1 * orgScale),
            })
        item:runAction(cc.RepeatForever:create(sequence))
    end

    --描边
    function CcFuns.setSpriteFrameOrLabelStr(node, str, outLinetype)
        if node then
            if str and string.find(str, ".png") and node.setSpriteFrame then
                local frame = display.newSpriteFrame(str);
                node:setSpriteFrame(frame);
            elseif node.setString then
                if str then
                    node:setString(str);
                end;

                if outLinetype then
                    if outLinetype == 1 then
                        --蓝色描边
                        node:enableOutline(cc.c4b(0x05, 0x4a, 0x8b, 255), 2);
                    elseif outLinetype == 2 then
                        --橙色描边
                        node:enableOutline(cc.c4b(0x72, 0x31, 0x00, 255), 2);
                    elseif outLinetype == 3 then
                        --灰色描边
                        node:enableOutline(cc.c4b(0x5d, 0x5d, 0x5d, 255), 2);
                    elseif outLinetype == 4 then
                        --绿色描边
                        node:enableOutline(cc.c4b(0x43, 0x90, 0x43, 255), 3);
                    elseif outLinetype == 5 then
                        --黑色描边
                        node:enableOutline(cc.c4b(0x00, 0x00, 0x00, 255), 2);
                    end;
                end;
            end;
        end;
    end

    --按钮的抖动效果
    function CcFuns.runButtonShakeAction(node, orgScaleX, orgScaleY)
        if not node then
            return;
        end
        --如果快速点击，实时获取scale值会引起形变
        local scaleX = orgScaleX or node:getScaleX();
        local scaleY = orgScaleY or node:getScaleY();
        local  array = {};
        table.insert(array, cc.ScaleTo:create(0.08, 1.1 * scaleX, 0.9 * scaleY));
        table.insert(array, cc.ScaleTo:create(0.08, 0.9 * scaleX, 1.1 * scaleY));
        table.insert(array, cc.ScaleTo:create(0.08, 1.1 * scaleX, 0.9 * scaleY));
        table.insert(array, cc.ScaleTo:create(0.08, 1.0 * scaleX, 1.0 * scaleY));
        local seq = cc.Sequence:create(array);
        node:runAction(seq)
    end

    --从四个方向进入的动作
    CcFuns.moveInDirect = {
        top = 1,
        bottom = 2,
        left = 3,
        right = 4,
    }
    function CcFuns.createMoveInAction(node, direct, duration, callback, offset)
        local originX, originY = node:getPosition()
        local startX = originX
        local startY = originY
        local size = node:getContentSize()

        local distance = 0
        local vh = nil
        if duration == nil then
            duration = 0
        end
        if offset == nil then
            offset = {x=0, y=0}
        end

        if CcFuns.moveInDirect.top == direct then
            startY = display.top + size.height*0.5 + offset.y
            distance = originY - startY
            vh = 1
        elseif CcFuns.moveInDirect.bottom == direct then
            startY = display.bottom - size.height*0.5 + offset.y
            distance = originY - startY
            vh = 1
        elseif CcFuns.moveInDirect.left == direct then
            startX = display.left - size.width*0.5 + offset.x
            distance = originX - startX
        elseif CcFuns.moveInDirect.right == direct then
            startX = display.right + size.width*0.5 + offset.x
            distance = originX - startX
        end

        node:setPosition(cc.p(startX, startY))

        local a1 = cc.DelayTime:create(duration)
        local a2 = CcFuns.createEaseBackOut(distance, 0.3, 0, vh, callback)
        local seq = cc.Sequence:create(a1, a2)
        node:runAction(seq)
    end
    --从四个方向移出的动作
    function CcFuns.createMoveOutAction(node, direct, duration, callback, offset)
        local distance = 0
        local vh

        if not duration then
            duration = 0
        end

        if not offset then
            offset = {x=0, y=0}
        end

        if CcFuns.moveInDirect.top == direct then
            distance = display.height
            vh = 1
        elseif CcFuns.moveInDirect.bottom == direct then
            distance = -display.height
            vh = 1
        elseif CcFuns.moveInDirect.left == direct then
            distance = -display.width
        elseif CcFuns.moveInDirect.right == direct then
            distance = display.width
        end

        local a1 = cc.DelayTime:create(duration)
        local a2
        if vh and vh == 1 then 
            a2 = cc.MoveBy:create(0.3, cc.p(0, distance))
        else
            a2 = cc.MoveBy:create(0.3, cc.p(distance, 0))
        end
        local a3 = cc.FadeOut:create(0.3)
        local a4 = cc.Spawn:create(a2, a3)

        if callback then
            local a5 = cc.CallFunc:create(callback)
            local seq = cc.Sequence:create(a1, a4, a5)
            node:runAction(seq)
        else
            local seq = cc.Sequence:create(a1, a4)
            node:runAction(seq)
        end
    end
    --淡入
    function CcFuns.createFadeInAction(node)
        node:setOpacity(0)
        local a1 = cc.DelayTime:create(0.3)
        local a2 = cc.FadeIn:create(0.2)
        local seq = cc.Sequence:create(a1, a2)
        node:runAction(seq)
    end

    --缩放进入
    function CcFuns.createScaleInAction(node, duration)
        local originScaleX = node:getScaleX()
        local originScaleY = node:getScaleY()
        local startScaleX = originScaleX + 1
        local startScaleY = originScaleY + 1

        if nil == duration then
            duration = 0
        end

        node:setScaleX(startScaleX)
        node:setScaleY(startScaleY)

        node:setOpacity(0)

        local a1 = cc.ScaleTo:create(0.2, originScaleX, originScaleY)
        local a2 = cc.FadeIn:create(0.1)
        local spawn = cc.Spawn:create(a1, a2)
        local seq = cc.Sequence:create(cc.DelayTime:create(duration), spawn)
        node:runAction(seq)
    end

    --淡出淡入
    function CcFuns.createFadeInOutAction(node, duration1, duration2, isforever)
        node:stopAllActions()
        node:setOpacity(255)

        local fadedown = CCFadeTo:create(duration1 or 1.0, 5)
        local fadeup   = CCFadeTo:create(duration2 or 0.5, 255)
        local seq = cc.Sequence:create(fadedown, fadeup)
        if isforever then
            node:runAction(cc.RepeatForever:create(seq))
        else
            node:runAction(seq)
        end
    end

    function CcFuns.replaceEmpty(name)
        return string.gsub(name, " ", "!<>");
    end

    function CcFuns.replaceBackToEmpty(name)
        return string.gsub(name, "!<>", " ");
    end

    --滚动label
    function CcFuns.createWordRunAction(label, time)
        local value = tonumber(label:getString());
        if value then
            time = time or 6;
            local interval = math.ceil(value / time);

            label:setString("0");
            for i = 1, time do
                label:performWithDelay(function()
                    local temp = tonumber(label:getString());
                    temp = temp + interval;
                    if temp > value then
                        temp = value;
                    end;

                    label:setString(temp);
                end, 0.05 * i);
            end;
        end;
    end

    --震屏
    function CcFuns.createShakeEffect()
        local range = 10
        local duration = 0.02

        local a1 = cc.MoveBy:create(duration, cc.p(0, range))
        local a2 = a1:reverse()
        local a3 = cc.MoveBy:create(duration, cc.p(-0, -range))
        local a4 = a3:reverse()
        local a5 = cc.MoveBy:create(duration, cc.p(-0, range))
        local a6 = a5:reverse()
        local a7 = cc.MoveBy:create(duration, cc.p(0, -range))
        local a8 = a7:reverse()

        local a9 = cc.MoveBy:create(duration, cc.p(0, range))
        local a10 = a9:reverse()
        local a11 = cc.MoveBy:create(duration, cc.p(-0, -range))
        local a12 = a11:reverse()
        local a13 = cc.MoveBy:create(duration, cc.p(-0, range))
        local a14 = a13:reverse()
        local a15 = cc.MoveBy:create(duration, cc.p(0, -range))
        local a16 = a15:reverse()

        local seq = cc.Sequence:create(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16)
        return seq
    end

    --选中框缩放效果
    function CcFuns.createSelSpriteAction(node, ratio, orScale)
        node:stopAllActions();

        local ratio = ratio or 1.04
        local scale = orScale or node:getScale();
        local action1 = cc.ScaleTo:create(0.5, scale * ratio);
        local action2 = cc.ScaleTo:create(0.5, scale * 1);
        local sequence = cc.Sequence:create(action1, action2);
        node:runAction(cc.RepeatForever:create(sequence));
    end


    --添加选中框
    function CcFuns.setSelectEffect(node)
        local heroHeadSelectBox = display.newSprite("#gongyong_anniu_di_3.png", nil, nil, { capInsets = cc.rect(5,5,91,90) })
        heroHeadSelectBox:setName("selectEffect")
        node:addChild(heroHeadSelectBox)
        CcFuns.relativeLayout(heroHeadSelectBox, node)
        CcFuns.createSelSpriteAction(heroHeadSelectBox)
    end

     --获取选中框@boxType 框类型
    function CcFuns.getSelectBoxEffect(boxType, noAction)
        boxType = boxType or 2
        local boxPic = {
            [2] = "#gongyong_anniu_di_2.png", --道具框
            [3] = "#gongyong_anniu_di_3.png", --英雄头像框
            [4] = "#gongyong_jinengxuanzhong.png", --技能类型选中框
            [5] = "#qiandao_kuang_2.png",           --签到当天选中框
        }
        local node = display.newSprite(boxPic[boxType], nil, nil, { capInsets = cc.rect(10,10,73,72) })
        if not noAction then
            CcFuns.createSelSpriteAction(node)
        end
        return node
    end


    --呼吸动作
    function CcFuns.createHeroBodyAction(node)
        node:stopAllActions();
        -- 一般没有把
        local scaleX, scaleY = node:getScaleX(), node:getScaleY();
        local action1 = cc.ScaleTo:create(1.0, scaleX * 1.05, scaleY * 1.05);
        local action2 = cc.ScaleTo:create(1.0, scaleX * 1, scaleY * 1);
        local sequence = cc.Sequence:create(action1, action2);
        node:runAction(cc.RepeatForever:create(sequence));
    end

    function CcFuns.setShader(node, enable, shader)
        if not node or node.getLetter then
            return
        end

        shader = enable and shader or "ShaderPositionTextureColor_noMVP"
        if node.getBoneDic and device.platform ~= "windows" then
            local t = node:getBoneDic()
            for key, var in pairs(t) do
                local skin = var:getDisplayRenderNode()
                if skin then
                    skin:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram(shader))
                end
            end
        elseif node.getChildrenCount and node:getChildrenCount() > 0 then
            -- 遍历子结点
            if node.getTexture then
                -- 精灵
                node:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram(shader))
            end
            local t = node:getChildren()
            for key, var in pairs(t) do
                CcFuns.setShader(var, enable, shader)
            end
        else
            if node.getTexture then
                -- 精灵
                node:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram(shader))
            elseif node.addChildBone then
                -- 骨骼
                local skin = node:getDisplayRenderNode()
                if skin then
                    skin:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram(shader))
                end
            end
        end
    end


    --查找节点
    function CcFuns.seekNodeByName(parent, name)
        if not parent then
            return
        end

        if name == parent:getName() then --if name == parent.name then
            return parent
        end

        local findNode
        local children = parent:getChildren()
        local childCount = parent:getChildrenCount()
        if childCount < 1 then
            return
        end
        for i=1, childCount do
            if "table" == type(children) then
                parent = children[i]
            elseif "userdata" == type(children) then
                parent = children:objectAtIndex(i - 1)
            end

            if parent then
                if name == parent:getName() then --if name == parent.name then
                    return parent
                end
            end
        end

        for i=1, childCount do
            if "table" == type(children) then
                parent = children[i]
            elseif "userdata" == type(children) then
                parent = children:objectAtIndex(i - 1)
            end

            if parent then
                findNode = CcFuns.seekNodeByName(parent, name)
                if findNode then
                    return findNode
                end
            end
        end

        return
    end

    --判断开放等级,满足返回true,不满足会弹个开放等级的弹窗
    --@id = config.Open.Open中的id
    function CcFuns.openLevelAndTips(id, noPop)
        local openConfig = GlobalConfig.openLevelConfig[id]
        if not openConfig then
            return true
        end
        if UserData.sharedUserData().m_level >= openConfig.level then
            return true
        end
        if not noPop then
            g_viewMgr():openPop("G_OpenLevelTipsPop", {id = openConfig.openDescId})
        end
        return false
    end

    -- studio 3.10 导出lua加载及屏幕适配
    -- params: @csbName 导出csb的名字, isMatch 是否需要适配
    -- 屏幕适配是控件相对于屏幕的位置，所以控件所加的父类的大小不是屏幕大小就没有必要适配。
    function CcFuns.uiloaderAndMatchScreen(scbName, isMatch)
        scbName=string.gsub(scbName, "/", ".");
        local studio = require("csb." .. scbName).create()
        if isMatch then 
            for i, v in pairs(studio.root:getChildren()) do
                local layout = ccui.LayoutComponent:bindLayoutComponent(v)
                if layout:getHorizontalEdge() == 2 then
                    v:setPositionX(v:getPositionX() + display.width - 960)
                elseif layout:getHorizontalEdge() == 3 then 
                    v:setPositionX(v:getPositionX() + display.cx - 480)
                end

                if layout:getVerticalEdge() == 2 then 
                    v:setPositionY(v:getPositionY() + display.height - 640)
                elseif layout:getVerticalEdge() == 3 then 
                    v:setPositionY(v:getPositionY() + display.cy - 320)
                end
            end 
        end
        return studio
    end

    function CcFuns.touchBtnCallback(btn, obj, callback, noScale, isSwallTouch)
        local orgScaleX = btn:getScaleX()
        local orgScaleY = btn:getScaleY()
        local beginPoint = nil
        local endPoint = nil
        isSwallTouch = isSwallTouch == nil and true or isSwallTouch
        local offset = CONFIG_TOUCH_MOVED_DISTANCE
        btn:setSwallowTouches(isSwallTouch)
        btn:addWidgetTouchListener(function(sender, event)
            if event == ccui.TouchEventType.began then
                if not noScale then  
                    sender:setScaleX(orgScaleX * 0.95)
                    sender:setScaleY(orgScaleY * 0.95)
                end
            elseif event == ccui.TouchEventType.canceled then 
                sender:setScaleX(orgScaleX)
                sender:setScaleY(orgScaleY)

            elseif event == ccui.TouchEventType.ended then
                beginPoint = sender:getTouchBeganPosition() 
                endPoint = sender:getTouchEndPosition()
                sender:setScaleX(orgScaleX)
                sender:setScaleY(orgScaleY)
                local offsetY = math.abs(endPoint.y - beginPoint.y)
                local offsetX = math.abs(endPoint.x - beginPoint.x)
                if offsetY < offset and offsetX < offset then
                    g_dispatcher.dispatch(GuideEvent.Excute)
                    if callback then
                        local tag = btn:getTag()
                        callback(obj, tag)
                    end
                end
            end
        end)
    end

    function CcFuns.touchNodeCallback(node, obj, callback, noScale)
        local orgScale = node:getScale()

        node:addNodeTouchEventListener(function(sender, event)
            if event.name == "began" then 
                if not noScale then  
                    sender:setScale(orgScale * 0.95)
                end
                return true
            elseif event.name == "moved" then 
            elseif event.name == "canceled" then 
                sender:setScale(orgScale)
            elseif event.name == "ended" then 
                g_dispatcher.dispatch(GuideEvent.Excute) 
                sender:setScale(orgScale)
                if callback then 
                    callback(obj)
                end
            end
        end, true)
    end


    --箭头的浮动效果，右和上为正方方向.dir = 1 or -1, isVertical = bool
    function CcFuns.createArrowAction(dir, isVertical, offset)
        offset = offset or 5
        local dst = offset * dir
        local a1 = nil
        if not isVertical then
            a1 = cc.MoveBy:create(0.75, cc.p(dst, 0))
        else
            a1 = cc.MoveBy:create(0.75, cc.p(0, dst))
        end
        local a2 = cc.Sequence:create(a1, a1:reverse())
        return cc.RepeatForever:create(a2)
    end

    --来回移动效果
    function CcFuns.createMoveAction(pos, callback)
        local a1 = cc.MoveBy:create(0.75, pos)
        local a2 = a1:reverse()
        local seq = cc.Sequence:create(a1, a2)
        if callback then
            seq = cc.Sequence:create(seq, cc.CallFunc:create(callback))  
        end
        return cc.RepeatForever:create(seq)
    end

    --不断重复同样的移动
    function CcFuns.createRepeatMoveAction(from, pos)
        local a1 = cc.MoveTo:create(0.75, pos)
        local a2 = cc.MoveTo:create(0, from)
        local seq = cc.Sequence:create(a1, a2)
        return cc.RepeatForever:create(seq)
    end


    --按钮长按动作@callback, @params回调时的参数
    function CcFuns.buttonPressAction(callback, params, timeInterval, delayTime)
        timeInterval = timeInterval or 0.1
        delayTime = delayTime or 0.5
        local pressDelay = cc.DelayTime:create(delayTime)
        local pressDelayCompele = cc.CallFunc:create(function ( sender )
            sender.isPress = true
            local handleFunc = cc.CallFunc:create(function ( sender )
                if callback then
                    callback(sender, params)
                end
            end)
            local timeIntervalAction = cc.DelayTime:create(timeInterval)
            local rfAction = cc.RepeatForever:create(cc.Sequence:create(handleFunc, timeIntervalAction))

            sender:stopAllActions()
            sender:runAction(rfAction)
        end)

        return cc.Sequence:create(pressDelay, pressDelayCompele)
    end


    --根据当前弹窗列表来判断使用什么方式打开这个弹窗
    function CcFuns.checkTheViewIsOpen(viewID, params)
        local isOpen = false
        for k,v in pairs(ViewMgr.getInstance()._popList) do
            if k == viewID then
                isOpen = true
                break
            end
        end
        
        if isOpen then
            g_viewMgr():getPopByID(viewID, params)
        else
            g_viewMgr():openPop(viewID, params)
        end
    end


    function CcFuns.getSkipToDestName(skipId)
        local config = require("config.ItemPathFrom.pathdraw")[skipId]
        if not config then
            return ""
        end
        return config.jumpTo
    end

    --@skipId 参考ItemPathFrom.pathdraw
    function CcFuns.skipToModuleOrPop(skipId, params)
        params = params or {}
        local config = require("config.ItemPathFrom.pathdraw")[skipId]
        if not config then
            print("ItemPathFrom.pathdraw没有对应的配置或对应模块尚未制作, skipId =", skipId)
            return            
        end

        --过滤参数
        if config.isOpen then
            local tag = tonumber(config.isOpen)
            if tag then
                if tag ~= 0 then
                    params.skipTag = tag
                end
            else
                params.skipTag = config.isOpen
            end
        end

        if config.type == 100 then
            if config.jumpTo == "G_CommonBuyTimes" then
                g_tipsMgr:ShowErrorTips(tonumber(config.isOpen))
            elseif config.jumpTo == "LegionWarShop" then
                LegionWarHandler.openLegionWarShop(tonumber(config.isOpen))
            else
                CcFuns.checkTheViewIsOpen(config.jumpTo, params)
            end


        elseif config.type == 2 then
            --普通副本
            params.levelID = config.isOpen
            CcFuns.checkTheViewIsOpen("InstanceLevelDetailView", params)
        elseif config.type == 3 then
            --精英副本
            params.levelID = config.isOpen
            CcFuns.checkTheViewIsOpen("InstanceLevelDetailEliteView", params)
        else
            if g_modMgr():isLevelEnoughEnterMoudule(config.jumpTo) then
                local isModuleRunning = g_modMgr():isRunningModule(config.jumpTo)
                if not isModuleRunning then
                    g_modMgr():runModule(config.jumpTo, params)
                else
                    --Fix Me
                    local view = g_viewMgr():getOnShowViewByID(config.jumpTo .. "RootView")
                    if view and view.skipToPop then
                        view.skipToPop(params)
                    end
                end

                --清这两个是因为有人从战斗结算跳出去
                g_modMgr():cleanModule("Battle")
                g_modMgr():cleanModule("BattleGroup")
                g_modMgr():cleanModule("Settlement")
            end
        end
    end

    --根据ID获取类型
    function CcFuns.getTypeByID(id)
        if id >= 1 and id <= 19999 then
            --资源
            return 1
        elseif id >= 20000 and id <= 29999 then
            --道具
            return 2
        elseif id >= 30000 and id <= 39999 then
            --武将
            return 3
        elseif id >= 40000 and id <= 49999 then
            --神兵
            return 4
        elseif id >= 50000 and id <= 59999 then
            --骑宠
            return 5
        elseif id >= 60000 and id <= 69999 then
            --异兽
            return 6
        elseif id >= 70000 and id <= 79999 then
            --装备
            return 7
        elseif id >= 80000 and id <= 89999 then
            --装备图纸
            return 8
        elseif id >= 90000 and id <= 99999 then
            --装备材料
            return 9
        elseif id >= 100000 and id <= 109999 then
            --天罡
            return 10
        elseif id >= 110000 and id <= 119999 then
            --天罡图纸
            return 11
        elseif id >= 120000 and id <= 129999 then
            --绝学
            return 12
        elseif id >= 130000 and id <= 139999 then
            --绝学图纸
            return 13
        elseif id >= 140000 and id <= 149999 then
            --武将碎片
            return 14
        elseif id >= 150000 and id <= 159999 then
            --秘籍（主将技能）
            return 15
        elseif id >= 160000 and id <= 169999 then
            --神兵碎片
            return 16
        else
            print("this type is not exist")
            return 0
        end
    end


    -- local params = {
    --     id = "",
    -- }
    --id是必须的,其余内容按各控件需求填充
    function CcFuns.createImage(params)
        local image = nil
        local id = tonumber(params.id)
        if CcFuns.getTypeByID(id) == 1 then
            params.resID = id
            image = ResImage.createImage(params)
        elseif CcFuns.getTypeByID(id) == 3 then
            params.heroID = id
            image = HeroImage.createHeadFrame(params)
        else
            params.itemId = id
            image = ItemImage.new(params)
        end
        return image
    end

    function CcFuns.createImageBattleUIHead(heroData)

    end

    function CcFuns.createImageBattleUIHead(heroData)
        if heroData and heroData.m_model then
            local box = display.newSprite("#"..HeroImage.HeroQualityImage[heroData.m_quality])
            local icon = GlobalConfig.s_modelconfig[heroData.m_model].icon
            local headIconPath = "pic/icon/head/".. CcFuns.filterFileExtendName(icon)
            local head = display.newSprite(headIconPath):addTo(box,-1)            
            head:setPosition(box:getContentSize().width*0.5,box:getContentSize().height*0.5)

            -- local starNode = display.newNode()
            -- starNode:setCascadeOpacityEnabled(true) 
            -- local starPosX = 0
            -- for i=1,heroData.m_star do
            --     local star = display.newSprite("#gongyong_xing.png"):addTo(starNode)
            --     star:setPosition(starPosX,0)
            --     star:setScale(0.7)
            --     starPosX = starPosX + 8
            -- end
            -- starNode:setContentSize(cc.size(starPosX,0))
            -- starNode:setAnchorPoint(0.5,0.5)
            -- starNode:setPosition(box:getContentSize().width*0.5+5,12)
            -- box:addChild(starNode)
            -- local levelbg = display.newSprite("#gongyong_dikuang_dengji.png"):addTo(box)
            -- levelbg:setPosition(16,72)
            -- levelbg:setScale(0.8)

            local level = display.newTTFLabel({text = heroData.m_level, size = FontsMgr.Content.Tiny}):addTo(box)
            level:setPosition(14,70)
            return box
        else
            print("ERROR！！！！战斗头像创建失败头像ID")
            dump(heroData)
        end
        return display.newNode()
    end


    --相对布局
    --origin 需要布局的节点
    --target 对齐的目标
    --layout 布局位置
    --offset 偏移位置
    --noConvert 不做坐标转换
    --target可以是Node或者position,
    --如果是Node的话,那么Node是需要有size,不然就按锚点对齐,可以是在不同的父节点,有坐标转换处理
    --如果是position的话,那么位置必须是以origin的父节点的坐标系
    --需要保证origin和target是有父节点的（不然不作任何处理,直接按照自身的坐标系计算,适合同一父节点内的）
    --可以对个方向布局,用位或,但是同轴的不能一起,例如左右不能同时布局
    CcFuns.Layout = {
        Center = bit.lshift(1, 0),      --中心对齐
        TopOut = bit.lshift(1, 1),      --在目标的顶上外面
        BottomOut = bit.lshift(1, 2),   --在目标的底下外面
        LeftOut = bit.lshift(1, 3),     --在目标的左边外面
        RightOut = bit.lshift(1, 4),    --在目标的右边外面
        TopIn = bit.lshift(1, 5),       --在目标的顶上里面
        BottomIn = bit.lshift(1, 6),    --在目标的底下里面
        LeftIn = bit.lshift(1, 7),      --在目标的左边里面
        RightIn = bit.lshift(1, 8),     --在目标的右边里面
    }
    function CcFuns.relativeLayout(origin, target, layout, offset, noConvert)
        -- if origin:getParent() == nil then
        --     print("origin parent can not be nil")
        --     return
        -- end

        -- print("layout : "..tostring(layout))

        local originSize = origin:getContentSize()
        originSize.width = originSize.width * origin:getScaleX()
        originSize.height = originSize.height * origin:getScaleY()
        local originAnchorPoint = origin:getAnchorPoint()
        local originPos = cc.p(origin:getPositionX(), origin:getPositionY())

        local targetSize = nil
        local targetAnchorPoint = nil
        local targetPos = nil

        if target.getContentSize then
            targetSize = target:getContentSize()
            targetSize.width = targetSize.width * target:getScaleX()
            targetSize.height = targetSize.height * target:getScaleY()
            targetAnchorPoint = target:getAnchorPoint()
            targetPos = cc.p(target:getPositionX(), target:getPositionY())
            if not noConvert and target:getParent() then
                targetPos = target:getParent():convertToWorldSpace(targetPos)
            end
        else
            targetSize = {width = 0, height = 0}
            targetAnchorPoint = cc.p(0, 0)
            targetPos = target
            -- targetPos = origin:getParent():convertToWorldSpace(targetPos)
        end

        local finalPos = cc.p(0, 0)
        local revisePos = cc.p(0, 0)

        layout = layout or CcFuns.Layout.Center
        offset = offset or cc.p(0, 0)

        --中心
        if CcFuns.Layout.Center == bit.band(layout, CcFuns.Layout.Center) then
            finalPos.x = targetPos.x + (0.5 - targetAnchorPoint.x) * targetSize.width
            finalPos.y = targetPos.y + (0.5 - targetAnchorPoint.y) * targetSize.height
        
            revisePos.x = (0.5 - originAnchorPoint.x) * originSize.width
            revisePos.y = (0.5 - originAnchorPoint.y) * originSize.height

            -- print("Center")
        end


        -- print("finalPos.y : "..tostring(finalPos.y))

        --上下
        if CcFuns.Layout.TopOut == bit.band(layout, CcFuns.Layout.TopOut) then
            finalPos.y = targetPos.y + (1 - targetAnchorPoint.y) * targetSize.height
            revisePos.y = originAnchorPoint.y * originSize.height
            -- print("TopOut")
        elseif CcFuns.Layout.TopIn == bit.band(layout, CcFuns.Layout.TopIn) then
            finalPos.y = targetPos.y + (1 - targetAnchorPoint.y) * targetSize.height
            revisePos.y = -(1 - originAnchorPoint.y) * originSize.height
            -- print("TopIn")
        elseif CcFuns.Layout.BottomOut == bit.band(layout, CcFuns.Layout.BottomOut) then
            finalPos.y = targetPos.y - targetAnchorPoint.y * targetSize.height
            revisePos.y = -(1 - originAnchorPoint.y) * originSize.height
            -- print("BottomOut")
        elseif CcFuns.Layout.BottomIn == bit.band(layout, CcFuns.Layout.BottomIn) then
            finalPos.y = targetPos.y - targetAnchorPoint.y * targetSize.height
            revisePos.y = originAnchorPoint.y * originSize.height
            -- print("BottomIn")
        end


        --左右
        if CcFuns.Layout.LeftOut == bit.band(layout, CcFuns.Layout.LeftOut) then
            finalPos.x = targetPos.x - targetAnchorPoint.x * targetSize.width
            revisePos.x = -(1 - originAnchorPoint.x) * originSize.width
            -- print("LeftOut")
        elseif CcFuns.Layout.LeftIn == bit.band(layout, CcFuns.Layout.LeftIn) then
            finalPos.x = targetPos.x - targetAnchorPoint.x * targetSize.width
            revisePos.x = originAnchorPoint.x * originSize.width
            -- print("LeftIn")
        elseif CcFuns.Layout.RightOut == bit.band(layout, CcFuns.Layout.RightOut) then
            finalPos.x = targetPos.x + (1 - targetAnchorPoint.x) * targetSize.width
            revisePos.x = originAnchorPoint.x * originSize.width
            -- print("RightOut")
        elseif CcFuns.Layout.RightIn == bit.band(layout, CcFuns.Layout.RightIn) then
            finalPos.x = targetPos.x + (1 - targetAnchorPoint.x) * targetSize.width
            revisePos.x = -(1 - originAnchorPoint.x) * originSize.width
            -- print("RightIn")
        end

        finalPos.x = finalPos.x + revisePos.x + offset.x
        finalPos.y = finalPos.y + revisePos.y + offset.y

        if not noConvert and origin:getParent() then
            finalPos = origin:getParent():convertToNodeSpace(finalPos)
        end
        origin:setPosition(finalPos)

    end



    --画线
    --posList 要画的线列表 {[1] = {from = cc.p(0, 0), to = cc.p(100, 100)}, [2] = {..}, ...}
    --colorList 线段的颜色,根据index匹配线段 {[1] = cc.c4b(255, 255, 255, 255), ...}
    --lineWidth 线段的粗细度
    function CcFuns.drawLine(posList, colorList, lineWidth)
        lineWidth = lineWidth or 1.0
        local defaultColor = cc.c4b(255, 255, 255, 255)
        local function primitivesDraw(transform, transformUpdated)
            kmGLPushMatrix()
            kmGLLoadMatrix(transform)
            gl.lineWidth(lineWidth)
            for index, pos in pairs(posList) do
                local color = colorList[index] or defaultColor
                cc.DrawPrimitives.drawColor4B(color.r, color.g, color.b, color.a)
                cc.DrawPrimitives.drawLine(pos.from, pos.to)
            end
            kmGLPopMatrix()
        end

        local glNode = gl.glNodeCreate()
        glNode:setAnchorPoint(cc.p(0, 0))
        glNode:registerScriptDrawHandler(primitivesDraw)
        return glNode
    end


    --解析数据状态
    function CcFuns.parseDataState(state, index)
        return bit.band(bit.rshift(state, index - 1), 1)
    end


    --每帧调用方法
    --主要用于分帧执行创建加载等逻辑,减轻卡顿感
    function CcFuns.createEveryFrameFunc(callback, totalTime, startTime, oldTimer)
        local curTime = startTime or 1
        local _timer = nil
        if oldTimer then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(oldTimer)
        end
        local function _stopTimer()
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(_timer)
        end
        local function _timerCallback(dt)
            if totalTime ~= nil then
                if curTime <= totalTime then
                    callback(_timer, curTime, "EVERY")
                else
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(_timer)
                    callback(_timer, nil, "FINISH")
                end
                curTime = curTime + 1
            else
                callback(_timer, nil, "EVERY")
            end
        end
        _timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(_timerCallback, 0, false)
        return {timer = _timer, stop = _stopTimer}
    end


    function CcFuns.print_table(lua_table, indent, showInfo)

        if nil == showInfo or true == showInfo then
            local traceback = string.split(debug.traceback("", 2), "\n")
            print("dump from: " .. string.trim(traceback[3]))
        end
        
        indent = indent or 0
        local formatting = ""
        for k, v in pairs(lua_table) do
            if type(k) == "string" then
                k = string.format("%q", k)
            end

            local szSuffix = ""
            if type(v) == "table" then
                szSuffix = "{"
            end

            local szPrefix = string.rep("    ", indent)
            formatting = szPrefix.."["..k.."]".." = "..szSuffix
            if type(v) == "table" then
                print(formatting)
                CcFuns.print_table(v, indent + 1, false)
                print(szPrefix.."},")
            else
                local szValue = ""
                if type(v) == "string" then
                    szValue = string.format("%q", v)
                else
                    szValue = tostring(v)
                end
                print(formatting..szValue..",")
            end
        end
        
    end


    --打印节点信息
    --绘制节点区域m名称
    function CcFuns.printChildrenSize(node)
        if node then
            local parentName = "";
            if node:getParent() then
                parentName = node:getParent():getName();
            end;
            if node:getName() == "" then
                local index = math.random(1, 10000000);
                node:setName("node_" .. index);
            end;
            print(parentName .. "->" .. node:getName());
            local size = node:getContentSize();
            print("size ".. size.width .. " " .. size.height);
            local rect = node:getBoundingBox();
            print("rect " .. rect.x .." " .. rect.y .. " ".. rect.width .. " " .. rect.height);


            local children = node:getChildren();
            for k,v in pairs(children) do
                CcFuns.printChildrenSize(v)
            end

           local s_blackLayer = cc.LayerColor:create(cc.c4b(255,0,0,100));
           s_blackLayer:setContentSize(node:getContentSize());
           node:addChild(s_blackLayer)

           local m_accountText = display.newTTFLabel({
            text = node:getName(),
            font = FontsMgr.Fonts.default,
            size = 24,
            color =cc.c3b(255, 255,255), 
            }) 
            m_accountText:setPosition(cc.p(s_blackLayer:getContentSize().width*0.5, s_blackLayer:getContentSize().height*0.5))
            s_blackLayer:addChild(m_accountText)
        end;
    end

    function CcFuns.debug_nodeSize(node)
        local s_blackLayer = cc.LayerColor:create(cc.c4b(255,0,0,100));
        s_blackLayer:setContentSize(node:getContentSize());
        node:addChild(s_blackLayer)
        s_blackLayer:setPosition(cc.p(0, 0));
    end;

    function CcFuns.debug_tableTojson_luafile(table, filename, filepath)
        if "windows" == device.platform and CONFIG_PLUGINS_SWITCH then
            local jsonstr = json.encode(table)
            filepath = filepath or "../../../docs/"
            filename = filename or "BattleReport"
            local exportFileName = filepath..filename..".lua"
            io.writefile(exportFileName,jsonstr)
        end
    end

    function CcFuns.debug_table_luafile_Tojson(_filename)
        local filepath =  "../../../docs/"
        local filename = _filename
        local exportFileName = filepath..filename..".lua"
        print("2222",exportFileName)
        local battlereportfile =  CcFuns.readFile(exportFileName)
        -- dump(battlereportfile)
        return json.decode(battlereportfile) 
    end

    function CcFuns.readFile(path)
        local file = io.open(path, "rb");
        if file then
            local content = file:read("*all");
            io.close(file);

            return content;
        end;

        return nil;
    end




    --创建动画序列表
    --sequence控制序列（string:1_4|2_4|3_4|4_10|5_3|6_3|7_25|8_20）
    function CcFuns.buildPoseFrames(pattern, sequence)
        local frames = {};
        local seqInfo = {}
        local sequenceList = string.split(sequence,"|")

        for _, frameOne in ipairs(sequenceList) do
            local frameOneList = string.split(frameOne,"_")
            local framesInfo = {}
            framesInfo.frameIndex = tonumber(frameOneList[1]) 
            framesInfo.frameTime = tonumber(frameOneList[2]) 
            table.insert(seqInfo, framesInfo)
        end

        for _, v in ipairs(seqInfo) do
            local frameName = string.format(pattern, v.frameIndex);
            local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName);

            local m_frameSize = spriteFrame:getRect();
            if spriteFrame and m_frameSize.height > 20 then
              for n=1, v.frameTime do
                  frames[#frames + 1] = spriteFrame;
              end
            else
              print(pattern.."  缺帧:"..frameName)
            end

            -- local m_frameSize = spriteFrame:getRect();
            --     for n=1, v.frameTime do
            --         frames[#frames + 1] = spriteFrame;
            --     end
            -- if spriteFrame and m_frameSize.height > 50 then
            -- else
            --   -- TipsFuncs.ShowDebugErrorTips("有空模型"..pattern..frameName)
            --   print(pattern.."  缺帧:"..frameName)
            -- end
        end

        return frames;
    end

    

    --解析带分割符的数据，转换成num
    --@param str 原来数据string
    --@param sep 分割符
    --@param ... 参数
    --@return table
    function CcFuns.parserStrToNum(str, sep, ... )
        local tableList = {}
         local args = {...}
        local sequenceList = string.split(str,sep)
        for i=1, #sequenceList do
            local data = tonumber(sequenceList[i]) 
            tableList[args[i] or i] = data;
            if not data then
                tableList[args[i] or i] = sequenceList[i];
            end
        end
        return tableList;
    end


    --显示获取物品
    function CcFuns.showRewardTips(rewardList)
        local rewardParam = {}
        for k, v in pairs(rewardList) do
            table.insert(rewardParam, {id = v.code, amount = v.amount})
        end
        g_viewMgr():openPop("G_RewardPop", rewardParam)
    end

    --显示获取物品飘字
    function CcFuns.showRewardTextTips(rewardList)
        local stringTable = {}
        for k, v in pairs(rewardList) do
            local itemConfig = ItemInterface.getConfigByLocalId(tonumber(v.code))
            if itemConfig then
                table.insert(stringTable, g_langUtils:getString(itemConfig.name).."x"..tostring(v.amount))
            end
        end
        local tips = table.concat(stringTable, "\n")
        g_tipsMgr:ShowTips(tips)
    end

    --移动listView内容器的位置
    function CcFuns.moveListViewContainer(listView, destPos, noAction)
        local listViewSize = listView:getContentSize()
        local containerSize = listView:getInnerContainerSize()
        local limitX = containerSize.width - listViewSize.width
        local limitY = containerSize.height - listViewSize.height

        if destPos.x > 0 then
            destPos.x = 0
        end
        if destPos.x < -limitX then
            destPos.x = -limitX
        end

        if destPos.y > 0 then
            destPos.y = 0
        end
        if destPos.y < -limitY then
            destPos.y = -limitY
        end
        

        if limitX > 0 or limitY > 0 then --表示内容的长度比显示区域大
            if noAction then
                listView:setInnerContainerPosition(destPos)
            else
                local param = {
                    x = destPos.x,
                    y = destPos.y,
                    easing = "EXPONENTIALOUT",
                    time = 0.1,
                }
                transition.moveTo(listView:getInnerContainer(), param)
            end
        end
    end




    function CcFuns.PointApplyAffineTransform(point, t)
        local p = cc.p(0, 0)
        p.x = t.a * point.x + t.c * point.y + t.tx
        p.y = t.b * point.x + t.d * point.y + t.ty
        return p;
    end

    function CcFuns.RectApplyAffineTransform(rect, anAffineTransform)
        local top    = rect.y + rect.height
        local left   = rect.x
        local right  = rect.x + rect.width
        local bottom = rect.y
        
        local topLeft = CcFuns.PointApplyAffineTransform(cc.p(left, top), anAffineTransform);
        local topRight = CcFuns.PointApplyAffineTransform(cc.p(right, top), anAffineTransform);
        local bottomLeft = CcFuns.PointApplyAffineTransform(cc.p(left, bottom), anAffineTransform);
        local bottomRight = CcFuns.PointApplyAffineTransform(cc.p(right, bottom), anAffineTransform);

        local minX = math.min(math.min(topLeft.x, topRight.x), math.min(bottomLeft.x, bottomRight.x))
        local maxX = math.max(math.max(topLeft.x, topRight.x), math.max(bottomLeft.x, bottomRight.x))
        local minY = math.min(math.min(topLeft.y, topRight.y), math.min(bottomLeft.y, bottomRight.y))
        local maxY = math.max(math.max(topLeft.y, topRight.y), math.max(bottomLeft.y, bottomRight.y))
            
        return cc.rect(minX, minY, (maxX - minX), (maxY - minY));
    end

    --获取节点的串联AABB包围盒
    function CcFuns.getCascadeBoundingBox(node)
        local cbb = cc.rect(0, 0, 0, 0)
        local contentSize = node:getContentSize();
        
        local merge = false;

        for k,child in pairs(node:getChildren()) do
            if child:isVisible() then
                local box = CcFuns.getCascadeBoundingBox(child)
                if box.width > 0 and box.height > 0 then
                    if not merge then
                        cbb = box
                        merge = true
                    else
                        cbb = cc.rectUnion(cbb, box)
                    end
                end
            end
        end

        if contentSize.width > 0 and contentSize.height > 0 then
            local box = CcFuns.RectApplyAffineTransform(cc.rect(0, 0, contentSize.width, contentSize.height), node:getNodeToWorldAffineTransform())
            if not merge then
                cbb = box
            else
                cbb = cc.rectUnion(cbb, box)
            end
        end
        
        return cbb;
    end

    function CcFuns.setOpacityAll(node, Opacityvalu)
        if not node or node.getLetter then
            return
        end
        if node.getChildren and table.nums(node:getChildren())  > 0 then
            -- 遍历子结点
            local t = node:getChildren()
            for key, var in pairs(t) do
                CcFuns.setOpacityAll(var, Opacityvalu)
            end
        end
        
        if node.getTexture then
            -- 精灵
            node:setOpacity(Opacityvalu)
        elseif node.getSprite then
            --九宫格
            node:getSprite():setOpacity(Opacityvalu)
        elseif node.addChildBone then
            -- 骨骼
            local skin = node:getDisplayRenderNode()
            if skin then
                skin:setOpacity(Opacityvalu)
            end
        end
    end

    --连同下面的方法,实现裁剪武将头像用于魂魄框
    function CcFuns.replaceWithClippingIcon(node)
        local nodeType = tolua.type(node)
        if nodeType == "cc.ClippingNode" then
            return node
        elseif nodeType == "cc.Sprite" or nodeType == "ccui.ImageView" then
            local clippingNode = cc.ClippingNode:create()
            clippingNode:setAlphaThreshold(0)
            clippingNode:setName(node:getName())
            clippingNode:setLocalZOrder(node:getLocalZOrder())
            clippingNode:setPosition(node:getPosition())

            local stencil = cc.Sprite:create()
            stencil:setAnchorPoint(node:getAnchorPoint())
            stencil:setPosition(0, 0)
            clippingNode:setStencil(stencil)

            local spClone = node:clone()
            spClone:setVisible(true)
            spClone:setScale(1)
            spClone:setPosition(0, 0)

            clippingNode:addChild(spClone)
            if node:getParent() then
                node:getParent():addChild(clippingNode)
                node:removeFromParent()
            end
            return clippingNode
        else
            print(string.format("invalid node:%s", nodeType))
        end
    end

    function CcFuns.setClippingIconTexture(clippingNode, pathImage, pathStencil, scaleToImage)
        local image = clippingNode:getChildByName(clippingNode:getName())
        local isSprite = image.setSpriteFrame and true or false
        if string.find(pathImage, "pic/") then
            if isSprite then
               image:setTexture(pathImage)
            else
               image:loadTexture(pathImage, ccui.TextureResType.localType)
            end
        else
            if isSprite then
               image:setSpriteFrame(pathImage)
            else
               image:loadTexture(pathImage, ccui.TextureResType.plistType)
            end
        end

        local stencil = clippingNode:getStencil()
        if string.find(pathStencil, "pic/") then
            stencil:setTexture(pathStencil)
        else
            stencil:setSpriteFrame(pathStencil)
        end

        local imageContentSize = image:getContentSize()
        local stencilContentSize = stencil:getContentSize()
        if scaleToImage then
            stencil:setScaleX(imageContentSize.width / stencilContentSize.width)
            stencil:setScaleY(imageContentSize.height / stencilContentSize.height)
        end
        -- clippingNode:setContentSize(imageContentSize)
    end


    --指定一个图片路径,获取经过圆形裁剪后的图像
    function CcFuns.getCircleIconSpriteByClipping(pathImage, pathStencil)
        pathStencil = pathStencil or "gongyong_2anniu_2.png"
        local sprite = display.newSprite()
        sprite:setName("spIcon")
        sprite = CcFuns.replaceWithClippingIcon(sprite)
        CcFuns.setClippingIconTexture(sprite, pathImage, pathStencil)
        return sprite
    end



    --用table替换listView
    --@listView 不一定是个listView,node就行
    function CcFuns.replaceTableViewWithListView(listView, listenerList)
        local size = listView:getContentSize()
        local rect = listView:getTouchRect()
        local tableView = cc.TableView:create(size)
        tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        tableView:setPosition(rect.x, rect.y)
        tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        tableView:setDelegate()
        tableView:addTo(listView:getParent())

        tableView:registerScriptHandler(listenerList.sizeListener, cc.TABLECELL_SIZE_FOR_INDEX)
        tableView:registerScriptHandler(listenerList.cellIndexListener, cc.TABLECELL_SIZE_AT_INDEX)
        tableView:registerScriptHandler(listenerList.amountListener, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  

        if listView:getParent() then
            listView:removeFromParent()
        end

        return tableView
    end







    --[[
        scrollview 所操作的滚动层
        unitItem   添加的元件
        rowNum     每一行的个数
        number     当前添加的是第几个
        addChildCallback 添加后的回调
    ]]

    --添加scrollView 一排多个item
    function CcFuns.addItemChild(ScrollView, unitItem, rowNum, number, addChildCallback)
        ScrollView:addChild(unitItem)
        local itemSize = unitItem:getContentSize()
        local contentSize = ScrollView:getInnerContainerSize()
        local row = math.floor((number - 1) / rowNum) + 1
        local col = math.mod(number - 1, rowNum)
        local positionX = itemSize.width * col
        local positionY = contentSize.height - itemSize.height * row

        unitItem:setPosition(cc.p(positionX, positionY))
        if addChildCallback then
            addChildCallback(unitItem)
        end
    end


    --汉字显示排名
    function CcFuns.chineseNumber(index)

        if      index == 0      then     return g_langUtils:getString(2708) 
        elseif  index == 1      then     return g_langUtils:getString(2709)
        elseif  index == 2      then     return g_langUtils:getString(2710)
        elseif  index == 3      then     return g_langUtils:getString(2711)
        elseif  index == 4      then     return g_langUtils:getString(2712)
        elseif  index == 5      then     return g_langUtils:getString(2713)
        elseif  index == 6      then     return g_langUtils:getString(2714)
        elseif  index == 7      then     return g_langUtils:getString(2715)
        elseif  index == 8      then     return g_langUtils:getString(2716)
        elseif  index == 9      then     return g_langUtils:getString(2717)
        elseif  index == 10     then     return g_langUtils:getString(2718)
        elseif  index == 100    then     return g_langUtils:getString(2719)
        elseif  index == 1000   then     return g_langUtils:getString(2720)
        elseif  index == 10000  then     return g_langUtils:getString(2721)
        end

    end

    function CcFuns.getChineseStringNum(digitalNum)

        if digitalNum < 0 then
            print("the number %d is not proper to transform, please check it", digitalNum)
            return
        end

        local strTable = {}
        local tenThousand = math.floor(digitalNum / 10000)
        local thousand = math.floor(math.mod(digitalNum, 10000) / 1000)
        local hundred = math.floor(math.mod(digitalNum, 1000) / 100)
        local ten = math.floor(math.mod(digitalNum, 100) / 10)
        local num = math.floor(math.mod(digitalNum, 10) / 1)

        if tenThousand > 0 then
            local str_tenThousand = CcFuns.chineseNumber(tenThousand) .. CcFuns.chineseNumber(10000)
            table.insert(strTable, str_tenThousand)
        end

        if thousand > 0 then
            local str_thousand = CcFuns.chineseNumber(thousand) .. CcFuns.chineseNumber(1000)
            table.insert(strTable, str_thousand)
        end

        if hundred > 0 then
            local str_hundred = CcFuns.chineseNumber(hundred) .. CcFuns.chineseNumber(100)
            table.insert(strTable, str_hundred)
        end

        local str_ten = ""
        if ten > 1 then
            str_ten = CcFuns.chineseNumber(ten) .. CcFuns.chineseNumber(10)
        elseif ten == 1 then
            str_ten = CcFuns.chineseNumber(10)
        elseif ten == 0 then
            if tenThousand > 0 or thousand > 0 or hundred > 0 then
                str_ten = CcFuns.chineseNumber(ten)
            end
        end
        table.insert(strTable, str_ten)

        local str_num = ""
        if num > 0 then
            str_num = CcFuns.chineseNumber(num)
        end
        table.insert(strTable, str_num)

        return table.concat(strTable)
    end


    --定时回调
    function CcFuns.delayCallback(node, callback, delay)
        node = node or g_viewMgr()._root
        node:performWithDelay(function()
            callback()
        end, delay)
    end

    --添加公共背景到节点中
    function CcFuns.addGongYongBgToNode(node, zorder)
        zorder = zorder or 0
        local filePath = GlobalConfig.gongyongBg
        local  function callback()
            local bg = display.newSprite(filePath)
            bg:setPosition(cc.p(display.cx, display.cy))
            bg:setLocalZOrder(zorder)
            node:addChild(bg)
        end

        display.addNoAlphaImageAsync(filePath, callback)
    end

    --进度条控件;ImageViewNode是一个cocostudio九宫格的ImageView控件,nPercent是进度条数值(0~100),ImageViewbg进度条底，用来获取原始大小
    function CcFuns.SetProgressBarPercent(ImageViewNode, nPercent, ImageViewbg)
      if ImageViewNode and nPercent then
            local w = ImageViewbg:getContentSize().width
            local h = ImageViewNode:getContentSize().height
            if nPercent > 100 then
              nPercent = 100
            end
            if nPercent < 0 then
              nPercent = 0
            end
            if 0 < nPercent and 10>=nPercent then
              nPercent = 10
            end
            if nPercent == 0 then
              ImageViewNode:setVisible(false)
            else
              ImageViewNode:setVisible(true)
              ImageViewNode:setContentSize(cc.size(nPercent/100.0*w, h))
            end
      end

    end


    ---字幕滚动式显示文本方法组
    --[[
        node,       执行action的节点和文本组的父节点
        content,    string 或 ccui.Text, ccui.Text的情况,将ccui.Text作为占位框看待
        maxWidth,   最大宽度
        cacheTable, 用来保存文本组的table,因为会retain文本,务必在需要的时候释放
        readSpeed,  阅读速度
        callback,   播放完毕后的回调

        @return action, labelGroup(当前预定显示的文本组,数量<=cacheTable)
    ]]
    function CcFuns.startTextFadeAction(node, content, maxWidth, cacheTable, readSpeed, callback)
        readSpeed = readSpeed or cc.Director:getInstance():getAnimationInterval() * 3
        local strContent = content
        local fontSize = FontsMgr.Content.Small
        local orgX, orgY = 0, 0
        if type(content) ~= "string" and tolua.type(content) == "ccui.Text" then
            strContent = content:getString()
            fontSize = content:getFontSize()
            local rect = content:getTouchRect()
            orgX, orgY = rect.x, rect.y + rect.height
            content:setVisible(false)
        end

        local labelGroup = CcFuns.createOneWordLabelGroup(strContent, fontSize, cacheTable)

        --计算位置
        local curX, curY = 0, 0
        local size = cc.size(0, 0)
        for k,label in pairs(labelGroup) do
            label:setVisible(false)
            label:setAnchorPoint(0, 1)          
            label:setPosition(orgX + curX, orgY + curY)
            label:addTo(node)
            size = label:getContentSize()


            if label:getString() == '\n' then
                curX = 0
                curY = curY - (size.height / 2)
            else
                curX = curX + size.width
                if curX >= maxWidth then
                    curX = 0
                    curY = curY - size.height
                end
            end
        end

        --开始渐变动画
        local oneWordTime = readSpeed * 6

        local count = 0
        local function nextWord()
            count = count + 1
            local label = labelGroup[count]
            if not label then
                return
            end

            label:setVisible(true)
            label:setOpacity(0)
            local args = {
                time = oneWordTime,
                easing = "SINEIN",
            }
            transition.fadeIn(label, args)
        end

        local function finished()
            if callback then
                callback()
            end
        end

        local funcAction = cc.CallFunc:create(nextWord)
        local delayAction = cc.DelayTime:create(readSpeed)
        local seqAction = cc.Sequence:create(funcAction, delayAction)
        local repeatAction = cc.Repeat:create(seqAction, table.nums(labelGroup))
        local seqAction2 = cc.Sequence:create(repeatAction, cc.CallFunc:create(finished))
        node:runAction(seqAction2)
        return seqAction2, labelGroup
    end

    function CcFuns.createOneWordLabelGroup(str, fontSize, cacheTable)
        local oneWordTable = StrFuns.getEveryOneForUtfstr(str)
        local result = {}
        for i,v in ipairs(oneWordTable) do
            local label = CcFuns.getLabelForLabelCache(cacheTable, i)
            label:setString(v)
            result[i] = label
        end
        return result
    end

    function CcFuns.getLabelForLabelCache(cacheTable, index, fontSize)
        fontSize = fontSize or FontsMgr.Title.Biger
        local cache = cacheTable[index]
        if not cache then
            cache = display.newTTFLabel({text = "", size = fontSize})
            cache:retain()
            cacheTable[index] = cache
        end
        if cache:getParent() then
            cache:removeFromParentAndCleanup(false)
        end
        return cache
    end
    --------字幕滚动式显示end

    --@param callback 关闭云的回调
    function CcFuns.InstancecloudAction(callback)

        -- local layout = display.newLayer(cc.c4b(0, 0, 0, 20));
        -- display.getRunningScene():addChild(layout)

        -- local bg = display.newSprite("pic/map/loading_beijing.jpg"):addTo(layout)
        -- bg:setPosition(cc.p(display.cx, display.height))

        -- local lbToday = display.newTTFLabel({text = "资源加载中，此过程不消耗流量...", size = FontsMgr.Content.Middle}):addTo(layout)
        -- lbToday:setAnchorPoint(0.5, 0.5)
        -- lbToday:setPosition(cc.p(display.cx, display.height*0.3))

        -- local loadingPic = "pic/map/logo.png"
        -- local imgLoading = display.newSprite(loadingPic)
        -- imgLoading:setPosition(cc.p(display.cx, display.height*0.6))
        -- layout:addChild(imgLoading)

        -- -- local action = cc.RotateBy:create(5, 360)
        -- -- imgLoading:runAction(cc.RepeatForever:create(action))

        -- local array = {}
        -- table.insert(array, cc.DelayTime:create(0.4))
        -- table.insert(array, cc.CallFunc:create(function()  if callback then callback() end end))
        -- table.insert(array, cc.DelayTime:create(0.4))
        -- table.insert(array, cc.RemoveSelf:create())
        -- layout:runAction(cc.Sequence:create(array))

        -- local function onTouchBegan(touch, event)
        --     return true
        -- end
        -- local listener = cc.EventListenerTouchOneByOne:create()
        -- listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        -- listener:setSwallowTouches(true)
        -- local eventDispatcher = layout:getEventDispatcher()
        -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layout)


        local cloud1 = display.newSprite("pic/map/img_cloud1.png")
        local cloud2 = display.newSprite("pic/map/img_cloud2.png")
        display.getRunningScene():addChild(cloud1)
        display.getRunningScene():addChild(cloud2)

        cloud1:setAnchorPoint(cc.p(0.5, 0.5))
        cloud2:setAnchorPoint(cc.p(0.5, 0.5))
        cloud1:setScale(6)
        cloud2:setScale(6)
        cloud2:setScaleY(-6)

        local cloud1_Pos_start = cc.p(-500,display.cy)
        local cloud1_Pos_target = cc.p(display.cx-100,display.cy)
        local cloud2_Pos_start = cc.p(display.width+500,display.cy)
        local cloud2_Pos_target = cc.p(display.cx+100,display.cy)

        cloud1:setPosition(cloud1_Pos_start)
        cloud2:setPosition(cloud2_Pos_start)

        local array = {}
        local array2 = {}
        table.insert(array, cc.EaseIn:create(cc.MoveTo:create(0.4, cloud1_Pos_target), 0.6 )  )
        table.insert(array, cc.CallFunc:create(function()  if callback then callback() end end))
        table.insert(array, cc.Spawn:create(cc.FadeOut:create(0.4), cc.MoveTo:create(0.3, cloud1_Pos_start)) )  
        table.insert(array, cc.CallFunc:create(function() 
                cloud1:removeFromParent()
            end))
        
        table.insert(array2, cc.EaseIn:create(cc.MoveTo:create(0.4, cloud2_Pos_target), 0.6)  )
        table.insert(array2, cc.Spawn:create(cc.FadeOut:create(0.4), cc.MoveTo:create(0.3, cloud2_Pos_start)) )  
        table.insert(array2, cc.CallFunc:create(function() 
                cloud2:removeFromParent()
            end))

        cloud1:runAction(cc.Sequence:create(array))
        cloud2:runAction(cc.Sequence:create(array2))

        local function onTouchBegan(touch, event)
            return true
        end
        local registTouchEven = function(node)
            local listener = cc.EventListenerTouchOneByOne:create()
            listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
            listener:setSwallowTouches(true)
            local eventDispatcher = node:getEventDispatcher()
            eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
        end

        registTouchEven(cloud1)
        registTouchEven(cloud2)
    end


    --帧回调action
    function CcFuns.getFrameCallbackAction(callback, timeInterval)
        timeInterval = timeInterval or cc.Director:getInstance():getAnimationInterval()
        local funcAction = cc.CallFunc:create(callback)
        local delayAction = cc.DelayTime:create(timeInterval)
        local seqAction = cc.Sequence:create(funcAction, delayAction)
        local repAction = cc.RepeatForever:create(seqAction)
        return repAction
    end

    --文本动画 @callback @return 中间结果值,用于设定自定义的数字表现
    function CcFuns.runTextNumberAction(label, orgNumber, newNumber, actionTime, callback)
        orgNumber = orgNumber or label.orgNumber or tonumber(label:getString()) or 0
        newNumber = newNumber or tonumber(label:getString())

        label.orgNumber = orgNumber
        local offsetValue = newNumber - orgNumber

        local baseActiontime = 1
        actionTime = actionTime or baseActiontime
        local splitNumber = math.ceil( (actionTime / baseActiontime) * 30 )

        --根据offsetValue计算分割数和动画时间?

        local retTable = StrFuns.splitNumByAverage(offsetValue, splitNumber) --StrFuns.splitNumByAverage
        local count = 0
        local countTotal = #retTable
        local function oneStep()
            count = count + 1
            if count > countTotal then
                label:stopActionByTag(3199)
                return
            end
            if retTable[count] then
                label.orgNumber = label.orgNumber + retTable[count]
                if callback then
                    callback(label.orgNumber)
                else
                    label:setString(label.orgNumber)
                end
            end
        end

        label:stopActionByTag(3199)
        local action = CcFuns.getFrameCallbackAction(oneStep, baseActiontime / splitNumber)
        action:setTag(3199)
        label:runAction(action)
    end


    -- 按钮计时可点
    -- params: @btn:按钮 time:计时
    function CcFuns.setButtonTouchAtSometime(btn, time)
        local function canTouch()
            btn:setTouchEnabled(true)
        end
        local function canNotTouch()
            btn:setTouchEnabled(false)
        end
        local action1 = cc.CallFunc:create(canNotTouch)
        local delay = cc.DelayTime:create(time)
        local action2 = cc.CallFunc:create(canTouch)
        btn:runAction(transition.sequence({action1, delay, action2}))
    end

    --[[
        --最终显示的文字设置在传入的textHolder里面
        textHolder类型暂时为ccui.Text 或者 ccui.TextField
        textHolder必须先设置好大小，否则无法取得EditBox点击范围
        editHandler为EditBox点击事件可以重写
        strText editbox站位文本
    ]]

    function CcFuns.createTextEditBox(textHolder, editHandler, strText)
        print("textHolder type = ", tolua.type(textHolder))
        local textFieldHolderText = g_langUtils:getString(2722)
        if tolua.type(textHolder) == "ccui.TextField" then
            print("error 建议不要这种写法 EditBox和TextField在设备上会有冲突")
            textFieldHolderText = textHolder:getPlaceHolder()
        end

        local psX, psY = textHolder:getPosition()
        local boxSize = textHolder:getContentSize()
        local chatEdit = ccui.EditBox:create(cc.size(boxSize.width, boxSize.height), "gongyong_liaotian_di.png", 1)
        chatEdit:setAnchorPoint(textHolder:getAnchorPoint())
        chatEdit:setPosition(cc.p(psX, psY))
        chatEdit:setPlaceholderFontSize(FontsMgr.Content.Small)
        chatEdit:setFontSize(FontsMgr.Content.Small)
        chatEdit:setPlaceHolder(strText or textFieldHolderText)
        
        chatEdit:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
        chatEdit:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        chatEdit:setOpacity(0)
        local function handler(event)
            if "began" == event then
                local text = textHolder:getString()
                chatEdit:setText(text)
                chatEdit:setPlaceHolder("")
                textHolder:setString("")
                if tolua.type(textHolder) == "ccui.TextField" then
                    textHolder:setPlaceHolder("")
                end
                --chatEdit:setVisible(false)
            elseif "return" == event then
                chatEdit:setVisible(true)
                local tempContent  = chatEdit:getText()
                chatEdit:setText("")
                if tempContent ~= "" then
                    chatEdit:setPlaceHolder("")
                    textHolder:setString(tempContent)
                else
                    if tolua.type(textHolder) == "ccui.TextField" then
                        textHolder:setPlaceHolder(textFieldHolderText)
                    end
                end
                
            end
        end
        chatEdit:registerScriptEditBoxHandler(editHandler or handler)

        return chatEdit
    end


    function CcFuns.createAchieveBottom(id, fontColor, fontSize, fontStyle, notBottom)
        local AchievementTitleConfig = require ("config.achieve.Title")
        local configAchievement = AchievementTitleConfig[id]

        local achievementPlist = ModuleConfig.s_plists["Achievement"]
        if achievementPlist then
            for i,v in pairs(achievementPlist) do
                display.addModPlist(v)
            end
        end

        local node = display.newNode()
        local function removePlist()
            if achievementPlist then
                for i,v in pairs(achievementPlist) do
                    display.removeModPlist(v)
                end
            end
        end
        node:onNodeEvent("exit", removePlist)

        if not notBottom then
            local imgBottom = ccui.ImageView:create()
            imgBottom:loadTexture(configAchievement["background"], 1)
            node:addChild(imgBottom)
        end

        local textName = ccui.Text:create()
        textName:setFontSize(fontSize or FontsMgr.Content.Small)
        textName:setFontName(fontStyle or FontsMgr.Fonts.default)
        textName:setString(g_langUtils:getString(configAchievement.name))
        textName:setColor(fontColor or FontsMgr.Color.QWhite)
        textName:enableOutline(FontsMgr.Color.Black, 1)
        node:addChild(textName)

        return node
    end

    function CcFuns.createMilitaryBottom(id, fontColor, fontSize, fontStylen, noEffect)
        local RankTitleConfig = require("config.arena.RankTitle")
        local config = RankTitleConfig[id]

        local militaryPlist = ModuleConfig.s_plists["Military"]
        if militaryPlist then
            for i,v in pairs(militaryPlist) do
                display.addModPlist(v)
            end
        end
        local defaultColor = FontsMgr.QualityColor[config.quality] or FontsMgr.Color.QWhite

        local function removePlist()
            if militaryPlist then
                for i,v in pairs(militaryPlist) do
                    display.removeModPlist(v)
                end
            end
        end

        local node = display.newNode()
        node:onNodeEvent("exit", removePlist)

        if config.specialeffect_2 and config.specialeffect_2 ~= 0 then
            local bottomEffect = FlashxManager.getInstance():newEffect(config.specialeffect_2, nil, nil, true)
            local bottomOffset = config.offset[2]
            bottomEffect:setPosition(bottomOffset.x, bottomOffset.y)
            node:addChild(bottomEffect, 0)
        end

        local imgBottom = ccui.ImageView:create()
        imgBottom:loadTexture(config["background"], 1)
        node:addChild(imgBottom, 1)

        local imgName = ccui.ImageView:create()
        imgName:loadTexture(config["arttitle"], 1)
        node:addChild(imgName, 3 - config.hierarchy)


        if not noEffect and config.specialeffect_1 and config.specialeffect_1 ~= 0 then
            local topEffect = FlashxManager.getInstance():newEffect(config.specialeffect_1, nil, nil, true)
            local topOffset = config.offset[1]
            topEffect:setPosition(topOffset.x, topOffset.y)
            node:addChild(topEffect, 2)
        end
        -- local textName = ccui.Text:create()
        -- textName:setFontSize(fontSize or FontsMgr.Content.Small)
        -- textName:setFontName(fontStyle or FontsMgr.Fonts.default)
        -- textName:setString(g_langUtils:getString(config.name))
        -- textName:setColor(fontColor or defaultColor)
        -- textName:enableOutline(FontsMgr.Color.Black, 1)
        -- node:addChild(textName)

        return node
    end


    --描边 btnType = 1(蓝色按钮), 2(橙色按钮)
    function CcFuns.enableOutlineForBtn(btn, btnType)
        btnType = btnType or 1
        local colorTable = {
            [1] = cc.c3b(0x0f, 0x22, 0x49),
            [2] = cc.c3b(0x40, 0x16, 0x05),
        }
        local color = colorTable[btnType]
        if color then
            btn:getTitleRenderer():enableOutline(color, 2)
        end
    end

    --简单检查一个矩形超过内容矩形的范围,返回应该调整的X,Y偏移值
    function CcFuns.checkRectHowOutMuch(rect, containerRect)
        local offsetX = 0
        local offsetY = 0
        if rect.x < containerRect.x then
            offsetX = containerRect.x - rect.x
        end
        if rect.x + rect.width > containerRect.x + containerRect.width then
            offsetX = (containerRect.x + containerRect.width) - (rect.x + rect.width)
        end
        if rect.y < containerRect.y then
            offsetY = containerRect.y - rect.y
        end
        if rect.y + rect.height > containerRect.y + containerRect.height then
            offsetY = (containerRect.y + containerRect.height) - (rect.y + rect.height)
        end
        return offsetX, offsetY
    end

    --动画 场景上出现一个背包图标，配合物品更换使用
    CcFuns.item2BagPos = cc.p(display.width*0.8, display.height*0.2)
    function CcFuns.item2BagAnimation(cb)
        local spName = "item2BagSp"
        local sp = display.getRunningScene():getChildByName(spName)
        if sp then
            sp:removeFromParent();
        end
        
        sp = cc.Sprite:createWithSpriteFrameName("zhucheng_beibao.png")
        sp:setPosition(CcFuns.item2BagPos)
        sp:setName(spName);
        display.getRunningScene():addChild(sp);

        local removeCallback = function()
            sp:removeFromParent();
        end 
        local actionArray = {}
        local action0 = cc.DelayTime:create(0.5)
        local action3 = cc.ScaleTo:create(0.3, 0)
        local action4 = nil;
        if cb then
            action4 = cc.CallFunc:create(cb)
        end
        local action5 = cc.CallFunc:create(removeCallback)
        table.insert(actionArray, action0)
        table.insert(actionArray, action1)
        table.insert(actionArray, action2)
        table.insert(actionArray, action3)            
        table.insert(actionArray, action4)
        table.insert(actionArray, action5)

        sp:runAction(cc.Sequence:create(actionArray))


    end

    --给文本设置下划线
    function CcFuns.enableBottomLineForLabel(label)
        local orgColor = label:getTextColor()
        local color = cc.c4b(orgColor.r / 255, orgColor.g / 255, orgColor.b / 255, 255 / 255)

        label:removeChildByName("lineNode")
        local lineNode = cc.DrawNode:create()
        lineNode:setName("lineNode")
        lineNode:setLineWidth(1)
        lineNode:drawLine(cc.p(0, 0), cc.p(label:getContentSize().width, 0), color)
        lineNode:addTo(label)


        -- local lineNode = CcFuns.drawLine({[1] = {from = cc.p(0, 0), to = cc.p(label:getContentSize().width, 0)}}, {[1] = color}, 1)
        -- lineNode:setName("lineNode")
        -- lineNode:addTo(label)
    end

    --[[
        没有特殊条件的物品资源是否足够的检查(itemId可以是等级,VIP等级等所有资源类型),
        callback, 购买后的回调,因为有的物品可以直接在商城买
        不满足时会弹出对应的缺少框
    ]]
    function CcFuns.checkItemIsEnough(itemId, need, callback)
        local itemType = ItemInterface.getItemTypeByLocalId(itemId)
        local own = ItemInterface.getTargetArticleAmount( itemId )

        if own < need then
            if itemType == ItemDataConfig.ItemType.Resource then
                local errorCode = ItemInterface.getErrorCodeById(itemId)
                if errorCode then
                    local tipsFromData = require("config.ItemPathFrom.TipsFrom")[errorCode]
                    local params = {}
                    local viewName = ""
                    if tipsFromData.notictype == 1 then
                        params.noticeCode = errorCode
                        params.id = tipsFromData.resid
                        params.noticeType = G_CommonNotice:getTypeByResId(tipsFromData.resid)
                        viewName = "G_CommonNotice"
                    elseif tipsFromData.notictype == 2 then 
                        params.noticeCode = errorCode
                        params.purcharseType = tipsFromData.buyType
                        viewName = "G_CommonBuyTimes"
                    end
                    params.needAmount = need
                    CcFuns.checkTheViewIsOpen(viewName, params)
                else
                    --检查该物品是否能直接在商城购买
                    if not G_ShopBuy.openBuyItem(itemId, callback) then
                        g_viewMgr():openPop("G_AcquiringWay", {id = itemId, checkType = 1})
                    else
                        g_tipsMgr:ShowTips(g_langUtils:getString(2635))
                    end
                end
            else
                --检查该物品是否能直接在商城购买
                if not G_ShopBuy.openBuyItem(itemId, callback) then
                    g_viewMgr():openPop("G_AcquiringWay", {id = itemId, checkType = 1})
                else
                    g_tipsMgr:ShowTips(g_langUtils:getString(2635))
                end
            end
            return false
        end
        return true
    end

    -- 奴隶互动效果(如全屏从上往下掉鸡腿图标)
    -- parent 父节点
    -- direction 1从上向下 2从下向上 3从左到右 4从右向左 5全屏随机
    -- res 图片资源
    -- callback 回调
    -- second 回调间隔
    -- iconNum 默认图标个数


    function CcFuns.createFullScreenAnimation(parent, direction, res, callback, second, iconNum)
        local moveSpeedX = 650
        local moveSpeedY = 500
        second = second or 0
        iconNum = iconNum or 12

        --随机队列
        local randomXList = {}
        local randomYList = {}
        while(#randomXList < iconNum or #randomYList < iconNum) do
            local randomNumX = math.random(4, iconNum + 4) * 0.05
            if not table.keyof(randomXList, randomNumX) and #randomXList < iconNum then
                table.insert(randomXList, randomNumX)
            end

            local randomNumY = math.random(4, iconNum + 4) * 0.05
            if not table.keyof(randomYList, randomNumY) and #randomYList < iconNum then
                table.insert(randomYList, randomNumY)
            end
        end

        local maxDuration = 0
        local parentSize = parent:getContentSize()
        for i = 1, iconNum do
            local iconSprite = display.newSprite("#" .. res):addTo(parent)

            local posX, posY
            local targetPosX, targetPosY
            local duration
            if direction == 1 then
                iconSprite:setAnchorPoint(0.5, 1)

                posX = parentSize.width * randomXList[i]
                posY = parentSize.height * (randomYList[i] + 1)

                targetPosX = posX
                targetPosY = 0

                duration = math.abs(posY - targetPosY) / moveSpeedY
            elseif direction == 2 then
                iconSprite:setAnchorPoint(0.5, 0)

                posX = parentSize.width * randomXList[i]
                posY = parentSize.height * (randomYList[i] - 1)

                targetPosX = posX
                targetPosY = parentSize.height

                duration = math.abs(posY - targetPosY) / moveSpeedY
            elseif direction == 3 then
                iconSprite:setAnchorPoint(0, 0.5)

                posX = parentSize.width * (randomXList[i] - 1)
                posY = parentSize.height * randomYList[i]

                targetPosX = parentSize.width
                targetPosY = posY

                duration = math.abs(posX - targetPosX) / moveSpeedX
            elseif direction == 4 then
                iconSprite:setAnchorPoint(1, 0.5)

                posX = parentSize.width * (randomXList[i] + 1)
                posY = parentSize.height * randomYList[i]

                targetPosX = 0
                targetPosY = posY

                duration = math.abs(posX - targetPosX) / moveSpeedX
            elseif direction == 5 then
                iconSprite:setAnchorPoint(0.5, 0.5)

                posX = parentSize.width * randomXList[i]
                posY = parentSize.height * randomYList[i]

                duration = 3
            end
            iconSprite:setPosition(posX, posY)

            if duration > maxDuration then
                maxDuration = duration
            end

            if direction == 5 then
                iconSprite:setOpacity(0)
                local a1 = cc.FadeIn:create(randomXList[i] * 2)
                local a2 = cc.DelayTime:create(duration - randomXList[i] * 2 - randomYList[i] * 2)
                local a3 = cc.FadeOut:create(randomYList[i] * 2)
                local sequence = cc.Sequence:create(a1, a2, a3)

                iconSprite:runAction(sequence)
            else
                local moveBy = cc.MoveTo:create(duration, cc.p(targetPosX, targetPosY))
                local a1 = cc.FadeIn:create(0.5)
                local a2 = cc.DelayTime:create(duration - 1)
                local a3 = cc.FadeOut:create(0.5)
                local sequence = cc.Sequence:create(a1, a2, a3)
                local spawn = cc.Spawn:create(moveBy, sequence)

                iconSprite:runAction(spawn)
            end
        end

        if callback then
            local action = transition.sequence({
                cc.DelayTime:create(maxDuration - second),
                cc.CallFunc:create(callback),
            })

            parent:runAction(action)
        end
    end


    --wordPic   美术字图片
    function CcFuns.getSceneEnterEffect(wordPic, wordPic2)
        wordPic = wordPic or ""
        local effect = FlashxManager.getInstance():newEffect(FlashxConfig.EffectId.siege_open)
        effect:setPosition(display.cx, display.cy)

        local sprite = display.newSprite()
        if string.find(wordPic, "pic/") then
            sprite:setTexture(wordPic)
        else
            sprite:setSpriteFrame(wordPic)
        end
        sprite:addTo(effect, 100000)
        sprite:setOpacity(0)
        sprite:setScale(0)
        local fadeIn = cc.FadeIn:create(0.2)
        local scale = cc.ScaleTo:create(0.2, 1)
        local spawn = cc.Spawn:create(fadeIn, scale)
        sprite:runAction(spawn)
        
        if wordPic2 then
            local sprite2 = display.newSprite()
            sprite2:setName("sprite2")
            if string.find(wordPic2, "pic/") then
                sprite2:setTexture(wordPic2)
            else
                sprite2:setSpriteFrame(wordPic2)
            end
            -- sprite2:setAnchorPoint(cc.p(0,0.5))
            print("----------",sprite:getPositionX(),sprite:getContentSize().width)
            sprite2:setPositionX(sprite:getPositionX() + sprite:getContentSize().width)
            sprite2:addTo(effect, 100000)
            sprite2:setOpacity(0)
            sprite2:setScale(0)
            local fadeIn = cc.FadeIn:create(0.2)
            local scale = cc.ScaleTo:create(0.2, 1)
            local spawn = cc.Spawn:create(fadeIn, scale)
            sprite2:runAction(spawn)
        end

        local delay = cc.DelayTime:create(0.5)
        local scale = cc.ScaleTo:create(0.25, 2)
        local fadeOut = cc.FadeOut:create(0.25)
        local spawn = cc.Spawn:create(scale, fadeOut)
        local seq = cc.Sequence:create(delay, spawn)

        effect:setCascadeOpacityEnabled(true)
        effect:runAction(seq)

        return effect
    end

    function CcFuns.numberValueAction()
        -- body
    end

    --测试使用时间
    --
    --local localTime = socket.gettime()
    --localTime = CcFuns.printTime(localTime, str)
    function CcFuns.printTime(localTime, str)

        if not socket then
            require "socket"
        end
        
        local localTimecur = socket.gettime()
        local time = localTimecur - localTime
        local printStr = str or "ERROR    使用时间"
        print(printStr,time)
        return localTimecur

    end


    function CcFuns.getWorldLevelExpAdd()
        local worldLevel = UserData.sharedUserData().worldLevel
        local curLevel = UserData.sharedUserData().m_level
        local differLv = worldLevel - curLevel
        local m_exp_add = 0
        if worldLevel > 0 then
            for k,v in pairs(GlobalConfig.worldlevelConfig) do
                if v.level_difference_1 <= differLv and v.level_difference_2 >= differLv then
                    m_exp_add = v.exp_add
                end
            end
        end
        return m_exp_add
    end


end