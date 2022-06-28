# welliBe_app
---

WelliBe is a Flutter application for the course: Yearly Project Stage B.
WelliBe is written in Dart, using the Flutter framework.
The app will be used in hospitals, the users are the patients and the doctors.

## Background
---

The demand for this app came to us from a group of doctors that felt that human connection was missing since the outspread of the covid19 virus.
During these hard times, doctors were appreciated more than ever but also had a very hard time because of the quarantines and the high rates of sickness.
They felt that the sows of gratitude from the patients were a big mental help for them to keep doing their jobs and save lives.

## Features
---

### Patients features:
* Scan the QR code of the doctor that attends to them, and add them to their "Treatment history".

* Create a thank you card and send it to doctors from the "Treatment history".

* Read more details about the doctors.

* See a calendar with their appointment information.

* Write notes near every doctor, for personal use such as to remember better what was said in the meeting, etc.

### Doctors features:
* Watch\Edit the details about them that were presented to the patients.

* Read the thank you cards they received.

* Delete unwanted thank you cards.

### Admins features:
* Add a new doctor to the database.

* View all the doctors in the database.

* View all the patients in the database.

## Physical Component
---
Our main feature that allows the use of the app is scanning the QR code of the doctor.
This requires:
* That every doctor registered to the app will get his matching QR code from the admin.
* The QR code must be available to the patients to scan when the doctor attends to them:
  We suggest that the QR code will be supplemented as a small sticker that will be on the doctor's physical card,
  but different hospitals may choose to do it in another way.
  
* The patient's device needs to be equipped with a camera.
  Currently, this requirement is mandatory.

## Testing
---
We run the tests using the command `flutter-tests`.
Each test checks a different part of the authentication and database operations. Such as:
* Edit personal information.
* Create new accounts.
