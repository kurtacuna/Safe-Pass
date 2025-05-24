import face_recognition_models
import cv2
import face_recognition
import numpy as np

np.bool


first_image = cv2.imread("jb1.jpg")
rgb_first_image = cv2.cvtColor(first_image, cv2.COLOR_BGR2RGB)
first_image_encoding = face_recognition.face_encodings(rgb_first_image)[0]
# cv2.imshow("First Image", first_image)
# cv2.waitKey(0)

second_image = cv2.imread("jb3.jpg")
rgb_second_image = cv2.cvtColor(second_image, cv2.COLOR_BGR2RGB)
second_image_encoding = face_recognition.face_encodings(rgb_second_image)[0]
# cv2.imshow("Second Image", second_image)
# cv2.waitKey(0)

third_image = cv2.imread("jb2.webp")
rgb_third_image = cv2.cvtColor(third_image, cv2.COLOR_BGR2RGB)
third_image_encoding = face_recognition.face_encodings(rgb_third_image)[0]

result = face_recognition.compare_faces([first_image_encoding, third_image_encoding], second_image_encoding)
print(result)




# # Facial features that can be detected
# face_features = [
#     "chin",
#     "left_eyebrow",
#     "right_eyebrow",
#     "nose_bridge",
#     "nose_tip",
#     "left_eye",
#     "right_eye",
#     "top_lip",
#     "bottom_lip"
# ]

# # List of face landmarks for each face
# second_image_face_landmarks = face_recognition.face_landmarks(rgb_second_image)

# # Plot facial features detected
# for landmarks in second_image_face_landmarks[0]:
#     for feature in face_features:
#         if feature in landmarks:
#             print(feature)
#             points = second_image_face_landmarks[0][feature]
#             for index, (x, y) in enumerate(points):
#                 cv2.circle(rgb_second_image, (x, y), 1, (0, 255, 0), -1)
#                 cv2.line(rgb_second_image, points[index - 1 if index > 0 else index], points[index], (0, 0, 255), 1)

# cv2.imshow("dotted face", rgb_second_image)
# cv2.waitKey(0)