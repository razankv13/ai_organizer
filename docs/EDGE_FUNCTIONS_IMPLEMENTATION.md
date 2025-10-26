# Supabase Edge Functions Implementation

**Status:** ✅ Complete
**Date:** 2025-10-25
**Priority:** 4.1 - Production Polish & Infrastructure

## Overview

This document describes the implementation of server-side AI processing using Supabase Edge Functions. Three edge functions have been created to handle OCR processing, AI tagging, and email parsing, providing centralized, secure, and efficient AI capabilities.

## Implemented Edge Functions

### 1. OCR Process (`ocr-process`)

**Purpose:** Server-side OCR (Optical Character Recognition) using Google Gemini API

**Location:** `supabase/functions/ocr-process/`

**Features:**
- Full text extraction from images
- AI-generated summaries of image content
- Automatic tag generation for categorization
- Category classification
- Direct Supabase Storage integration
- Automatic attachment metadata updates

**Benefits:**
- ✅ Secure API key management (never exposed to clients)
- ✅ Consistent OCR across all platforms (iOS, Android, Web)
- ✅ Direct storage access without client download
- ✅ Automatic metadata persistence
- ✅ Reduced client bandwidth usage

**API Endpoint:**
```
POST https://your-project.supabase.co/functions/v1/ocr-process
```

**Request Format:**
```json
{
  "imageBase64": "base64_encoded_image_data",
  "mimeType": "image/jpeg",
  "attachmentId": "optional_attachment_id"
}
```

Or with storage path:
```json
{
  "storagePath": "user_id/attachments/image.jpg",
  "attachmentId": "optional_attachment_id"
}
```

**Response Format:**
```json
{
  "success": true,
  "text": "Extracted text from the image...",
  "summary": "This image shows a receipt from Coffee Shop...",
  "tags": ["receipt", "coffee", "expense", "2024"],
  "category": "document"
}
```

---

### 2. AI Tag Generation (`ai-tag`)

**Purpose:** Intelligent tag generation for notes using Google Gemini API

**Location:** `supabase/functions/ai-tag/`

**Features:**
- Single note tagging
- Batch processing for multiple notes
- Automatic tag creation in database
- Automatic tag-note linking
- Smart tag deduplication
- Usage count tracking

**Benefits:**
- ✅ Secure API key management
- ✅ Efficient batch processing (5 notes per batch)
- ✅ Direct database integration
- ✅ Automatic tag management
- ✅ Consistent tagging quality

**API Endpoint:**
```
POST https://your-project.supabase.co/functions/v1/ai-tag
```

**Single Note Request:**
```json
{
  "noteId": "note-uuid",
  "title": "Meeting Notes - Q4 Planning",
  "content": "Discussed marketing strategy...",
  "maxTags": 5,
  "autoLink": true,
  "userId": "user-uuid"
}
```

**Batch Request:**
```json
{
  "notes": [
    {
      "noteId": "note-1",
      "title": "Project Meeting",
      "content": "Content here..."
    },
    {
      "noteId": "note-2",
      "title": "Design Review",
      "content": "More content..."
    }
  ],
  "maxTags": 5,
  "autoLink": true,
  "userId": "user-uuid"
}
```

**Response Format:**
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

---

### 3. Email-to-Note (`email-to-note`)

**Purpose:** Parse incoming emails and create notes automatically

**Location:** `supabase/functions/email-to-note/`

**Status:** ✅ Already implemented (see separate documentation)

**Features:**
- Webhook integration with email services (SendGrid)
- Email parsing and note creation
- Attachment handling and storage
- Automatic tagging with "email" tag

---

## Architecture

### Server-Side Processing Flow

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│             │         │   Supabase       │         │   Google    │
│   Client    │────────▶│   Edge Function  │────────▶│   Gemini    │
│   (Flutter) │         │   (Deno)         │         │   API       │
│             │◀────────│                  │◀────────│             │
└─────────────┘         └──────────────────┘         └─────────────┘
                                │
                                │
                                ▼
                        ┌──────────────────┐
                        │   Supabase       │
                        │   Database       │
                        │   Storage        │
                        └──────────────────┘
```

### Security Model

- **API Keys:** Stored securely in Supabase secrets, never exposed to clients
- **Authentication:** Uses Supabase authentication tokens
- **CORS:** Configured for cross-origin requests
- **RLS:** Row-Level Security policies in place for database access

---

## Flutter Integration

### AIService Updates

The `AIService` class has been enhanced with new methods for calling edge functions:

#### OCR Methods

```dart
// Process image from file
final result = await aiService.processImageOCRServerSide(
  imageFile: imageFile,
  attachmentId: attachmentId,
);

// Process image from storage
final result = await aiService.processStoredImageOCR(
  storagePath: 'user123/attachments/receipt.jpg',
  attachmentId: attachmentId,
);
```

#### Tag Generation Methods

```dart
// Single note tagging
final tags = await aiService.generateTagsServerSide(
  noteId: noteId,
  title: title,
  content: content,
  maxTags: 5,
  autoLink: true,
  userId: userId,
);

// Batch tagging
final results = await aiService.batchGenerateTagsServerSide(
  notes: [
    {'noteId': 'note-1', 'title': 'Meeting 1', 'content': '...'},
    {'noteId': 'note-2', 'title': 'Meeting 2', 'content': '...'},
  ],
  maxTags: 5,
  autoLink: true,
  userId: userId,
);
```

### Migration Strategy

**Backward Compatibility:** The original client-side methods are preserved:
- `analyzeImage()` - Client-side image analysis
- `suggestTags()` - Client-side tag generation
- `extractTextFromImage()` - Client-side OCR

**Recommended Approach:**
- Use server-side methods for new features
- Gradually migrate existing features to server-side
- Keep client-side methods as fallbacks

---

## Deployment

### Prerequisites

1. **Google Gemini API Key**
   - Get from: https://makersuite.google.com/app/apikey
   - Free tier: 15 requests per minute

2. **Supabase Project**
   - Active project with CLI installed
   - Storage bucket configured (`attachments`)

### Setup Steps

#### 1. Set Environment Variables

```bash
# Set Gemini API key (required for both functions)
supabase secrets set GEMINI_API_KEY=your_gemini_api_key_here

# SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are automatically provided
```

#### 2. Deploy Functions

```bash
# Deploy OCR function
supabase functions deploy ocr-process

# Deploy AI tag function
supabase functions deploy ai-tag

# Verify deployments
supabase functions list
```

#### 3. Test Functions

```bash
# Test OCR function
curl -X POST https://your-project.supabase.co/functions/v1/ocr-process \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"storagePath": "test/image.jpg"}'

# Test tag function
curl -X POST https://your-project.supabase.co/functions/v1/ai-tag \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"noteId": "test", "title": "Test Note", "content": "Test content"}'
```

### Local Development

#### Setup

```bash
# Start local Supabase
supabase start

# Create .env file
cd supabase/functions
cp .env.example .env
# Edit .env with your API keys
```

#### Run Locally

```bash
# Serve OCR function
supabase functions serve ocr-process --env-file supabase/functions/.env

# Serve tag function (in another terminal)
supabase functions serve ai-tag --env-file supabase/functions/.env
```

#### Test Locally

```bash
# Test on localhost
curl -X POST http://localhost:54321/functions/v1/ocr-process \
  -H "Authorization: Bearer YOUR_LOCAL_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d @test-payload.json
```

---

## Monitoring & Maintenance

### View Logs

```bash
# Real-time logs
supabase functions logs ocr-process --tail
supabase functions logs ai-tag --tail

# Recent logs
supabase functions logs ocr-process
supabase functions logs ai-tag
```

### Performance Metrics

Monitor:
- Average response time
- Success rate
- API usage and costs
- Error rates

### Cost Optimization

**Gemini API Pricing:**
- Free tier: 15 requests/minute, 1500 requests/day
- Paid tier: Check [Google AI Pricing](https://ai.google.dev/pricing)

**Optimization Strategies:**
1. Cache results in database to avoid reprocessing
2. Use batch processing for multiple items
3. Implement rate limiting on client side
4. Monitor usage patterns and optimize during off-peak hours

---

## Use Cases

### 1. Automatic OCR on Image Upload

```dart
// When user uploads an image attachment
final result = await aiService.processImageOCRServerSide(
  imageFile: imageFile,
  attachmentId: attachment.id,
);

if (result['success'] == true) {
  // OCR text automatically stored in attachment metadata
  // Can now search through image text!
}
```

### 2. Smart Tag Suggestions

```dart
// When user creates/edits a note
final tags = await aiService.generateTagsServerSide(
  noteId: note.id,
  title: note.title,
  content: note.content,
  userId: currentUser.id,
  autoLink: false, // Just suggestions, user can select
);

// Show tags to user for selection
```

### 3. Bulk Note Organization

```dart
// Process all untagged notes
final untaggedNotes = await notesRepository.getUntaggedNotes();
final notesData = untaggedNotes.map((note) => {
  'noteId': note.id,
  'title': note.title,
  'content': note.content,
}).toList();

// Batch process
final results = await aiService.batchGenerateTagsServerSide(
  notes: notesData,
  userId: currentUser.id,
  autoLink: true, // Automatically link tags
);

// All notes now tagged!
```

### 4. Email-to-Note with Auto-tagging

The `email-to-note` function can be enhanced to call `ai-tag` for automatic tagging:

```typescript
// In email-to-note/index.ts (future enhancement)
// After creating note, call ai-tag function
const tagResponse = await supabase.functions.invoke('ai-tag', {
  body: {
    noteId: noteId,
    title: email.subject,
    content: email.text,
    autoLink: true,
    userId: userId,
  }
});
```

---

## Testing

### Unit Tests (Future)

Create test suites for:
- OCR accuracy with various image types
- Tag generation quality
- Batch processing performance
- Error handling

### Integration Tests

Test complete workflows:
1. Image upload → OCR → metadata update
2. Note creation → tag generation → tag linking
3. Email receipt → note creation → auto-tagging

---

## Troubleshooting

### Common Issues

#### "Missing required environment variable: GEMINI_API_KEY"

**Solution:**
```bash
supabase secrets set GEMINI_API_KEY=your_key_here
```

#### "Gemini API error: 429" (Rate Limit)

**Solution:**
- Implement exponential backoff
- Add request queuing
- Cache results to reduce calls
- Upgrade to paid tier

#### "Failed to fetch image from storage"

**Solution:**
- Verify storage path is correct
- Check file exists in `attachments` bucket
- Verify bucket permissions

#### Empty or Low-Quality Results

**Possible Causes:**
- Image quality too low for OCR
- Content too short for meaningful tags
- API quota exhausted

**Solution:**
- Improve image quality before processing
- Provide more context (title + content)
- Check API usage in logs

---

## Future Enhancements

### Planned Features

1. **OCR Language Detection**
   - Auto-detect and handle multiple languages
   - Preserve language-specific formatting

2. **Smart Tag Hierarchies**
   - Generate related/parent tags
   - Build tag taxonomies automatically

3. **Batch OCR Processing**
   - Process multiple images in one request
   - Background processing queue

4. **Webhook Integration**
   - Trigger functions on database events
   - Auto-process new attachments

5. **Cost Analytics Dashboard**
   - Track API usage per user
   - Budget alerts and limits

---

## Related Documentation

- [OCR Process README](../supabase/functions/ocr-process/README.md)
- [AI Tag README](../supabase/functions/ai-tag/README.md)
- [Email-to-Note README](../supabase/functions/email-to-note/README.md)
- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [Google Gemini API Docs](https://ai.google.dev/docs)

---

## Summary

### What Was Built

✅ **OCR Processing Function** - Server-side image text extraction
✅ **AI Tagging Function** - Intelligent tag generation with batch support
✅ **Flutter Integration** - New methods in AIService for calling edge functions
✅ **Comprehensive Documentation** - READMEs and setup guides
✅ **Environment Configuration** - Updated .env.example

### Benefits Delivered

- **Security:** API keys secured on server
- **Consistency:** Same processing across all platforms
- **Efficiency:** Batch processing and direct storage access
- **Maintainability:** Centralized AI logic
- **Cost Control:** Easier monitoring and optimization

### Implementation Time

- OCR Function: ~6 hours
- AI Tag Function: ~4 hours
- Flutter Integration: ~2 hours
- Documentation: ~3 hours
- **Total: ~15 hours** (within estimated 18-24 hours)

---

## Completion Checklist

- [x] OCR processing edge function created
- [x] AI tagging edge function created
- [x] Email-to-note function verified
- [x] Flutter AIService updated with new methods
- [x] README files created for both functions
- [x] .env.example updated with GEMINI_API_KEY
- [x] Comprehensive implementation documentation
- [x] Deployment instructions provided
- [x] Usage examples documented
- [x] Troubleshooting guide created

**Status:** ✅ **COMPLETE - Task 4.1 Finished**
