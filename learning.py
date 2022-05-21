import numpy as np
import tensorflow as tf
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout
from tensorflow.keras import utils
from tensorflow.keras.preprocessing import image
from tensorflow.keras.preprocessing import image_dataset_from_directory
import matplotlib.pyplot as plt

train_dataset = image_dataset_from_directory('ds/Training',
                                             subset='training',
                                             seed=42,
                                             validation_split=0.1,
                                             batch_size=256,
                                             image_size=(100, 100))

validation_dataset = image_dataset_from_directory('ds/Training',
                                             subset='validation',
                                             seed=42,
                                             validation_split=0.1,
                                             batch_size=256,
                                             image_size=(100, 100))
test_dataset = image_dataset_from_directory('ds/Test',
                                             batch_size=256,
                                             image_size=(100, 100))
                                        
# Создаем последовательную модель
model = tf.keras.models.Sequential()
model.add(Conv2D(16, (5, 5), padding='same', 
                 input_shape=(100, 100, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Conv2D(32, (5, 5), activation='relu', padding='same'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Conv2D(64, (5, 5), activation='relu', padding='same'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Conv2D(128, (5, 5), activation='relu', padding='same'))
model.add(MaxPooling2D(pool_size=(2, 2)))
# Полносвязная часть нейронной сети
model.add(Flatten())
model.add(Dense(1024, activation='relu'))
model.add(Dropout(0.2))
model.add(Dense(256, activation='relu'))
model.add(Dropout(0.2))
# Выходной слой
model.add(Dense(2, activation='softmax'))

model.compile(loss='sparse_categorical_crossentropy',
              optimizer="adam",
              metrics=['accuracy'])

history = model.fit(train_dataset, 
                    validation_data=validation_dataset,
                    epochs=5,
                    verbose=2)
from keras.preprocessing import image


plt.figure(figsize=(8, 8))
for images, labels in train_dataset.take(1):
  for i in range(9):
    ax = plt.subplot(3, 3, i + 1)
    plt.imshow(images[i].numpy().astype("uint8"))
    im=image.img_to_array(images[i].numpy().astype("uint8"))
    im=np.expand_dims(im,axis=0)
    pr=model.predict(im)
    plt.title(class_names[labels[i]])
    if(pr[0][0]>pr[0][1]):
      plt.title(str('Apple')+" "+str(max(pr[0])))
      plt.axis("off")
    else:
      plt.title(str('Banana')+" "+str(max(pr[0])))
      plt.axis("off")
