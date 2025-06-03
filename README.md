A Flutter-based mobile app designed to help parents, students, and school staff track the school bus in real time. This project implements role-based dashboards with API integration for live data.

Project Details
App Name: Smart Track – School Bus Tracking System

Roles: Admin, Assistant/Parent, Student

Core Features:

Role-based login and dashboards

Real-time bus and student tracking (via API)

Refresh and retry mechanisms

Logout and session management

Tech Stack: Flutter, BLoC, Dio for API calls

How to Setup and Run
Clone the repository:
git clone https://github.com/uddith18/smartbustracking.git
cd smart-track
Install dependencies:


flutter pub get
Run the app:

Edit
flutter run
Make sure you have a connected device or emulator running.

API Integration
The app fetches dashboard data from a REST API.

On login, the app receives a session token (or similar).

This token is required for all API calls to fetch protected data like dashboard info.

Known Issue: Session Expired
While fetching dashboard data, sometimes the API returns a response indicating the session is expired, such as:

{
  "message": "Session expired"
}
What happens in the app?
When this response is received, the dashboard fails to load data correctly.

Currently, the app shows an error message:
"Session expired. Please log in again."

The user needs to log out and log in again to refresh the session token.

Why does this happen?
The session token stored on the device has expired or is invalid.

The backend requires re-authentication to issue a new session token.

How to Fix or Handle This
The app listens for this specific API response.

Upon detecting "Session expired", it:

Shows a clear error message to the user.

Logs the user out automatically (or asks them to do so).



