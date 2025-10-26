# AI Integration

## Overview
The app uses Google Gemini API (via `google_generative_ai` package) for AI-powered features.

## Service Location
`lib/services/ai_service.dart`

## Configuration
- API Key stored in `.env` file: `GEMINI_API_KEY`
- Model used: `gemini-1.5-flash` (fast, efficient model)
- Loaded via `flutter_dotenv` package

## AIService Class

### Key Methods

#### 1. analyzeImage(XFile imageFile)
Analyzes images to extract text content and generate summaries.

**Purpose**: Process screenshots, photos, documents
**Returns**: `Map<String, dynamic>` with:
- `summary`: AI-generated description of image content
- `text`: Extracted text (OCR)
- `tags`: Suggested tags
- `category`: Content category

**Use cases**:
- Screenshot OCR
- Document scanning
- Image content understanding

#### 2. suggestTags(String title, String? content)
Generates relevant tag suggestions based on note content.

**Returns**: `List<String>` of suggested tags
**Input**: Note title and optional content
**Max tags**: 5
**Behavior**: Returns JSON array of tag strings

**Use cases**:
- Auto-tagging new notes
- Tag recommendations during editing

#### 3. findRelatedNotes(String noteContent, List<Map<String, dynamic>> allNotes)
Identifies semantically related notes using AI analysis.

**Returns**: `List<String>` of related note IDs
**Input**: Current note content + all existing notes metadata
**Behavior**: AI analyzes semantic similarity and returns matching note IDs

**Use cases**:
- "Related Notes" feature
- Note discovery
- Building knowledge graph

#### 4. naturalLanguageSearch(String query, List<Map<String, dynamic>> notes)
Enables searching notes using natural language queries.

**Examples**:
- "Notes about project meetings last week"
- "All ideas related to app design"
- "Tasks I marked as important"

**Returns**: `List<String>` of matching note IDs
**Behavior**: AI interprets intent and matches against note metadata

#### 5. transcribeAudio(XFile audioFile)
Converts audio recordings to text.

**Returns**: `Map<String, dynamic>` with:
- `transcription`: Text transcription
- `summary`: Brief summary of audio content (optional)

**Supported formats**: Determined by `_getMimeType()` helper
**Use cases**: Voice notes, audio note capture

## Implementation Details

### Response Parsing
- All methods request JSON-formatted responses from Gemini
- Helper methods for parsing:
  - `_extractJsonFromResponse()`: Extract JSON from markdown code blocks
  - `_parseJsonResponse()`: Parse JSON objects
  - `_parseJsonList()`: Parse JSON arrays
  - `_extractSummary()`, `_extractTags()`, `_extractCategory()`, `_extractText()`: Field extractors

### Content Truncation
- `_truncateContent()`: Limits content length to avoid token limits
- Max chars: 3000 (configurable)
- Important for large notes/documents

### Error Handling
- Methods should handle API errors gracefully
- Check for null/empty responses
- Provide fallback behavior in UI layer

## Provider Integration

### AIProvider Location
`lib/providers/ai_provider.dart`

The AI service is exposed via Riverpod provider for dependency injection:
```dart
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});
```

### Usage in Presentation Layer
```dart
final aiService = ref.read(aiServiceProvider);
final tags = await aiService.suggestTags(title, content);
```

## Best Practices

1. **Rate Limiting**: Be mindful of API quotas and costs
2. **Caching**: Cache AI responses when appropriate (e.g., image analysis results)
3. **Loading States**: Always show loading indicators during AI operations
4. **Error States**: Handle API failures gracefully with user-friendly messages
5. **Offline Handling**: AI features require internet; provide offline fallbacks
6. **Privacy**: Be transparent about what data is sent to AI service

## Future Enhancements

Potential AI features from requirements not yet implemented:
- Task/date recognition from notes
- Automatic reminder creation
- Email parsing and organization
- Wiki-style backlinking suggestions
- Smart folder recommendations
