local env = require("env")

local audioM = {}
audioM.musicChannel = 1

function audioM.setVolume(vol)
    audio.setVolume(vol, {channel=audioM.musicChannel})
end

function audioM.playMusic(track)
    audioM.setVolume(env.MUSIC_VOLUME)
    audio.play(track, {channel=audioM.musicChannel, loops=-1})
end

function audioM.stopMusic()
    audio.stop(audioM.musicChannel)
end

function audioM.mute(mute)
    if mute then
        audio.setVolume(0, {channel=audioM.musicChannel})
    else
        audio.setVolume(env.MUSIC_VOLUME, {channel=audioM.musicChannel})
    end
end

return audioM
