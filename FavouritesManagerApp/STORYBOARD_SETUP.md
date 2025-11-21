# Инструкция по настройке Storyboard

## 1. Настройка Tab Bar Controller

1. Открой `Main.storyboard` в Xcode
2. Удали существующий View Controller (если есть)
3. Drag → **Tab Bar Controller** на storyboard
4. В Attributes Inspector → установи **Is Initial View Controller**
5. Tab Bar Controller уже создаст 2 вкладки, добавь ещё 2 (всего 4):
   - Выбери Tab Bar Controller
   - В Attributes Inspector → Relationships Segue → найди "view controllers"
   - Добавь ещё 2 View Controller через Editor → Embed In (или просто drag 2 новых View Controller и подключи их)

## 2. Создание Navigation Controllers для каждой вкладки

Для каждой из 4 вкладок:

1. Выбери View Controller
2. **Editor → Embed In → Navigation Controller**
3. Теперь у каждой вкладки должен быть свой Navigation Controller

## 3. Настройка View Controllers

### Для каждой вкладки (Movies, Music, Books, Courses):

1. Выбери View Controller (который теперь внутри Navigation Controller)
2. В Identity Inspector → **Custom Class → Class**: 
   - Первая вкладка: `MoviesViewController`
   - Вторая вкладка: `MusicViewController`
   - Третья вкладка: `BooksViewController`
   - Четвертая вкладка: `CoursesViewController`
3. В Identity Inspector → **Storyboard ID**: 
   - Первая: `MoviesViewController`
   - Вторая: `MusicViewController`
   - Третья: `BooksViewController`
   - Четвертая: `CoursesViewController`

## 4. Добавление Table View в каждый View Controller

Для каждого View Controller (Movies, Music, Books, Courses):

1. Drag → **Table View** на View Controller
2. Установи constraints:
   - Leading = 0
   - Trailing = 0
   - Top = 0 (или Safe Area Top = 0)
   - Bottom = 0 (или Safe Area Bottom = 0)
3. В Attributes Inspector → Table View:
   - Content = Dynamic Prototypes
   - Prototype Cells = 1
4. Подключи IBOutlet:
   - Ctrl+Drag от Table View к соответствующему ViewController (MoviesViewController, MusicViewController, etc.)
   - Назови outlet: `tableView`

## 5. Настройка Prototype Cell

Для каждого Table View:

1. Выбери Prototype Cell
2. В Attributes Inspector:
   - Style = Custom
   - Identifier = `FavoriteCell`
   - Row Height = 80
3. В Prototype Cell добавь элементы:
   - **UIImageView** (60×60):
     - Leading = 16
     - Top = 8
     - Bottom ≥ 8
     - Width = 60
     - Height = 60
     - Content Mode = Aspect Fill
     - Clip to Bounds = YES
   - **UILabel** (title):
     - Leading = ImageView trailing + 12
     - Trailing = -16
     - CenterY aligned с ImageView (или Top = ImageView Top)
     - Number of Lines = 2
     - Lines = 0

4. Подключи IBOutlets к FavoriteTableViewCell:
   - В Identity Inspector → Prototype Cell → Custom Class = `FavoriteTableViewCell`
   - Ctrl+Drag:
     - ImageView → `thumbImageView`
     - Label → `titleLabel`

## 6. Настройка Tab Bar Items

Для каждого Tab Bar Item:

1. Выбери Navigation Controller → Tab Bar Item
2. В Attributes Inspector → Bar Item:
   - Первая вкладка:
     - System Item = None (или кастомный)
     - Title = "Movies"
     - Image = `film.fill` (SF Symbol)
   - Вторая вкладка:
     - Title = "Music"
     - Image = `music.note` (SF Symbol)
   - Третья вкладка:
     - Title = "Books"
     - Image = `book.fill` (SF Symbol)
   - Четвертая вкладка:
     - Title = "Courses"
     - Image = `book.closed.fill` или `graduationcap.fill` (SF Symbol)

## 7. Создание Detail View Controller

1. Drag → **View Controller** на storyboard
2. В Identity Inspector:
   - Custom Class → Class = `DetailViewController`
   - Storyboard ID = `DetailViewController`
3. Добавь элементы:
   - **UIImageView** (сверху):
     - Leading = 16
     - Trailing = -16
     - Top = Safe Area Top + 16
     - Aspect Ratio = 16:9 (или фиксированная высота)
     - Content Mode = Aspect Fill
     - Clip to Bounds = YES
   - **UILabel** (title):
     - Leading = 16
     - Trailing = -16
     - Top = ImageView Bottom + 16
     - Number of Lines = 0
     - Font = Bold, 28
   - **UITextView** (description):
     - Leading = 16
     - Trailing = -16
     - Top = Title Bottom + 12
     - Bottom ≤ Review Top - 12
     - Height ≥ 100 (или ограничивай через bottom constraint)
     - Editable = NO
     - Scroll Enabled = YES
   - **UILabel** (review):
     - Leading = 16
     - Trailing = -16
     - Top = Description Bottom + 12
     - Bottom ≤ Safe Area Bottom - 16 (или просто низ экрана)
     - Number of Lines = 0
     - Font = Italic, 15
     - Text Color = Secondary Label Color

4. Подключи IBOutlets к DetailViewController:
   - Ctrl+Drag:
     - ImageView → `imageView`
     - Title Label → `titleLabel`
     - TextView → `descriptionTextView`
     - Review Label → `reviewLabel`

## 8. Проверка Constraints

Для каждой View:
- Убедись, что нет "Ambiguous Layout" warnings
- Проверь Content Hugging Priority и Compression Resistance Priority
- Для Title Label: Vertical Content Hugging = 251 (выше), Compression Resistance = 750
- Для ImageView: фиксированные Width/Height или Aspect Ratio

## 9. Запуск проекта

После настройки Storyboard:
1. Выбери симулятор (например, iPhone 15 Pro)
2. Запусти проект (Cmd+R)
3. Проверь, что все 4 вкладки отображаются
4. Проверь, что таблицы заполнены данными
5. Проверь, что при тапе на элемент открывается Detail View Controller

## Полезные советы

- Используй SF Symbols для иконок (бесплатно, масштабируемо)
- Проверь на разных симуляторах (iPhone SE, iPhone 15 Pro Max)
- Используй Light/Dark Mode для проверки цветов
- Если constraints warning - используй "Update Frames" (Cmd+Alt+=)

