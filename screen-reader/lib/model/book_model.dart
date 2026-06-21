import 'package:flutter/material.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String genre;
  final Color coverColor;
  final double progress;
  final String duration;
  final String currentChapter;
  final bool isFavorite;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.coverColor,
    this.progress = 0.0,
    this.duration = '0h 0m',
    this.currentChapter = 'Chapter 1',
    this.isFavorite = false,
  });
}

// Sample Data
final List<BookModel> sampleBooks = [
  BookModel(
    id: '1',
    title: 'Atomic Habits',
    author: 'James Clear',
    genre: 'Non-Fiction',
    coverColor: const Color(0xFF1D9E75),
    progress: 0.60,
    duration: '5h 35m',
    currentChapter: 'Chapter 8',
    isFavorite: true,
  ),
  BookModel(
    id: '2',
    title: 'Deep Work',
    author: 'Cal Newport',
    genre: 'Productivity',
    coverColor: const Color(0xFF185FA5),
    progress: 0.30,
    duration: '6h 12m',
    currentChapter: 'Chapter 3',
  ),
  BookModel(
    id: '3',
    title: 'Ikigai',
    author: 'Francesc Miralles',
    genre: 'Philosophy',
    coverColor: const Color(0xFF534AB7),
    progress: 0.85,
    duration: '3h 48m',
    currentChapter: 'Chapter 11',
    isFavorite: true,
  ),
  BookModel(
    id: '4',
    title: 'The Power of Now',
    author: 'Eckhart Tolle',
    genre: 'Spirituality',
    coverColor: const Color(0xFF993C1D),
    progress: 0.10,
    duration: '7h 22m',
    currentChapter: 'Chapter 1',
  ),
  BookModel(
    id: '5',
    title: 'Think Again',
    author: 'Adam Grant',
    genre: 'Psychology',
    coverColor: const Color(0xFF993556),
    progress: 0.0,
    duration: '6h 55m',
    currentChapter: 'Chapter 1',
  ),
];