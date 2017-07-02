--
-- Author: jun
-- Date: 2015-03-16 20:29:41
--
if not cc.exports.MusicMgr then
    local MusicMgr = {}
    local currentMusicType = nil 

    cc.exports.MusicMgr = MusicMgr

    local deUser = cc.UserDefault:getInstance()
    local UserInfo = {
        switchMusic = "switchMusic",
        switchSound = "switchSound",
        allVolume = "allVolume",
    }

    MusicMgr.switchMusic = nil --true = 开启音乐
    MusicMgr.switchSound = nil --本地文件读较好
    MusicMgr.allVolume = nil

    --音乐文件路径
    local musicPath = "res/music/"

    function MusicMgr.getCurrentMusicType()
        return currentMusicType
    end

    function MusicMgr.playMusic(musicType, isAptPath)
        if currentMusicType == musicType then
            return
        end
        currentMusicType = musicType

        if MusicMgr.getSwitchMusic() == false then
            return 
        end
        local filepath = nil
        if not isAptPath then
            filepath = musicPath .. currentMusicType
        else
            filepath = currentMusicType
        end

        local fullPath = cc.FileUtils:getInstance():fullPathForFilename(filepath)
        audio.playMusic(fullPath)
    end

    function MusicMgr.pauseMusic()
        audio.pauseMusic()
    end

    function MusicMgr.stopMusic()
        currentMusicType = nil
        audio.stopMusic()
    end

    function MusicMgr.resumeMusic()
        audio.resumeMusic()
    end

    function MusicMgr.playSound(musicType)
        if MusicMgr.getSwitchSound() == false then
            return 
        end
        local fullPath = cc.FileUtils:getInstance():fullPathForFilename(musicType)
        audio.playSound(fullPath)
    end

    function MusicMgr.stopSound()
        audio.stopAllSounds()
    end

    function MusicMgr.unloadSound(musicType)
        local fullPath = cc.FileUtils:getInstance():fullPathForFilename(musicType)
        audio.unloadSound(fullPath)
    end

    --播放语音
    function MusicMgr.playVoice(name)
        MusicMgr.playSound(string.format("music/juqing/%s", name))
    end

    function MusicMgr.unloadVoice(name)
        MusicMgr.unloadSound(string.format("music/juqing/%s", name))
    end


    --设置总体音量
    function MusicMgr.setVolume(value)
        if value then
            MusicMgr.setMusicVolume(value)
            MusicMgr.setSoundsVolume(value)
            MusicMgr.allVolume = value
        end
    end

    --获取音量
    function MusicMgr.getVolume()
        if MusicMgr.allVolume ~= nil then
            return MusicMgr.allVolume
        end

        MusicMgr.allVolume = deUser:getFloatForKey(UserInfo.allVolume, 1)
        return MusicMgr.allVolume
    end

    function MusicMgr.setMusicVolume(value)
        if value then
            audio.setMusicVolume(value)
        end
    end
    
    function MusicMgr.setSoundsVolume(value)
        if value then
            audio.setSoundsVolume(value)
        end
    end

    function MusicMgr.setSwitchMusic(state)
        if state == nil then
            return 
        end

        MusicMgr.switchMusic = state
        if MusicMgr.switchMusic == false then
            --防止重播这里先释放掉
            audio.stopMusic(true)
        else
            --开启音乐时，继续播放，如果没有播放音乐，则播放最后记录的音乐文件
            if ( not audio.isMusicPlaying() ) and currentMusicType ~=nil then
                audio.preloadMusic(musicPath .. currentMusicType)
                audio.playMusic(musicPath .. currentMusicType)
            end
            AudioEngine.resumeMusic()
        end
    end

    function MusicMgr.getSwitchMusic()
        if MusicMgr.switchMusic ~= nil then
            return MusicMgr.switchMusic
        end

        MusicMgr.switchMusic = deUser:getBoolForKey(UserInfo.switchMusic, true)
        return MusicMgr.switchMusic
    end

    function MusicMgr.setSwitchSound(state)
        if state == nil then
            return 
        end
        MusicMgr.switchSound = state
        -- if MusicMgr.switchSound == false then
        --     audio.pauseAllSounds()
        -- else
        --     audio.resumeAllSounds()
        -- end

    end

    function MusicMgr.getSwitchSound()
        if MusicMgr.switchSound ~= nil then
            return MusicMgr.switchSound
        end

        MusicMgr.switchSound = deUser:getBoolForKey(UserInfo.switchSound, true)
        return MusicMgr.switchSound
    end

    function MusicMgr.saveSwitchStateToFile()
        deUser:setBoolForKey(UserInfo.switchMusic, MusicMgr.getSwitchMusic())
        deUser:setBoolForKey(UserInfo.switchSound, MusicMgr.getSwitchSound())
        -- deUser:setFloatForKey(UserInfo.allVolume, MusicMgr.getVolume())
    end
end