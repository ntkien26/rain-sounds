import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/domain/manager/audio_manager.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

List<Mix> mixesFromJson(String str) => List<Mix>.from(json.decode(str).map((category) => Mix.fromJson(category)));
List<Sound> soundsFromJson(String str) => List<Sound>.from(json.decode(str).map((sound) => Sound.fromJson(sound)));

class SoundService {
  // in-memory categories
  List<Mix> mixes = <Mix>[];
  List<Sound> sounds = <Sound>[];
  bool isPlaying = false;

  final AudioManager audioManager;

  SoundService(this.audioManager);

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
    _loadSounds();
    return mixes;
  }

  // Map all the sounds from categories to a flatten list
  Future<List<Sound>> _mapSounds() async {
    sounds.clear();
    for (var category in mixes) {
      sounds.addAll(category.sounds ?? List.empty());
    }
    return sounds;
  }

  Future<List<Sound>> loadSounds(String categoryId) async {
    return sounds
        .where((sound) => sound.id.toString().substring(0, 1) == categoryId)
        .toList(); //sound id = 201, 2 is category id
  }

  Future<List<Sound>> _loadSounds() async {
    sounds.clear();
    String jsonString = await _loadSoundsAsset();
    sounds.addAll(soundsFromJson(jsonString));
    return sounds;
  }

  Future<List<Sound>> getSelectedSounds() async {
    return sounds.where((sound) => sound.active).toList();
  }

  Future<List<Sound>> playAllSelectedSounds() async {
    List<Sound> selected = await getSelectedSounds();

    for (var element in selected) {
      audioManager.play(element);
    }

    // check if there were any selected sounds then player state is changed
    if(selected.isNotEmpty) {
      isPlaying = true;
    }

    return selected;
  }

  Future<List<Sound>> stopAllPlayingSounds() async {
    List<Sound> playing = await getSelectedSounds();

    for (var element in playing) {
      audioManager.stop(element);
    }

    // check if there were any selected sounds then player state is changed
    if(playing.isNotEmpty) {
      isPlaying = false;
    }

    return playing;
  }

  Future<bool> updateSound(String soundId, bool active, double volume) async {
    if (sounds.isEmpty) return false;

    int soundIndex = sounds.indexWhere((sound) => sound.id == soundId);
    if (soundIndex > -1) {
      Sound sound = sounds[soundIndex].copyWith(active: active, volume: volume);
      sounds[soundIndex] = sound;

      if (active) {
        playAllSelectedSounds();
      } else {
        audioManager.stop(sound);
        if((await getSelectedSounds()).isEmpty) {
          isPlaying = false;
        }
      }

      return true;
    }

    return false;
  }

}