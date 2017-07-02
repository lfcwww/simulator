
if not MusicType then
    local MusicType = {}
    cc.exports.MusicType = MusicType

    --战斗音效
    MusicType.BatEffect = {
        
    }

    MusicType.UIEffect = {
        get_reward = "music/sound/gongxihuode.mp3",             --恭喜获得
        receivereward = "music/sound/receivereward.mp3",        --十连物品
        conjure_item = "music/sound/zhaohuan.mp3",              --招募到物品
        conjure_hero = "music/sound/xiyouzhaohuan.mp3",         --招募到武将
        rockTree = "music/sound/yaoqianshu.mp3",                --摇钱
        maleRole = "music/sound/man1.mp3",                      --男主角
        femaleRole = "music/sound/woman4.mp3",                  --女主角
        settleWin = "music/sound/win.mp3",                      --结算胜利
        settleFail = "music/sound/fail.mp3",                    --结算失败

        btnClick = "music/sound/battlestart.mp3",               --普通按钮点击,点击登录
        warning = "music/sound/warning.mp3",                    --警告提示
        unlock = "music/sound/unlock.mp3",                      --开箱子
        leadLevelUp = "music/sound/leadlevelup.mp3",            --队伍升级
        battleStart = "music/sound/battlestart.mp3",            --进入战斗
        angerFull = "music/sound/angerfull.mp3",                --怒气满
        wearEquipment = "music/sound/wearequipment.mp3",        --穿戴东西
        openFuc = "music/sound/openfuc.mp3",                    --解锁新功能/武将
        popInterface = "music/sound/popinterface.mp3",          --弹出新界面
        shopRefresh = "music/sound/shoprenovate.mp3",           --商店刷新
        bossInfo = "music/sound/bossdetail.mp3",                --BOSS信息出现
        heroSkillStudy = "music/sound/herostarup.mp3",          --主将技激活
        heroSkillLevelUp = "music/sound/scroll3.mp3",           --主将技升级(技能)
        beastIllusion = "music/sound/buff3.mp3",                --骑宠幻化
        beastTrain = "music/sound/bwmjopen.mp3",                --骑宠培养
        beastCrit = "music/sound/bwmjreset.mp3",                --骑宠暴击

        embattleOnPos = "music/sound/jiabuff02.mp3",            --人物上阵
        equipLevelUp = "music/sound/sword4.mp3",                --装备强化
        equipDecompose = "music/sound/forge1.mp3",              --装备合成
        equipStarUp = "music/sound/heroqualityup.mp3",          --装备升星
        equipWash = "music/sound/ggzjrenovate.mp3",             --装备洗练

        welcomeButton = "music/sound/egmusie.mp3",              --欢迎界面点击按钮音效
        welcomeEnter = "music/sound/greet.mp3",                 --欢迎界面音效

        heroLevelUp = "music/sound/herolevelup.mp3",            --武将升级
        heroStarUp = "music/sound/herostarup.mp3",              --武将升星
        heroExpUp = "music/sound/expup.mp3",                    --武将吃经验丹

        refresh = "music/sound/ggzjrenovate.mp3",               --各种武将刷新

        warPerLevelUp = "music/sound/herolevelup.mp3",            --侍女升级
        warPerStarUp = "music/sound/herostarup.mp3",              --侍女升星

        battleTarget = "music/sound/dancichoujiang.mp3",             --战斗中的本关目标

        levelUp = "music/sound/shengji.mp3",                    --升级
        LoginFlash = "music/sound/piantouyinxiao.mp3",          --开场音效

        dramaChapter = "music/sound/juqing.mp3",                --章节剧情音效

        battleRoundEx = "music/sound/huiheqiehuan.mp3",                --战斗回合切换
        battleRoundExdef = "music/sound/huiheqiehuan1.mp3",               --防御方回合切换

        magicalTrain = "music/sound/herolevelup.mp3", --神兵培养
        magicalWash = "music/sound/huiheqiehuan.mp3", --神兵洗练
        magicalRebirth = "music/sound/heroqualityup.mp3", --转生成功
        magicalJewelCombine = "music/sound/forge1.mp3", --宝石合成
        magicalJewelTakeOn = "music/sound/wearequipment.mp3", --宝石镶嵌
        magicalJewelTakeOff = "music/sound/wearequipment.mp3", --宝石卸下
        
        nationMap = "bgm/bg8.mp3", --国战地图
        nationAtk = "bgm/bg4.mp3", --国战进攻方
        nationDef = "bgm/bg5.mp3", --国战防守方

        cheer = "music/sound/huanhu.mp3", --胜利欢呼
        footstep = "music/sound/paobu.mp3", --脚步声
        
        liquor = "music/sound/duijiu.mp3", --对酒音效
        shakeDice = "music/sound/yaoshaizi.mp3", --骰子音效
        chooseNation = "music/juqing/voice_guide_033.mp3", --选择国家

        chuangguan = "music/sound/chuangguanshibai.mp3",
    }

    MusicType.TalkingPath = {
        default = "music/juqing/",
        Instance = "music/juqing/",
        Guide = "music/juqing/",
    }

end