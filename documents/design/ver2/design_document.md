# Design Document

## Overview

The provided code is a Flutter application designed to record and query time-related data. It uses Firebase for data storage and retrieval. The app has four main screens - Record, Query, Report, and Priority, each represented by separate Dart files. The Record screen allows users to input time-related information, the Query screen enables users to search and display records based on various criteria, the Report screen allows users to search for records within a specified date range, and the Priority screen displays records sorted by priority.

## Architecture

- The application follows the Flutter framework for UI development.
- Firebase is integrated for backend services, utilizing the Firestore database.
- The app consists of multiple Dart files, organized into different functionalities such as main, navigation, and screens (record, query, report, and priority).

## Main Dart (main.dart)

- The entry point of the application initializes Firebase and sets up the main application widget.
- MyApp is a stateless widget representing the overall structure of the app.
- The theme is set to dark, and the default home screen is the Navigation widget.

## Navigation Dart (navigation.dart)

- Navigation is a stateful widget that manages the navigation structure of the app.
- The widget includes an app bar, a body displaying different screens based on the selected tab, and a drawer for navigation options.
- The drawer contains options for Record, Query, Report, and Priority screens.
- The state tracks the selected tab and updates the title accordingly.

## Record Screen (screens/record.dart)

- RecordScreen is a stateful widget representing the screen for recording time-related data.
- It includes text input fields for date, time (from and to), task, and tag.
- Validation checks are implemented for input values.
- Records are submitted to Firestore, and a snackbar displays the submission status.

## Query Screen (screens/query.dart)

- QueryScreen is a stateful widget for querying and displaying records.
- It includes a text input field for entering queries.
- Local search functionality is implemented, filtering records based on task, tag, date, and "today."
- Search results are displayed in a scrollable list.

## Report Screen (screens/report.dart)

- ReportScreen is a stateful widget allowing users to search for records within a specified date range.
- It includes text input fields for the start and end dates.
- Records within the specified range are displayed in a scrollable list.

## Priority Screen (screens/priority.dart)

- PriorityScreen is a stateful widget displaying records sorted by priority.
- Records are sorted based on the total time spent on each tag.
- The sorted records are displayed in a scrollable list.

## Key Features

- Firebase integration for data storage.
- Navigation structure with a drawer for easy access to Record, Query, Report, and Priority screens.
- Record screen for inputting time-related data with validation.
- Query screen for searching and displaying records based on various criteria.
- Report screen for searching records within a specified date range.
- Priority screen for displaying records sorted by priority.
