# zenith_app Summary
Zenith is a daily productivity application designed to seamlessly integrate a calendar view with a synchronized to-do list. The core objective is to allow users to visually manage their daily tasks by tying specific action items directly to dates, minimizing cognitive load and improving scheduling efficiency.

#Technology Stack :

Frontend Framework: Flutter (Dart)

Target Platforms: iOS, Android, Web

Development Environment: Firebase Studio (Cloud-based VS Code environment)

Version Control: Git & GitHub (zenith_app repository)

Planned Backend: Python (FastAPI/SQLite) or BaaS (Firebase/Supabase)





#Current Codebase Architecture (v1.0 Prototype) :

The current implementation acts as a lightweight, in-memory prototype contained within a single main.dart file.

Component Breakdown

ZenithApp (Root Widget):
 Initializes the application using MaterialApp.
 Applies a dark mode theme (0xFF121212 background, Deep Purple accents) for a modern aesthetic.
 
Task (Data Model):
 A class structure defining a task's properties: id (String), title (String), and isCompleted (Boolean).
 
 ZenithDashboard (Stateful Widget):
  Serves as the main interactive screen.
  State Management: Uses a Dart Map<DateTime, List<Task>> to store tasks in the device's temporary memory (RAM). Keys are normalized dates (stripping time metadata to avoid timezone mismatch errors).
  Calendar Integration: Utilizes Flutter's built-in CalendarDatePicker to update the active _selectedDate state.
  Interactive UI: Implements a ListView.builder combined with Dismissible widgets to allow for swipe-to-delete functionality and dynamic list rendering.
