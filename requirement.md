# AI-Powered Organizer App

## Overview

Build a cross-platform mobile organizer app using Flutter (Riverpod, GoRouter, Freezed, Google Fonts) and Supabase for backend (authentication, storage, database, edge functions). The app allows users to quickly capture and intelligently organize screenshots, web content, notes, emails, and various digital assets.

## Core Features

### Unified Content Capture

* Quick add notes, screenshots, images, PDFs, links, and emails.
* OCR text recognition in images/screenshots.
* Email forwarding feature (unique user-specific email address).
* Web clipping via share extension from browsers.

### Intelligent AI Organization

* Auto-suggest tags and folders using AI analysis (on-device/cloud hybrid).
* "Related Notes" suggestions through semantic linking.
* AI-based task/date recognition and reminders creation.

### Powerful Search & Retrieval

* Robust search (full-text, OCR-based search, tag filtering).
* Natural-language search queries support ("Notes about X last week").

### Flexible Organization

* Folder/Notebook hierarchy.
* Tagging system with easy and intuitive tagging interface.
* Backlinking notes (wiki-style linking).
* Task lists and reminders integrated within notes.
* Favorites/pinning notes and easy batch management.

### Integrations

* Google Calendar two-way sync (events and reminders).
* Gmail integration for email importing.
* Dropbox/Google Drive for file attachments/import.

### Offline Support

* Full offline access to notes, editing capabilities, and sync upon reconnection.
* Background sync with conflict resolution ("last write wins" initially).

### Security & Privacy

* Supabase authentication (email/password, OAuth).
* Encryption in transit and at rest.
* Optional user-controlled local exports.

## Technical Stack

### Frontend (Flutter)

* **State Management**: Riverpod.
* **Navigation**: GoRouter.
* **Data Models**: Freezed for immutability.
* **Typography**: Google Fonts.
* **Local Storage**: SQLite via Drift/Moor.
* **Image/Text OCR**: On-device/cloud hybrid models.

### Backend (Supabase)

* **Database**: PostgreSQL schema with tables for notes, tags, attachments, tasks, notebooks.
* **Auth**: Supabase Auth (email/password, OAuth).
* **Storage**: Supabase storage for media/files.
* **Functions**: Edge functions for OCR processing, AI tagging, and email parsing.

## Non-Functional Requirements

* **Performance**: Fast load (<2 sec), smooth scrolling/search.
* **Reliability**: Offline-first architecture ensuring robust sync.
* **Scalability**: Support large-scale user data.
* **Privacy**: No data mining, user privacy first.

## Initial Development Steps

1. Setup Flutter project (Riverpod, GoRouter, Freezed).
2. Configure Supabase instance (Auth, DB schema, Storage).
3. Implement basic note capture and tagging.
4. Integrate OCR for screenshots/images.
5. Implement email-forwarding via Edge functions.
6. Create Calendar and Email integrations.
7. Develop offline-first sync mechanism.
8. Ensure robust search and retrieval system.

Use this document as a foundational blueprint to guide development through Cursor.
