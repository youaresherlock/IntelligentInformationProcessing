import os
import shutil
import math
import random
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

# move file to trainSet or testSet
def moveFile(srcfile, dstfile):
    if not os.path.isfile(srcfile):
        print("%s not exist!" %(srcfile))
    else:
        filepath, filename = os.path.split(dstfile)
        if not os.path.exists(filepath):
            os.makedirs(filepath)
        shutil.move(srcfile, dstfile)


#  transform bmp to jpg
def bmpToJpg(filePath):
    if not os.path.isdir(filePath):
        raise ValueError("filePath Error!")
    for each in os.listdir(filePath):
        filename = each.split('.')[0] + ".jpg"
        im = Image.open(os.path.join(filePath, each))
        im.save(os.path.join(filePath, filename))

# delete original bgm picture
def deleteImages(filePath, imageFormat):
    command = "del " + filePath + "\\*." + imageFormat
    os.system(command)

# The data sets are divided into training sets and sample sets
def makeSet(proportion):
    """
    :param proportion: user input the proportion of trainSet number
    :return:
    """
    path = ['testing', 'training']
    for each in path:
        if not os.path.exists(each):
            os.mkdir(each)
    src = 'orl_faces\\s'
    srcfile = ''
    dstfile = ''

    for i in range(40):
        random_list = os.listdir(src + str(i + 1))
        random.shuffle(random_list)
        k = proportion * 10
        for filename in random_list[:k]:
            srcfile = os.path.join(src + str(i + 1), filename)
            dstfile = path[0]
            moveFile(srcfile, dstfile)
            srcfile = os.path.join(dstfile, filename)
            dstfile = os.path.join(dstfile,)
            os.rename(dstf )









# change the gray picture to row vector
def img2vector(filename):
    img = mpimg.imread(filename)
    # print(img.shape)
    # plt.imshow(img)
    # plt.show()
    return img.reshape(1, -1)

# 读取训练集和数据集
def readData(trainFilePath, testFilePath):
    trainingFileList = os.listdir(trainFilePath)
    testFileList = os.listdir(testFilePath)

    trainingLen = len(trainingFileList)
    trainLabels = []
    trainSet = np.zeros((trainingLen, 10304))
    for i in np.arange(trainingLen):
        filename = trainingFileList[i]
        classNum = int(filename.split('.')[0])
        classNum = math.ceil(classNum / 5)
        trainLabels.append(classNum)
        trainSet[i] = img2vector(os.path.join(trainFilePath, filename))

    testingLen = len(testFileList)
    testSet = np.zeros((testingLen, 10304))
    testLabels = []
    for i in np.arange(testingLen):
        filename = trainingFileList[i]
        classNum = int(filename.split('.')[0])
        classNum = math.ceil(classNum / 5)
        testLabels.append(classNum)
        testSet[i] = img2vector(os.path.join(testFilePath, filename))

    return {'trainSet' : trainSet, 'trainLabels' : trainLabels,
            'testSet' : testSet, 'testLabels' : testLabels}


# 进行归一化处理 normalization
def maxmin_norm(array):
    """
    :param array: 每行为一个样本，每列为一个特征，且只包含数据，没有包含标签
    :return:
    """
    maxcols = array.max(axis = 0)
    mincols = array.min(axis = 0)
    data_shape = array.shape
    data_rows, data_cols = data_shape
    t = np.empty((data_rows, data_cols))
    for i in range(data_cols):
        t[:, i] = (array[:, i] - mincols[i]) / (maxcols[i] - mincols[i])
    return t

# KNN classifier
def kNNClassify(inX, dataSet, labels, k = 3):
    """
    :param inX: 测试的样本的112*92灰度数据
    :param dataSet: 训练集
    :param labels: 训练集的标签列表('1' '2' ..... '40'共40类别)
    :param k: k值
    :return: 预测标签label
    distance是[5 50 149...]是测试样本距离每个训练样本的距离向量40 * 1
    """
    distance = np.sum(np.power((dataSet - inX), 2), axis = 1) # 计算欧几里得距离
    sortedArray = np.argsort(distance, kind = "quicksort")[:k]

    count = np.zeros(11)
    for each in sortedArray:
        count[labels[each]] += 1
    label = np.argmax(count) # 如果label中有多个一样的样本数，那么取第一个最大的样本类别
    return label

def main(k):
    data = readData('trainingSet', 'testingSet')
    trainSet = data['trainSet']
    trainLabels = data['trainLabels']
    testSet = data['testSet']
    testLabels = data['testLabels']

    correct_count = 0
    test_number = testSet.shape[0]
    string = "test sample number: {0}, sample label: {1}, classify label: {2}------>correct?: {3}"
    for i in np.arange(test_number):
       label =  kNNClassify(testSet[i], trainSet, trainLabels, k = k)
       if label == testLabels[i]:
           correct_count += 1
       print(string.format(i + 1, testLabels[i], label, label == testLabels[i]))

    print("face recognization accuracy: {}%".format((correct_count / test_number) * 100))
    return (correct_count / test_number) * 100

def selectK():
    x = list()
    y = list()
    for i in range(1, 10):
        x.append(i)
        y.append(main(i))
    plt.plot(x, y)
    plt.show()

# if __name__ == "__main__":
#     selectK()
#
# bmpToJpg('orl_faces\\s1')
# print(img2vector('orl_faces\s1\\1.jpg').shape)
# deleteImages('orl_faces\s1', 'jpg')