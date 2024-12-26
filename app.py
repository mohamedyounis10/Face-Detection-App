from flask import Flask, request, jsonify, send_file
from werkzeug.utils import secure_filename
import cv2
import numpy as np
from skimage import io, color
import os
import tempfile
import io as pyio

app = Flask(__name__)

# Create a folder to store uploaded images
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Face detection function (your existing code)
def detect_faces(image_path):
    my_image = io.imread(image_path)
    hsv_image = color.rgb2hsv(my_image) * 255
    hsv_image = hsv_image.astype(np.uint8)

    # Define lower and upper limits for skin color in HSV
    lower_skin = np.array([0, 20], dtype=np.uint8)
    upper_skin = np.array([20, 255], dtype=np.uint8)

    # Initialize an empty mask with the same size as the image
    skin_mask = np.zeros((hsv_image.shape[0], hsv_image.shape[1]))

    # Loop through the image pixels
    for i in range(hsv_image.shape[0]):
        for j in range(hsv_image.shape[1]):
            h, s, v = hsv_image[i, j]
            if (lower_skin[0] <= h <= upper_skin[0]) and (lower_skin[1] <= s <= upper_skin[1]):
                skin_mask[i, j] = 255
            else:
                skin_mask[i, j] = 0

    kernel = np.ones((13, 13), dtype=np.uint8)
    eroded_mask = cv2.erode(skin_mask, kernel, iterations=1)

    kernel = np.ones((19, 19), dtype=np.uint8)
    dilated_mask = cv2.dilate(eroded_mask, kernel, iterations=2)

    image_copy = my_image.copy()
    image_copy[dilated_mask == 0] = 0

    # Apply Canny edge detection
    edges = cv2.Canny(cv2.cvtColor(image_copy, cv2.COLOR_RGB2GRAY), 100, 200)
    kernel = np.ones((3, 3), dtype=np.uint8)
    edges = cv2.dilate(edges, kernel, iterations=1)

    edges_thresholded = np.where(edges >= 0.15, 1, 0)
    xor_result = np.logical_xor(edges_thresholded, dilated_mask).astype(np.uint8)

    # Find connected components
    num_labels, labels_im, stats, centroids = cv2.connectedComponentsWithStats(xor_result)

    filtered_faces = []
    for i in range(1, num_labels):
        x, y, w, h, area = stats[i, cv2.CC_STAT_LEFT], stats[i, cv2.CC_STAT_TOP], stats[i, cv2.CC_STAT_WIDTH], stats[i, cv2.CC_STAT_HEIGHT], stats[i, cv2.CC_STAT_AREA]
        if (0.64 < w / float(h) < 1.2 and w > 25 and h > 25 and area > 2000):
            filtered_faces.append((x, y, w, h))

    for (x, y, w, h) in filtered_faces:
        cv2.rectangle(my_image, (x, y), (x + w, y + h), (0, 255, 0), 3)

    # Save the output image
    output_image_path = os.path.join(app.config['UPLOAD_FOLDER'], 'output.jpg')
    cv2.imwrite(output_image_path, cv2.cvtColor(my_image, cv2.COLOR_RGB2BGR))

    return output_image_path, len(filtered_faces)

@app.route('/upload', methods=['POST'])
def upload_image():
    # Check if an image is sent
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    
    filename = secure_filename(file.filename)
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(file_path)

    # Process the image and detect faces
    output_image_path, num_faces = detect_faces(file_path)

    # Send the processed image and face count as response
    with open(output_image_path, 'rb') as f:
        img_data = pyio.BytesIO(f.read())
        img_data.seek(0)
        return send_file(img_data, mimetype='image/jpeg', as_attachment=False), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # Ensure no indentation issues here
