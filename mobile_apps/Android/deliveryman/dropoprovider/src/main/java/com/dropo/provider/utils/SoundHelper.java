package com.dropo.provider.utils;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.SoundPool;

import com.dropo.provider.R;

public class SoundHelper {

    private static SoundHelper soundHelper;
    private SoundPool soundPool;
    private boolean loaded, plays;
    private int tripRequestSoundId;
    private int streamID1;

    private SoundHelper(Context context) {
        initializeSoundPool(context);
    }

    public static SoundHelper getInstance(Context context) {
        if (soundHelper == null) {
            soundHelper = new SoundHelper(context);
        }
        return soundHelper;
    }

    /**
     * this method is used to init sound pool for play sound file
     */
    private void initializeSoundPool(Context context) {
        if (soundPool == null) {
            AudioAttributes audioAttributes = new AudioAttributes.Builder().setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE).build();
            soundPool = new SoundPool.Builder().setMaxStreams(1).setAudioAttributes(audioAttributes).build();
            soundPool.setOnLoadCompleteListener(new SoundPool.OnLoadCompleteListener() {
                @Override
                public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
                    loaded = true;
                }
            });
            tripRequestSoundId = soundPool.load(context, R.raw.beep, 1);
        }
    }

    public void playWhenNewOrderSound() {
        // Is the sound loaded does it already play?
        if (loaded && !plays) {
            // the sound will play for ever if we put the loop parameter -1
            streamID1 = soundPool.play(tripRequestSoundId, 1, 1, 1, -1, 0.5f);
            plays = true;
        }
    }

    public void stopWhenNewOrderSound(Context context) {
        if (plays) {
            soundPool.stop(streamID1);
            tripRequestSoundId = soundPool.load(context, R.raw.beep, 1);
            plays = false;
        }
    }
}