import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

enum TtsState { playing, paused, stopped }

class ScreenReaderController extends GetxController {
  final FlutterTts _tts = FlutterTts();

  // ── Observables ────────────────────────────────────────────────────────────
  final Rx<TtsState> state = TtsState.stopped.obs;
  final RxDouble speechRate = 0.5.obs;
  final RxDouble pitch = 1.0.obs;
  final RxDouble volume = 1.0.obs;
  final RxString language = 'en-US'.obs;
  final RxString currentText = ''.obs;
  final RxInt currentWordStart = 0.obs;
  final RxInt currentWordEnd = 0.obs;
  final RxList<String> availableLanguages = <String>[].obs;

  // ── Computed helpers ───────────────────────────────────────────────────────
  bool get isPlaying => state.value == TtsState.playing;
  bool get isPaused  => state.value == TtsState.paused;
  bool get isStopped => state.value == TtsState.stopped;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }

  // ── Init ───────────────────────────────────────────────────────────────────
  Future<void> _initTts() async {
    _tts.setStartHandler(() {
      state.value = TtsState.playing;
    });

    _tts.setCompletionHandler(() {
      state.value = TtsState.stopped;
      currentText.value = '';
    });

    _tts.setCancelHandler(() {
      state.value = TtsState.stopped;
    });

    _tts.setPauseHandler(() {
      state.value = TtsState.paused;
    });

    _tts.setContinueHandler(() {
      state.value = TtsState.playing;
    });

    _tts.setErrorHandler((msg) {
      state.value = TtsState.stopped;
    });

    // Word boundary — for live word highlight while reading
    _tts.setProgressHandler((text, start, end, word) {
      currentWordStart.value = start;
      currentWordEnd.value = end;
    });

    await _applySettings();
    await _loadLanguages();
  }

  Future<void> _applySettings() async {
    await _tts.setLanguage(language.value);
    await _tts.setSpeechRate(speechRate.value);
    await _tts.setPitch(pitch.value);
    await _tts.setVolume(volume.value);
  }

  Future<void> _loadLanguages() async {
    final langs = await _tts.getLanguages;
    availableLanguages.assignAll(List<String>.from(langs));
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Speak a given text. Stops any current speech first.
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await stop();
    currentText.value = text;
    await _applySettings();
    await _tts.speak(text);
  }

  /// Pause current speech
  Future<void> pause() async {
    if (isPlaying) await _tts.pause();
  }

  /// Resume paused speech
  Future<void> resume() async {
    if (isPaused) await _tts.speak(currentText.value);
  }

  /// Stop all speech
  Future<void> stop() async {
    await _tts.stop();
    state.value = TtsState.stopped;
    currentText.value = '';
  }

  /// Toggle play / pause
  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else if (isPaused) {
      await resume();
    }
  }

  /// Set speech rate (0.1 – 1.0)
  Future<void> setSpeechRate(double rate) async {
    speechRate.value = rate.clamp(0.1, 1.0);
    await _tts.setSpeechRate(speechRate.value);
  }

  /// Set pitch (0.5 – 2.0)
  Future<void> setPitch(double value) async {
    pitch.value = value.clamp(0.5, 2.0);
    await _tts.setPitch(pitch.value);
  }

  /// Set volume (0.0 – 1.0)
  Future<void> setVolume(double value) async {
    volume.value = value.clamp(0.0, 1.0);
    await _tts.setVolume(volume.value);
  }

  /// Change TTS language
  Future<void> setLanguage(String lang) async {
    language.value = lang;
    await _tts.setLanguage(lang);
  }
}


class BookModel {
  final String id;
  final String title;
  final String author;
  final String genre;
  final double progress;
  final Color coverColor;
  final String status; // 'in_progress' | 'finished' | 'saved'
  final String description;
  final List<BookChapter> chapters;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.progress,
    required this.coverColor,
    required this.status,
    required this.description,
    required this.chapters,
  });
}

class BookChapter {
  final String title;
  final String content;

  const BookChapter({required this.title, required this.content});
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

const List<BookModel> sampleBooks = [
  BookModel(
    id: 'b1',
    title: 'Atomic Habits',
    author: 'James Clear',
    genre: 'Self Help',
    progress: 0.62,
    coverColor: Color(0xFF4CAF82),
    status: 'in_progress',
    description:
    'An easy and proven way to build good habits and break bad ones. Tiny changes, remarkable results.',
    chapters: [
      BookChapter(
        title: 'Chapter 1: The Surprising Power of Atomic Habits',
        content:
        'Changes that seem small and unimportant at first will compound into remarkable results if you stick with them for years. '
            'We all deal with setbacks, but in the long run, the quality of our lives often depends on the quality of our habits. '
            'With the same habits, you will end up with the same results. But with better habits, anything is possible. '
            'The most effective way to change your habits is to focus not on what you want to achieve, but on who you wish to become. '
            'Your identity emerges out of your habits. Every action is a vote for the type of person you wish to become.',
      ),
      BookChapter(
        title: 'Chapter 2: How Your Habits Shape Your Identity',
        content:
        'There are three layers of behavior change: a change in your outcomes, a change in your process, and a change in your identity. '
            'The most effective way to change your habits is to focus not on what you want to achieve, but on who you wish to become. '
            'Good habits can make rational sense, but if they conflict with your identity, you will fail to put them into action. '
            'The real reason habits matter is not because they can get you better results, but because they can change your beliefs about yourself.',
      ),
    ],
  ),
  BookModel(
    id: 'b2',
    title: 'The Psychology of Money',
    author: 'Morgan Housel',
    genre: 'Finance',
    progress: 0.35,
    coverColor: Color(0xFF5B8DEF),
    status: 'in_progress',
    description:
    'Timeless lessons on wealth, greed, and happiness. Doing well with money has a little to do with how smart you are.',
    chapters: [
      BookChapter(
        title: 'Chapter 1: No One is Crazy',
        content:
        'People do some crazy things with money. But no one is crazy. '
            'Here is the thing: people from different generations, raised by different parents who earned different incomes, '
            'grew up in different parts of the world, in different economies, experiencing different job markets, '
            'have different views about money. And those views are shaped by wildly different personal experiences. '
            'Your personal experiences with money make up maybe 0.00000001% of what has happened in the world, '
            'but maybe 80% of how you think the world works.',
      ),
      BookChapter(
        title: 'Chapter 2: Luck and Risk',
        content:
        'Luck and risk are siblings. They are both the reality that every outcome in life is guided by forces other than individual effort. '
            'They are so similar that you can rarely speak of one without also considering the other. '
            'The accidental impact of actions outside of your control can be more consequential than the ones you consciously take. '
            'Be careful who you praise and admire. Be careful who you look down upon and wish to avoid becoming.',
      ),
    ],
  ),
  BookModel(
    id: 'b3',
    title: 'Deep Work',
    author: 'Cal Newport',
    genre: 'Productivity',
    progress: 1.0,
    coverColor: Color(0xFF9B59B6),
    status: 'finished',
    description:
    'Rules for focused success in a distracted world. Deep work is the ability to focus without distraction on cognitively demanding tasks.',
    chapters: [
      BookChapter(
        title: 'Chapter 1: Deep Work is Valuable',
        content:
        'We are in the early throes of a great restructuring. '
            'Two abilities that will prove crucial in the new economy: the ability to quickly master hard things, '
            'and the ability to produce at an elite level in terms of both quality and speed. '
            'Deep work is not some nostalgic affectation of writers and scholars but instead a skill that has great value today. '
            'If you can do it well, you will thrive. The question then becomes: how do we cultivate this skill?',
      ),
    ],
  ),
  BookModel(
    id: 'b4',
    title: 'Sapiens',
    author: 'Yuval Noah Harari',
    genre: 'History',
    progress: 0.0,
    coverColor: Color(0xFFE67E22),
    status: 'saved',
    description:
    'A brief history of humankind. How did our species succeed in the battle for dominance?',
    chapters: [
      BookChapter(
        title: 'Chapter 1: An Animal of No Significance',
        content:
        'About 13.5 billion years ago, matter, energy, time and space came into being in what is known as the Big Bang. '
            'The story of these fundamental features of our universe is called physics. '
            'About 300,000 years after their appearance, matter and energy started to coalesce into complex structures, called atoms, '
            'which then combined into molecules. The story of atoms, molecules and their interactions is called chemistry. '
            'About 3.8 billion years ago, on a planet called Earth, certain molecules combined to form particularly large and intricate structures called organisms. '
            'The story of organisms is called biology.',
      ),
    ],
  ),
  BookModel(
    id: 'b5',
    title: 'Ikigai',
    author: 'Héctor García',
    genre: 'Philosophy',
    progress: 0.78,
    coverColor: Color(0xFF1ABC9C),
    status: 'in_progress',
    description:
    'The Japanese secret to a long and happy life. Finding your reason for being.',
    chapters: [
      BookChapter(
        title: 'Chapter 1: Ikigai — The Art of Staying Young While Growing Old',
        content:
        'Our ikigai is different for all of us, but one thing we have in common is that we are all searching for meaning. '
            'According to the Japanese, everyone has an ikigai. Finding it requires a deep and often lengthy search of self. '
            'Such a search is regarded as being very important, since it is believed that discovery of one\'s ikigai brings satisfaction and meaning to life. '
            'In the western world, finding your purpose or passion has become increasingly popular as a concept in recent years. '
            'But the Japanese have been practicing this for centuries through the concept of ikigai.',
      ),
    ],
  ),
  BookModel(
    id: 'b6',
    title: 'The Alchemist',
    author: 'Paulo Coelho',
    genre: 'Fiction',
    progress: 1.0,
    coverColor: Color(0xFFE74C3C),
    status: 'finished',
    description:
    'A magical story about following your dreams and listening to your heart.',
    chapters: [
      BookChapter(
        title: 'Prologue',
        content:
        'The alchemist picked up a book that someone in the caravan had brought. '
            'Leafing through the pages, he found a story about Narcissus. '
            'The alchemist knew the legend of Narcissus, a youth who knelt daily beside a lake to contemplate his own beauty. '
            'He was so fascinated by himself that, one morning, he fell into the lake and drowned. '
            'At the spot where he fell, a flower was born, which was called the narcissus.',
      ),
    ],
  ),
  BookModel(
    id: 'b7',
    title: 'Zero to One',
    author: 'Peter Thiel',
    genre: 'Business',
    progress: 0.15,
    coverColor: Color(0xFF34495E),
    status: 'in_progress',
    description:
    'Notes on startups, or how to build the future. Every great business is built around a secret that others have missed.',
    chapters: [
      BookChapter(
        title: 'Chapter 1: The Challenge of the Future',
        content:
        'Whenever I interview someone for a job, I like to ask this question: What important truth do very few people agree with you on? '
            'This question sounds easy because it is straightforward. Actually, it is hard to answer. '
            'It is intellectually difficult because the knowledge that everyone is taught in school is by definition agreed upon. '
            'And it is psychologically difficult because anyone trying to answer must say something she knows to be unpopular. '
            'Brilliant thinking is rare, but courage is in even shorter supply than genius.',
      ),
    ],
  ),
];