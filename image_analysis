import sim
import time

from PIL import Image as I
import array

import cv2, numpy
import array
from PIL import Image
import math
import time
import numpy


import keras
from keras.preprocessing import image

data1=['apple','banana']
model=keras.models.load_model("C:\\Users\\seraf\\PycharmProjects\\keras\\fruits_banana_apple_3.h5", compile = True)

sim.simxFinish(-1)

clientID = sim.simxStart('127.0.0.1', 19997, True, True, 5000, 5)

if clientID!=-1:
  print('Connected to remote API server')

  # get vision sensor objects
  res, v0 = sim.simxGetObjectHandle(clientID, 'v0', sim.simx_opmode_oneshot_wait)
  res, v1 = sim.simxGetObjectHandle(clientID, 'v1', sim.simx_opmode_oneshot_wait)
  res1,visionSensorHandle1=sim.simxGetObjectHandle(clientID,'Vision_sensor2',sim.simx_opmode_oneshot_wait)

  err, resolution, image0 = sim.simxGetVisionSensorImage(clientID, v0, 0, sim.simx_opmode_streaming)
  err, resolution, image0 = sim.simxGetVisionSensorImage(clientID, v0, 0, sim.simx_opmode_streaming)
  err1, resolution1, image1 = sim.simxGetVisionSensorImage(clientID, visionSensorHandle1, 0, sim.simx_opmode_streaming)
  time.sleep(1)
  count=0
  maxx=0
  while (sim.simxGetConnectionId(clientID) != -1):
    #ищем фрукты
    err1, resolution1, image1 = sim.simxGetVisionSensorImage(clientID, visionSensorHandle1, 0, sim.simx_opmode_buffer)
    image1=[abs(x) for x in image1]
    #image1=[x>0 for x in image1]
    if err1 == sim.simx_return_ok:
      byte_im=bytes(image1)
      #print("0")  
      image_buffer = Image.frombuffer("RGB", (resolution1[0],resolution1[1]), byte_im, "raw", "RGB", 0, 1)  
      img2 = numpy.asarray(image_buffer)
                  #print(img2)

      new_image=Image.fromarray(img2)
      new_image1=new_image.rotate(180)
      #new_image1=new_image.transpose(Image.FLIP_LEFT_RIGHT)
      new_image1=new_image.transpose(Image.FLIP_TOP_BOTTOM)
      #new_image1.save(F"D:\\test\\test{count}.jpg")
      count+=1

      x=image.img_to_array(new_image1)

      if(x.max()>maxx):
        maxx=x.max()

      x=numpy.expand_dims(x,axis=0)

      pred=model.predict(x)

      print(pred.max())
      maxi=0
      max0=0
      for i in range(len(pred[0])):
        if(pred[0][i]>max0):
          max0=pred[0][i]
          maxi=i
      print(data1[maxi])
      sim.simxSetFloatSignal(clientID,'apple',maxi,sim.simx_opmode_oneshot) 

    elif err1 == sim.simx_return_novalue_flag:
      print("no fruit yet")
      pass
    else:
      print(err1)

else:
  print("Failed to connect to remote API Server")
  sim.simxFinish(clientID)
