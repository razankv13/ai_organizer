# OCR Process Edge Function

Server-side OCR (Optical Character Recognition) processing using Google Gemini API.

## Overview

This Supabase Edge Function provides server-side image text extraction using Google's Gemini 1.5 Flash model. It processes images and returns:

- **Extracted Text**: Full OCR text from the image
- **Summary**: AI-generated 2-3 sentence summary of image content
- **Tags**: 3-5 relevant tags for categorization
- **Category**: Primary category classification

## Benefits of Server-Side Processing

✅ **Security**: API keys never exposed to client applications
✅ **Consistency**: Same processing across all platforms (iOS, Android, Web)
✅ **Batch Processing**: Process multiple images efficiently
✅ **Cost Management**: Centralized monitoring and rate limiting
✅ **Storage Integration**: Direct access to Supabase Storage
✅ **Metadata Updates**: Automatically update attachment metadata

## Prerequisites

1. **Google Gemini API Key**: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. **Supabase Project**: Active Supabase project with Storage bucket configured
3. **Deno**: For local testing (optional)

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
supabase functions deploy ocr-process
```

### Verify Deployment

```bash
supabase functions list
```

## API Usage

### Endpoint

```
POST https://your-project.supabase.co/functions/v1/ocr-process
```

### Authentication

Include Supabase `anon` key in headers:

```
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
```

### Request Format

**Option 1: Base64 Image**

```json
{
  "imageBase64": "base64_encoded_image_data",
  "mimeType": "image/jpeg",
  "attachmentId": "optional_attachment_id_to_update"
}
```

**Option 2: Storage Path**

```json
{
  "storagePath": "user_id/attachments/image.jpg",
  "attachmentId": "optional_attachment_id_to_update"
}
```

### Response Format

```json
{
  "success": true,
  "text": "Extracted text from the image...",
  "summary": "This image shows a receipt from Coffee Shop...",
  "tags": ["receipt", "coffee", "expense", "2024", "restaurant"],
  "category": "document"
}
```

### Error Response

```json
{
  "success": false,
  "text": "",
  "summary": "",
  "tags": [],
  "category": "error",
  "error": "Error message here"
}
```

## Usage Examples

### Flutter/Dart Client

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> processImageOCR(String imagePath) async {
  final supabase = Supabase.instance.client;

  // Read image file
  final file = File(imagePath);
  final bytes = await file.readAsBytes();
  final base64Image = base64Encode(bytes);

  // Call edge function
  final response = await supabase.functions.invoke(
    'ocr-process',
    body: {
      'imageBase64': base64Image,
      'mimeType': 'image/jpeg',
    },
  );

  return response.data as Map<String, dynamic>;
}

// With storage path
Future<Map<String, dynamic>> processStoredImage(
  String storagePath,
  String attachmentId,
) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.functions.invoke(
    'ocr-process',
    body: {
      'storagePath': storagePath,
      'attachmentId': attachmentId,
    },
  );

  return response.data as Map<String, dynamic>;
}
```

### cURL

```bash
curl -X POST \
  https://your-project.supabase.co/functions/v1/ocr-process \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "storagePath": "user123/attachments/receipt.jpg",
    "attachmentId": "attachment-uuid"
  }'
```

## Features

### Automatic Metadata Updates

When `attachmentId` is provided, the function automatically updates the attachment's metadata field with OCR results:

```json
{
  "extractedText": "Full OCR text...",
  "summary": "Brief summary...",
  "tags": ["tag1", "tag2"],
  "category": "document",
  "processedAt": "2024-01-15T10:30:00Z"
}
```

### Supported Image Formats

- JPEG (`.jpg`, `.jpeg`)
- PNG (`.png`)
- WebP (`.webp`)
- GIF (`.gif`)

### OCR Accuracy

The function uses Gemini 1.5 Flash with:
- **Temperature**: 0.2 (lower = more consistent)
- **Max Tokens**: 2048 (supports lengthy documents)
- **Focus**: High-accuracy text extraction

## Best Practices

1. **Image Quality**: Higher resolution images = better OCR accuracy
2. **File Size**: Keep images under 4MB for optimal performance
3. **Batch Processing**: Process multiple images sequentially with delays
4. **Error Handling**: Always check `success` field in response
5. **Caching**: Cache results to avoid redundant API calls

## Troubleshooting

### "Missing required environment variable: GEMINI_API_KEY"

Set the Gemini API key:
```bash
supabase secrets set GEMINI_API_KEY=your_key
```

### "Failed to fetch image from storage"

Check that:
- Storage path is correct
- File exists in the `attachments` bucket
- Bucket permissions are configured

### "Gemini API error: 429"

Rate limit exceeded. Implement:
- Exponential backoff
- Request queuing
- Caching of results

## Local Development

### Start Local Supabase

```bash
supabase start
```

### Set Local Environment Variables

Create `.env` file in `supabase/functions/.env`:

```bash
GEMINI_API_KEY=your_api_key
SUPABASE_URL=http://localhost:54321
SUPABASE_SERVICE_ROLE_KEY=your_local_service_key
```

### Run Function Locally

```bash
supabase functions serve ocr-process --env-file supabase/functions/.env
```

### Test Locally

```bash
curl -X POST http://localhost:54321/functions/v1/ocr-process \
  -H "Authorization: Bearer YOUR_LOCAL_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d @test-payload.json
```

## Monitoring

### View Logs

```bash
supabase functions logs ocr-process
```

### View Real-time Logs

```bash
supabase functions logs ocr-process --tail
```

## Cost Considerations

### Gemini API Pricing

- Free tier: 15 requests per minute
- Check current pricing: [Google AI Pricing](https://ai.google.dev/pricing)

### Optimization Tips

1. Cache OCR results in database
2. Process during off-peak hours
3. Batch similar requests
4. Consider image preprocessing (compression, optimization)

## Related Functions

- [`ai-tag`](../ai-tag/README.md): AI-powered tag generation
- [`email-to-note`](../email-to-note/README.md): Email parsing and note creation

## Support

For issues or questions:
- Check Supabase logs: `supabase functions logs ocr-process`
- Review Gemini API status: [Google AI Status](https://status.cloud.google.com/)
- Open issue in project repository
