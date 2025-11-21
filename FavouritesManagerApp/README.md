# Favorites Manager App

iOS приложение для управления избранными элементами в категориях: Movies, Music, Books, Courses.

## Структура проекта

```
FavouritesManagerApp/
├── Models/
│   ├── Movie.swift
│   ├── Song.swift
│   ├── Book.swift
│   └── Course.swift
├── Views/
│   └── FavoriteTableViewCell.swift
├── ViewControllers/
│   ├── MoviesViewController.swift
│   ├── MusicViewController.swift
│   ├── BooksViewController.swift
│   ├── CoursesViewController.swift
│   └── DetailViewController.swift
├── AppDelegate.swift
└── Main.storyboard
```

## Особенности

- ✅ **4 категории** с Tab Bar Controller
- ✅ **Каждая категория** содержит минимум 12 элементов
- ✅ **Кастомная ячейка** с изображением и заголовком
- ✅ **Detail View Controller** с полной информацией
- ✅ **SF Symbols** для иконок
- ✅ **Auto Layout** с правильными constraints
- ✅ **Light/Dark Mode** поддержка
- ✅ **Настроенные цвета** Tab Bar (systemIndigo)

## Данные

### Movies (12 фильмов)
- Inception, The Dark Knight, Interstellar, The Matrix, и др.

### Music (12 песен)
- Bohemian Rhapsody, Stairway to Heaven, Hotel California, и др.

### Books (12 книг)
- 1984, To Kill a Mockingbird, The Great Gatsby, и др.

### Courses (12 курсов)
- iOS Development, Advanced Algorithms, Machine Learning, и др.

## Настройка Storyboard

⚠️ **ВАЖНО**: После открытия проекта в Xcode необходимо настроить Storyboard согласно инструкции в файле `STORYBOARD_SETUP.md`

Основные шаги:
1. Создать Tab Bar Controller с 4 вкладками
2. Для каждой вкладки создать Navigation Controller
3. Добавить Table View в каждый View Controller
4. Настроить Prototype Cell с IBOutlets
5. Создать Detail View Controller
6. Подключить все IBOutlets

## Использование

1. Открой проект в Xcode
2. Настройте Storyboard (см. `STORYBOARD_SETUP.md`)
3. Запустите проект (Cmd+R)
4. Переключайтесь между вкладками
5. Тапните на элемент для просмотра деталей

## Технические детали

- **Минимальная версия iOS**: 15.0
- **Язык**: Swift
- **UI Framework**: UIKit + Storyboard
- **Архитектура**: MVC

## Цветовая схема

- Tab Bar Tint: `systemIndigo`
- Navigation Bar: Standard appearance с поддержкой Dark Mode
- Background: `systemBackground` (автоматическая поддержка Dark Mode)
- Text: `label` и `secondaryLabel` (автоматическая поддержка Dark Mode)

## Дополнительные возможности (для будущего расширения)

- Search bar в tableHeaderView
- Swipe actions (delete / favorite)
- Star rating
- Empty state view
- Сохранение в Core Data или UserDefaults
- Pull-to-refresh

