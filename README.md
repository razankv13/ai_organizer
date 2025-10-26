# AI Organizer

An AI-powered note organization app built with Flutter and Supabase, featuring advanced AI capabilities using Google's Gemini model.

## Features

- **Authentication**: Email/password and Google OAuth login
- **Note Management**: Create, edit, organize, and sync notes
- **File Attachments**: Add images, documents, and other files to notes
- **Cloud Sync**: Seamless synchronization between devices
- **AI Features**:
  - Image analysis with Gemini (content understanding, summarization)
  - Smart tagging suggestions
  - Related notes recommendations
  - Natural language search

## Setup

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Supabase account
- Google Gemini API key

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/ai_organizer.git
   cd ai_organizer
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Add your Supabase and Gemini API keys:
     ```
     SUPABASE_URL=your_supabase_url_here
     SUPABASE_ANON_KEY=your_supabase_anon_key_here
     GEMINI_API_KEY=your_gemini_api_key_here
     ```

4. Run the app:
   ```
   flutter run
   ```

### Obtaining API Keys

#### Supabase
1. Create an account at [supabase.com](https://supabase.com)
2. Create a new project
3. Get your URL and anon key from the project settings

#### Gemini
1. Go to [Google AI Studio](https://ai.google.dev/)
2. Sign up and create an API key
3. Copy the API key to your `.env` file

## Project Structure

- `lib/config/` - Configuration files and constants
- `lib/core/` - Core utilities, themes, and base components
- `lib/data/` - Data models and repositories
- `lib/presentation/` - UI screens and widgets
- `lib/providers/` - State management with Riverpod
- `lib/routes/` - App navigation with GoRouter
- `lib/services/` - External services integration
- `lib/utils/` - Utility functions

## Technology Stack

- **Frontend**: Flutter with Riverpod
- **Backend**: Supabase (Auth, Storage, Database)
- **AI**: Google Gemini API
- **State Management**: Flutter Riverpod
- **Navigation**: GoRouter
- **Localization**: easy_localization
- **Theme**: adaptive_theme and flex_color_scheme

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
