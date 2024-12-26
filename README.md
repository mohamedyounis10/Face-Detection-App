# Face Detection Flutter App with Python Backend

## Overview
This project implements a face detection system using custom image processing techniques. The goal is to detect faces in images by processing pixel-level data and applying various image manipulation methods. Key techniques include:

- Skin detection in HSV color space.
- Morphological operations (erosion and dilation).
- Edge detection using the Canny algorithm.
- Logical operations (XOR) for refining detected regions.
- Filtering based on dynamic thresholds for aspect ratio and size of the detected regions.

The system processes images to detect faces and highlights them with bounding boxes. Intermediate results such as masks, edges, and histograms of aspect ratios are also visualized for analysis.

---

## Features
- **Pixel-level Face Detection**: Detect faces based on custom processing techniques.
- **Morphological Transformations**: Uses custom kernels for erosion and dilation to refine the skin mask.
- **Edge Detection**: Applies the Canny algorithm to enhance image boundaries.
- **XOR Operation**: Refines detected face regions through XOR logical operations.
- **Geometric Filtering**: Filters regions based on dynamic aspect ratio and size thresholds.
- **Visualization**: Displays intermediate steps such as masks, edges, and histograms of aspect ratios.

---

## Images

### 1. **Mobile App Screen **  

![Mobile App](https://github.com/user-attachments/assets/9060f7d6-44cd-4343-8e1f-17e4b3768b1f)

---

### 2. **Example Outputs**  
After running the face detection script, various intermediate results will be produced. Below are the outputs of the process:

- **Original Image with Detected Faces**:  
  The original image with faces highlighted by bounding boxes.

  ![Original Image with Detected Faces](https://github.com/user-attachments/assets/1e5f2ab8-a063-4690-8f8a-e8e15e91a6f4)

---

## Requirements

To run this project, you'll need Python 3.7 or higher and the following dependencies:

- `numpy`
- `opencv-python`
- `scikit-image`
- `matplotlib`
- `flask`
- `werkzeug`

To install these dependencies, run the following command:

```bash
pip install numpy opencv-python scikit-image matplotlib flask werkzeug
```

---

## How to Run

1. **Run the Python Flask API**:
   The mobile app requires the Python backend (Flask server) to be running. Please follow these steps to start the backend:

   - **Install the necessary Python libraries**:
     ```bash
     pip install flask opencv-python numpy scikit-image werkzeug
     ```

   - **Run the Python Flask server**:
     Navigate to the directory where your `app.py` file is located and run the following command:
     ```bash
     python app.py
     ```
     The Flask server will start on `http://localhost:5000`.

   - **Test the Flask API**:
     Ensure the Flask server is running properly by sending a sample image using a tool like Postman or CURL, or by using the mobile app.

2. **Clone the repository**:
   Clone this project’s repository to your local machine:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

3. **Set the image path**:
   Replace the image path in the code with the path to the image you want to process. Update the variable `imagepath` in the script:
   ```python
   imagepath = "./images/sample_image.webp"
   ```
   Ensure that the `images` folder contains your input images.

4. **Run the Python script**:  
   Run the Python script that processes the image:
   ```bash
   python face_detection.py
   ```

5. **View the results**:  
   After running the script, the following outputs will be displayed:
   - The original image with bounding boxes around detected faces.
   - A skin detection mask.
   - Eroded and dilated masks.
   - Canny edge detection result.
   - Refined face detection after XOR operation.
   - Histograms of aspect ratios of the detected regions.

---

## Modifications

### Dropping Static Dependence

In the previous version of the code, faces were filtered based on a **static threshold** for the aspect ratio. This was replaced with **dynamic thresholds**, which are calculated based on the **band statistics** of the detected regions' aspect ratios. The updated logic ensures more adaptive and flexible filtering of detected faces.

Here’s the updated Python code for dynamic filtering:

```python
mean_aspect_ratio = np.mean(hist_average_ratio)
std_aspect_ratio = np.std(hist_average_ratio)
min_band = mean_aspect_ratio - std_aspect_ratio
max_band = mean_aspect_ratio + std_aspect_ratio

for i in range(1, num_labels):
    x, y, w, h, area = stats[i, cv2.CC_STAT_LEFT], stats[i, cv2.CC_STAT_TOP], stats[i, cv2.CC_STAT_WIDTH], stats[i, cv2.CC_STAT_HEIGHT], stats[i, cv2.CC_STAT_AREA]
    aspect_ratio = w / float(h)

    if (min_band < aspect_ratio < max_band and w > 25 and h > 25 and area > 1000):
        filtered_faces.append((x, y, w, h))
```

This change allows for **better dynamic filtering** of detected regions based on their geometric properties, improving the accuracy of the face detection.

### Running Python Backend First

Before running the mobile app, you **must start the Python Flask backend** to ensure the API is available for the Flutter app to interact with. 

#### Steps to Run the Python Flask API:

1. **Install the necessary Python libraries**:
   Make sure you have Python 3.7 or higher, and install the dependencies:
   ```bash
   pip install flask opencv-python numpy scikit-image werkzeug
   ```

2. **Run the Python Flask server**:
   Navigate to the directory where your `app.py` file is located and run the following command:
   ```bash
   python app.py
   ```
   The server will start on `http://localhost:5000` by default.

3. **Test the Flask API**:
   Ensure that the server is running properly by sending a sample image using a tool like Postman or CURL, or by using the mobile app.

---

### Flutter Mobile App

Once the **Python Flask backend is running**, you can now run the Flutter app. The Flutter app will send requests to the Python backend for face detection and display the results.

---

### Workflow

1. **Run the Flask backend (Python)**:
   - This step is essential because the Flutter app communicates with the Flask server via HTTP requests to get the image processed.
   
2. **Run the Flutter app**:
   - After the Flask server is running, open the Flutter app to interact with it.
   - The app will upload an image to the Flask API for face detection and display the processed image with bounding boxes around detected faces.

---

### Important Note:
- **Ensure the Flask server is running** on your system at `http://localhost:5000` before launching the Flutter app. The Flutter app depends on this server to handle image uploads and processing.

---

## Outputs

The program will produce the following outputs:

1. **Original Image**: Displays the input image.
2. **Skin Mask**: A binary mask that highlights the skin regions in the image.
3. **Eroded and Dilated Masks**: Refined masks after applying morphological transformations.
4. **Edges**: Detected edges in the image using the Canny algorithm.
5. **XOR Result**: A refined mask after applying the XOR logical operation to eliminate false positives.
6. **Histograms**: Visualizations of aspect ratios of the detected regions to aid in filtering.
7. **Final Image**: The original image with bounding boxes around detected faces.

---

## Limitations

- The method may not perform well in the following cases:
  - Complex backgrounds with no clear distinction between the face and background.
  - Low-quality images or images with poor lighting conditions.
  - Overlapping or occluded faces.
  - Images with non-human faces (e.g., animal faces).

---

## Future Enhancements
1. **Real-Time Detection**: Integrate with webcam or real-time video feed for live face detection.
2. **GUI for Visualization**: Create a graphical user interface (GUI) to simplify interaction and visualization of detection results.
3. **Optimizations for Speed**: Enhance performance for real-time processing and large-scale datasets.

---

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Acknowledgments
Special thanks to the open-source contributors and the developers of Python libraries (e.g., OpenCV, NumPy, Scikit-image, Matplotlib) who made this project possible. Your contributions are greatly appreciated!

---

## Additional Resources
For more detailed information on the implementation and results of this project, please refer to the [Project Report](https://drive.google.com/file/d/17QnKxqzXBB2fWX2wN9wzlal0dphwhEFD/view?usp=drive_link).

