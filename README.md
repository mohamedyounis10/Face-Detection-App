# Face Detection Flutter App with Python Backend

## Overview
This project involves creating a **Flutter-based mobile app** that communicates with a **Python Flask API** for face detection. The Flutter app allows users to upload images, while the Python backend processes the images using various image processing techniques, such as skin detection, morphological operations, and edge detection. The faces detected in the image are highlighted with bounding boxes and the results are sent back to the Flutter app.

## Technologies Used
- **Flutter**: Used for building the mobile application.
- **Python Flask**: Backend API for face detection.
- **OpenCV**: Image processing library used for detecting and processing faces.
- **NumPy**: Library for array operations in Python.
- **skimage**: Used for image manipulation (like converting RGB to HSV).
- **Canny Edge Detection**: Applied to refine the boundaries of detected faces.

## Features
- **Image Upload**: Users can upload images to the Flask server for processing.
- **Face Detection**: The backend detects faces in the uploaded images using custom image processing techniques.
- **Bounding Box Visualization**: Detected faces are highlighted with bounding boxes.
- **Result Display**: Processed images with detected faces are returned to the Flutter app for visualization.

---

## Workflow

1. **Flutter App**:
    - The Flutter app allows users to pick an image from their gallery.
    - The image is uploaded to the Flask server using an HTTP POST request.
    - The app displays the processed image with detected faces and bounding boxes.

2. **Python Flask API**:
    - The server receives the uploaded image, processes it using OpenCV and other image processing techniques, and detects faces.
    - The processed image with bounding boxes around faces is sent back to the Flutter app for display.

---

## API Endpoints

### `POST /upload`
- **Description**: Upload an image for face detection.
- **Request**: The image file is uploaded via a form field named `file`.
- **Response**: The server returns a processed image with detected faces highlighted with bounding boxes.
  
---

## Installation

### 1. **Set up the Python Flask Backend**

- Ensure you have Python 3.7+ installed on your system.
- Install the necessary dependencies:
  ```bash
  pip install flask opencv-python numpy scikit-image werkzeug
  ```
- Clone the Python Flask repository:
  ```bash
  git clone <Python_Flask_Repo_URL>
  cd <Python_Flask_Repo_Directory>
  ```
- Run the Flask app:
  ```bash
  python app.py
  ```

The Flask server will start running on `http://localhost:5000`.

### 2. **Set up the Flutter Frontend**

- Install Flutter SDK (if not already installed). Follow the instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).
- Clone the Flutter repository:
  ```bash
  git clone <Flutter_Repo_URL>
  cd <Flutter_Repo_Directory>
  ```
- Add the `http` package to the `pubspec.yaml` file:
  ```yaml
  dependencies:
    http: ^0.13.3
  ```
- Run the Flutter app:
  ```bash
  flutter run
  ```

### 3. **Test the Application**
- Open the Flutter app and select an image to upload.
- The app sends the image to the Flask API, which processes it and returns the output image with bounding boxes.
- The processed image will be displayed in the app.

---

## Example

### Image with Detected Faces:
![Processed Image](https://github.com/user-attachments/assets/545a0dc1-314d-4c9f-a2d7-3a7fba409cfc)

---

## Project Structure

- **Backend (Python)**:
  - `app.py`: Flask app containing the face detection logic and API endpoints.
  - `uploads/`: Folder for storing uploaded images.
  
- **Frontend (Flutter)**:
  - `lib/main.dart`: Flutter app source code for interacting with the Flask API.

---

## Limitations
- This system may struggle with images that have **poor lighting** or **occluded faces**.
- The performance might degrade if the **image resolution is too high** or if the **background is too complex**.

---

## Future Enhancements
1. **Real-Time Face Detection**: Integrate real-time face detection using a webcam or live video feed.
2. **Improved Accuracy**: Use machine learning models for more accurate face detection.
3. **Cloud Integration**: Deploy the Flask API to a cloud service for scalable and accessible face detection.
4. **GUI for Backend**: Develop a simple interface for managing uploads and viewing processed images.

---

## License
This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

## Acknowledgments
Thanks to the developers of **OpenCV**, **Flutter**, and **Flask** for making this project possible.

---

### Additional Resources

- For more information, see the [project report](https://drive.google.com/file/d/17QnKxqzXBB2fWX2wN9wzlal0dphwhEFD/view?usp=drive_link).

---
