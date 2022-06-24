import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/domain/manager/local_sound_player.dart';
import 'package:rain_sounds/domain/manager/timer_controller.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

List<Mix> mixesFromJson(String str) =>
    List<Mix>.from(json.decode(str).map((category) => Mix.fromJson(category)));

List<Sound> soundsFromJson(String str) =>
    List<Sound>.from(json.decode(str).map((sound) => Sound.fromJson(sound)));

class SoundService {
  // in-memory categories
  List<Mix> mixes = <Mix>[];
  List<Sound> sounds = <Sound>[];
  bool isPlaying = false;
  int totalActiveSound = 0;

  final LocalSoundPlayer localSoundManager;
  final TimerController timerController;

  SoundService(
      {required this.localSoundManager, required this.timerController});

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
          print('Premium mix: ${mix.name}');
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
      isPlaying = true;
      timerController.start();
    }

    return selected;
  }

  Future<List<Sound>> stopAllPlayingSounds() async {
    List<Sound> playing = await getSelectedSounds();

    for (var element in playing) {
      localSoundManager.stop(element);
      updateSound(element.id, false, element.volume);
    }
    isPlaying = false;
    timerController.pause();
    print('SoundService stopped');
    return playing;
  }

  Future<List<Sound>> pauseAllPlayingSounds() async {
    List<Sound> playing = await getSelectedSounds();

    for (var element in playing) {
      localSoundManager.pause(element);
    }
    isPlaying = false;
    timerController.pause();
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
        if (isPlaying) {
          final currentSelected = await getSelectedSounds();
          isPlaying = currentSelected.isNotEmpty;

          if (currentSelected.isEmpty) {
            timerController.pause();
            timerController.reset();
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
