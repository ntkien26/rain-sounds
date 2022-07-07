import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/services.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/domain/manager/local_sound_player.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

List<Mix> mixesFromJson(String str) =>
    List<Mix>.from(json.decode(str).map((category) => Mix.fromJson(category)));

List<Sound> soundsFromJson(String str) =>
    List<Sound>.from(json.decode(str).map((sound) => Sound.fromJson(sound)));

class SoundService {
  // in-memory categories
  List<Mix> mixes = <Mix>[];
  List<Sound> sounds = <Sound>[];
  final BehaviorSubject<bool> _isPlaying = BehaviorSubject<bool>.seeded(false);

  ValueStream<bool> get isPlaying => _isPlaying.stream;
  int totalActiveSound = 0;
  final LocalSoundPlayer localSoundManager;
  final PlaybackTimer playbackTimer;

  SoundService({required this.localSoundManager, required this.playbackTimer}) {
    _isPlaying.listen((isPlaying) {
      if (isPlaying) {
        playbackTimer.start();
      } else {
        playbackTimer.pause();
      }
    });
  }

  Future<String> _loadMixesAsset() async {
    return await rootBundle.loadString(Assets.mixesJson);
  }

  Future<String> _loadSoundsAsset() async {
    return await rootBundle.loadString(Assets.soundsJson);
  }

  Future<List<Mix>> loadMixes() async {
    if (mixes.isNotEmpty) {
      return mixes;
    }

    String jsonString = await _loadMixesAsset();
    mixes.clear();
    mixes.addAll(mixesFromJson(jsonString));
    await _loadSounds();
    await _loadPremiumMixes();
    return mixes;
  }

  Future<List<Mix>> _loadPremiumMixes() async {
    final premiumSounds = sounds.where((element) => element.premium);
    mixes.forEach((mix) {
      bool isPremium = false;
      mix.sounds?.forEach((sound) {
        if (premiumSounds.any((premiumSound) => sound.id == premiumSound.id)) {
          isPremium = true;
        }
      });
      updateMix(mix.mixSoundId, isPremium);
    });
    return mixes;
  }

  Future<List<Sound>> loadSounds(String categoryId) async {
    return sounds
        .where((sound) => sound.id.toString().substring(0, 1) == categoryId)
        .toList();
  }

  List<Sound> loadSoundsFromIds(List<int> ids) {
    final List<Sound> list = List.empty(growable: true);
    for (var id in ids) {
      list.add(sounds.firstWhere((element) => element.id == id));
    }
    return list;
  }

  Future<List<Sound>> _loadSounds() async {
    sounds.clear();
    String jsonString = await _loadSoundsAsset();
    sounds.addAll(soundsFromJson(jsonString));
    return sounds;
  }

  Future<List<Sound>> getSelectedSounds() async {
    final list = sounds.where((sound) => sound.active).toList();
    for (var element in list) {
      print('Selected sound: ${element.name}');
    }
    totalActiveSound = list.length;
    return list;
  }

  Future<List<Sound>> playAllSelectedSounds() async {
    List<Sound> selected = await getSelectedSounds();

    for (var element in selected) {
      localSoundManager.play(element);
    }

    if (selected.isNotEmpty) {
      print('SoundService is Playing');
      _isPlaying.add(true);
      playbackTimer.start();
    }

    AssetsAudioPlayer.allPlayers().values.forEach((element) {
      element.isPlaying.listen((isPlaying) {
        _isPlaying.add(AssetsAudioPlayer.allPlayers()
            .values
            .every((element) => element.isPlaying.value));
      });
    });

    return selected;
  }

  Future<List<Sound>> stopAllPlayingSounds() async {
    List<Sound> playing = await getSelectedSounds();

    for (var element in playing) {
      localSoundManager.stop(element);
      updateSound(element.id, false, element.volume);
    }
    _isPlaying.add(false);
    playbackTimer.off();
    playbackTimer.reset();
    print('SoundService stopped');
    return playing;
  }

  Future<List<Sound>> pauseAllPlayingSounds() async {
    List<Sound> playing = await getSelectedSounds();

    for (var element in playing) {
      localSoundManager.pause(element);
    }
    _isPlaying.add(false);
    playbackTimer.pause();
    print('SoundService paused');
    return playing;
  }

  Future<bool> updateMix(int mixId, bool premium) async {
    if (mixes.isEmpty) return false;
    int mixIndex = mixes.indexWhere((mix) => mix.mixSoundId == mixId);
    if (mixIndex > -1) {
      Mix mix = mixes[mixIndex].copyWith(premium: premium);
      mixes[mixIndex] = mix;
    }

    return true;
  }

  Future<bool> updateSound(int soundId, bool active, double volume) async {
    if (sounds.isEmpty) return false;
    int soundIndex = sounds.indexWhere((sound) => sound.id == soundId);
    if (soundIndex > -1) {
      Sound sound = sounds[soundIndex].copyWith(active: active, volume: volume);
      sounds[soundIndex] = sound;

      if (active) {
        playAllSelectedSounds();
      } else {
        localSoundManager.stop(sound);
        if (_isPlaying.value) {
          final currentSelected = await getSelectedSounds();
          _isPlaying.add(currentSelected.isNotEmpty);
          if (currentSelected.isEmpty) {
            playbackTimer.pause();
            playbackTimer.reset();
          }
        } else {
          totalActiveSound -= 1;
        }
      }

      return true;
    }

    return false;
  }

  Future<void> playSounds(List<Sound> sounds) async {
    await stopAllPlayingSounds();
    for (var element in sounds) {
      updateSound(element.id, true, element.volume);
    }
  }
}
