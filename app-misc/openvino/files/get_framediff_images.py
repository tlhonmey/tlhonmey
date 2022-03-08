#!/usr/bin/env python3
import sys
import getopt
import cv2
import numpy as np
import os
import cv2
from os import listdir
import argparse

class Video2Frames:
    def __init__(self, video):
        self.video = video
    
    def frames(self):
        cap = cv2.VideoCapture(self.video)
        nframes = cap.get(cv2.CAP_PROP_FRAME_COUNT)
        w = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
        h = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
        ch = 3
        vdata = np.zeros((int(nframes), int(h), int(w), ch)).astype(np.uint8)
        suc, frame = cap.read()
        count = 0
        vdata[count,:,:,:] = frame
        while suc:
            suc, frame = cap.read()
            count = count + 1
            if suc:
                vdata[count,: , :, :] = frame
        return vdata

    def extractYChannel(self, I):
        I = cv2.cvtColor(I, cv2.COLOR_BGR2YUV)
        Y, U, V = cv2.split(I)
        Y = Y.astype(float)
        return Y 

def LoadClip(clip):
    Yframes = []
    
    try:
        vid = Video2Frames(clip)
        vframe = vid.frames()
        color2gray = cv2.COLOR_BGR2YUV
    except Exception as e:
        print(f"Caught exception: {e}")
        return -1
            
    for frame in vframe:
        I = cv2.cvtColor(frame, color2gray)
        Y, U, V = cv2.split(I)
        Y = cv2.resize(Y, (320, 240))
        Yframes.append(Y.astype(float))

    return (Yframes, vframe)


def main(args):
    clipPath = args.clip
    outputDir = args.outputDir

    if os.path.exists(clipPath):
        print(f"Attempting to load clip...")
        framesTuple = LoadClip(clipPath)

        if framesTuple != -1:
            yuvFrames = framesTuple[0]
            numFrames = len(yuvFrames)

            if not os.path.exists(outputDir):
                os.mkdir(outputDir)

            for i in range(1, numFrames):
                currImg = yuvFrames[i]
                prevImg = yuvFrames[i - 1]

                absDiffImg = np.abs(currImg - prevImg)
                absDiffImg = absDiffImg.astype(np.uint8)

                medianBlurImg = cv2.medianBlur(absDiffImg, 3)
                networkFrameDiff = cv2.resize(medianBlurImg, (128, 128))
                floatImgInput = np.array(networkFrameDiff, dtype=np.float32)

                outputImgName = f"{outputDir}/frame_diff_%04d.png" % (i)
                cv2.imwrite(outputImgName, networkFrameDiff)

                outputBinName = f"{outputDir}/frame_diff_%04d.bin" % (i)
                floatImgInput.tofile(outputBinName)
        else:
            print(f"Error: Unable to successfully load clip '{clipPath}'")

    else:
        print(f"Error: The video clip {imgFolder} does not exist")
    
    print(f"Complete")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--clip', default='video_clip.mp4', help='Video clip file')
    parser.add_argument('--outputDir', default='./frames', help='Output frames folder')

    args = parser.parse_args()
    main(args)