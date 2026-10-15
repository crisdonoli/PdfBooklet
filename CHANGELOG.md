# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [3.1.6] - Unreleased

### Added
- Created a complete Windows CI build pipeline via GitHub Actions using `cx_Freeze` for standalone `.exe` distribution.
- Added strict structural constraints to GTK/Glade layouts to prevent entry fields from improperly stretching across the UI.
- Added "Delete this page" and "Insert blank page before" entries to the preview context menu.
- Added a "Chapter starts (right page)" option: blank pages are inserted automatically so every listed chapter begins on an odd (recto) reading position.
- Added a preview info box (file, source page, folded order, booklet) to help locate source pages and verify folding.

### Changed
- Migrated core PDF processing engine from legacy `pypdf`/`pdfrw` to `pikepdf`, significantly improving rendering speed and memory utilization.
- Refactored core application structure to decouple GUI code from document processing logic by introducing `DocumentManagerMixin`.
- Completely rewrote the page transformation matrix engine to enforce strict mathematical post-multiplication for reliable scaling, translation, and rotation handling.
- Optimized the preview rendering pipeline by removing synchronous debugging loggers to improve scrolling and configuration responsiveness.
- Right-clicking the preview now selects the page under the cursor before showing the context menu.

### Fixed
- Resolved pervasive page centering regressions that occurred when combining page rotation, custom output scaling, and manual translations.
- Fixed real-time preview synchronization for "Creep adjustment" and global transformations.
- Fixed critical Windows-specific GTK Drag-and-Drop (DnD) crashes triggered by dragging pages while holding modifier keys (Ctrl/Shift).

### Removed
- Pruned obsolete legacy files, unused helper functions, and deprecated third-party dependencies from the codebase.
