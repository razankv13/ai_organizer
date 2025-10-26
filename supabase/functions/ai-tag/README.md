# AI Tag Generation Edge Function

Server-side intelligent tag generation using Google Gemini API.

## Overview

This Supabase Edge Function provides AI-powered tag generation for notes using Google's Gemini 1.5 Flash model. It analyzes note content and generates relevant, contextual tags for better organization and discoverability.

## Features

✅ **Single Note Tagging**: Generate tags for individual notes
✅ **Batch Processing**: Process multiple notes efficiently
✅ **Auto-Linking**: Automatically create and link tags to notes
✅ **Smart Deduplication**: Reuses existing tags when appropriate
✅ **Use Count Tracking**: Updates tag usage statistics
✅ **Consistent Quality**: AI-generated tags are relevant and specific

## Benefits of Server-Side Processing

✅ **Security**: API keys never exposed to client applications
✅ **Consistency**: Same tagging logic across all platforms
✅ **Efficiency**: Batch processing reduces API calls
✅ **Database Integration**: Direct tag creation and linking
✅ **Cost Management**: Centralized monitoring and rate limiting

## Prerequisites

1. **Google Gemini API Key**: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. **Supabase Project**: Active Supabase project with proper database schema
3. **Deno**: For local testing (optional)

## Database Requirements

Required tables:
- `notes`: Notes table with `id`, `title`, `content`
- `tags`: Tags table with `id`, `name`, `use_count`, `color`, `description`
- `note_tags`: Junction table with `note_id`, `tag_id`

## Environment Variables

Required environment variables:

```bash
GEMINI_API_KEY=your_gemini_api_key_here
SUPABASE_URL=your_supabase_project_url
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

## Deployment

### Set Environment Variables

```bash
# Set Gemini API key
supabase secrets set GEMINI_API_KEY=your_api_key_here

# SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are automatically provided
```

### Deploy Function

```bash
supabase functions deploy ai-tag
```

### Verify Deployment

```bash
supabase functions list
```

## API Usage

### Endpoint

```
POST https://your-project.supabase.co/functions/v1/ai-tag
```

### Authentication

Include Supabase `anon` key in headers:

```
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
```

## Request Formats

### Single Note Tagging

**Without Auto-Link** (returns tags only):

```json
{
  "noteId": "note-uuid",
  "title": "Meeting Notes - Q4 Planning",
  "content": "Discussed marketing strategy and budget allocation...",
  "maxTags": 5
}
```

**With Auto-Link** (creates and links tags):

```json
{
  "noteId": "note-uuid",
  "title": "Meeting Notes - Q4 Planning",
  "content": "Discussed marketing strategy and budget allocation...",
  "maxTags": 5,
  "autoLink": true,
  "userId": "user-uuid"
}
```

### Batch Processing

Process multiple notes at once:

```json
{
  "notes": [
    {
      "noteId": "note-uuid-1",
      "title": "Project Kickoff",
      "content": "Initial planning meeting..."
    },
    {
      "noteId": "note-uuid-2",
      "title": "Design Review",
      "content": "UI/UX feedback session..."
    }
  ],
  "maxTags": 5,
  "autoLink": true,
  "userId": "user-uuid"
}
```

## Response Format

### Success Response

```json
{
  "success": true,
  "results": [
    {
      "noteId": "note-uuid",
      "tags": ["meeting", "planning", "q4", "marketing", "strategy"]
    }
  ]
}
```

### Error Response

```json
{
  "success": false,
  "results": [],
  "error": "Error message here"
}
```

## Usage Examples

### Flutter/Dart Client

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

// Single note tagging
Future<List<String>> generateTags({
  required String noteId,
  required String title,
  required String content,
}) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.functions.invoke(
    'ai-tag',
    body: {
      'noteId': noteId,
      'title': title,
      'content': content,
      'maxTags': 5,
    },
  );

  final data = response.data as Map<String, dynamic>;
  if (data['success'] == true) {
    final results = data['results'] as List;
    if (results.isNotEmpty) {
      return List<String>.from(results[0]['tags']);
    }
  }

  return [];
}

// Single note with auto-linking
Future<List<String>> generateAndLinkTags({
  required String noteId,
  required String title,
  required String content,
  required String userId,
}) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.functions.invoke(
    'ai-tag',
    body: {
      'noteId': noteId,
      'title': title,
      'content': content,
      'maxTags': 5,
      'autoLink': true,
      'userId': userId,
    },
  );

  final data = response.data as Map<String, dynamic>;
  if (data['success'] == true) {
    final results = data['results'] as List;
    if (results.isNotEmpty) {
      return List<String>.from(results[0]['tags']);
    }
  }

  return [];
}

// Batch processing
Future<Map<String, List<String>>> batchGenerateTags({
  required List<Map<String, dynamic>> notes,
  required String userId,
}) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.functions.invoke(
    'ai-tag',
    body: {
      'notes': notes,
      'maxTags': 5,
      'autoLink': true,
      'userId': userId,
    },
  );

  final data = response.data as Map<String, dynamic>;
  final results = <String, List<String>>{};

  if (data['success'] == true) {
    final resultsList = data['results'] as List;
    for (final result in resultsList) {
      final noteId = result['noteId'] as String;
      final tags = List<String>.from(result['tags']);
      results[noteId] = tags;
    }
  }

  return results;
}
```

### cURL Examples

**Single Note:**

```bash
curl -X POST \
  https://your-project.supabase.co/functions/v1/ai-tag \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "noteId": "note-123",
    "title": "Project Meeting",
    "content": "Discussed timeline and deliverables",
    "maxTags": 5
  }'
```

**Batch Processing:**

```bash
curl -X POST \
  https://your-project.supabase.co/functions/v1/ai-tag \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "notes": [
      {
        "noteId": "note-1",
        "title": "Meeting 1",
        "content": "Content here..."
      },
      {
        "noteId": "note-2",
        "title": "Meeting 2",
        "content": "More content..."
      }
    ],
    "maxTags": 5,
    "autoLink": true,
    "userId": "user-123"
  }'
```

## Features Explained

### Auto-Link Mode

When `autoLink: true` and `userId` are provided, the function:

1. Generates tags using AI
2. Checks if each tag exists in database
3. Creates new tags if they don't exist
4. Links tags to the note in `note_tags` table
5. Updates `use_count` for existing tags

### Batch Processing

- Processes notes in batches of 5 to respect rate limits
- Adds 1-second delay between batches
- Parallel processing within batches for efficiency
- Returns all results together

### Tag Quality

Tags are generated with:
- **Relevance**: Based on note title and content
- **Specificity**: Avoids generic terms like "note" or "text"
- **Consistency**: Lowercase for uniformity
- **Brevity**: 1-2 words per tag
- **Purpose**: Focuses on categorization and search

## Best Practices

### When to Use

✅ **Creating New Notes**: Generate initial tags automatically
✅ **Bulk Tagging**: Tag multiple untagged notes at once
✅ **Re-tagging**: Update tags based on edited content
✅ **Organization**: Improve note discoverability

### Performance Tips

1. **Batch Processing**: Use batch mode for multiple notes
2. **Caching**: Cache results for unchanged notes
3. **Rate Limiting**: Add delays for large batches
4. **Content Length**: Longer content = better tag quality

### Error Handling

```dart
try {
  final tags = await generateTags(
    noteId: noteId,
    title: title,
    content: content,
  );

  if (tags.isEmpty) {
    // Fallback: Extract keywords from title
    tags.addAll(extractKeywordsFromTitle(title));
  }
} catch (e) {
  // Handle error gracefully
  print('Tag generation failed: $e');
}
```

## Troubleshooting

### "Missing required environment variable: GEMINI_API_KEY"

Set the API key:
```bash
supabase secrets set GEMINI_API_KEY=your_key
```

### "userId is required when autoLink is true"

Include `userId` in the request when using auto-link:
```json
{
  "autoLink": true,
  "userId": "user-uuid"
}
```

### Empty Tags Array

Possible causes:
- Content too short or generic
- API rate limit exceeded
- Gemini API error

Check logs:
```bash
supabase functions logs ai-tag
```

## Local Development

### Start Local Supabase

```bash
supabase start
```

### Set Environment Variables

Create `supabase/functions/.env`:

```bash
GEMINI_API_KEY=your_api_key
SUPABASE_URL=http://localhost:54321
SUPABASE_SERVICE_ROLE_KEY=your_local_service_key
```

### Run Function Locally

```bash
supabase functions serve ai-tag --env-file supabase/functions/.env
```

### Test Locally

```bash
curl -X POST http://localhost:54321/functions/v1/ai-tag \
  -H "Authorization: Bearer YOUR_LOCAL_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "noteId": "test-note",
    "title": "Test Note",
    "content": "This is a test note for tag generation"
  }'
```

## Monitoring

### View Logs

```bash
supabase functions logs ai-tag
```

### View Real-time Logs

```bash
supabase functions logs ai-tag --tail
```

### Monitor Performance

Track:
- Average response time
- Success rate
- Tags generated per note
- API usage and costs

## Cost Considerations

### Gemini API Pricing

- Free tier: 15 requests per minute
- Check pricing: [Google AI Pricing](https://ai.google.dev/pricing)

### Optimization Strategies

1. **Cache Results**: Store generated tags to avoid regeneration
2. **Batch Processing**: Process multiple notes in one session
3. **Content Truncation**: Limit content length to 3000 characters
4. **Conditional Generation**: Only generate tags for new/edited notes

## Related Functions

- [`ocr-process`](../ocr-process/README.md): OCR text extraction
- [`email-to-note`](../email-to-note/README.md): Email parsing with auto-tagging

## Support

For issues or questions:
- Check logs: `supabase functions logs ai-tag`
- Review API status: [Google AI Status](https://status.cloud.google.com/)
- Open issue in project repository
