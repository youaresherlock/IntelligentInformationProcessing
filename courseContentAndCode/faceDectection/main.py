import os
import cv2
import shutil
import math
import random
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import matplotlib.image as mpimg


def show_people(flag = False):
    if flag:
        string = 'orl_faces\\s'
        rootPath = os.listdir('orl_faces')
        imgs = []
        # 7 * 6
        fileLen = len(rootPath)
        for i in range(1, fileLen):
            filepath = os.path.join(string + str(i), '1.pgm')
            imgs.append(mpimg.imread(filepath))
        plt.figure()
        count = 0
        for i in  range(1, 8):
            for j in range(1, 7):
                plt.subplot(6, 7, count + 1)
                plt.imshow(imgs[count])
                if count < 39:
                    count += 1
        plt.show()

# 这个类是我拷贝别人的特征提取的类，其他程序都是我写的 可是用此类分类能力太差，请忽略待改进
class Hog_descriptor():
    def __init__(self, img, cell_size=16, bin_size=8):
        self.img = img
        self.img = np.sqrt(img / np.max(img))
        self.img = img * 255
        self.cell_size = cell_size
        self.bin_size = bin_size
        self.angle_unit = 360 / self.bin_size
        # assert type(self.bin_size) == int, "bin_size should be integer,"
        # assert type(self.cell_size) == int, "cell_size should be integer,"
        # assert type(self.angle_unit) == int, "bin_size should be divisible by 360"

    def extract(self):
        height, width = self.img.shape
        gradient_magnitude, gradient_angle = self.global_gradient()
        gradient_magnitude = abs(gradient_magnitude)

        cell_gradient_vector = np.zeros((int(height / self.cell_size), int(width / self.cell_size), self.bin_size))
        for i in range(cell_gradient_vector.shape[0]):
            for j in range(cell_gradient_vector.shape[1]):
                cell_magnitude = gradient_magnitude[i * self.cell_size:(i + 1) * self.cell_size,
                                 j * self.cell_size:(j + 1) * self.cell_size]
                cell_angle = gradient_angle[i * self.cell_size:(i + 1) * self.cell_size,
                             j * self.cell_size:(j + 1) * self.cell_size]
                cell_gradient_vector[i][j] = self.cell_gradient(cell_magnitude, cell_angle)

        hog_image = self.render_gradient(np.zeros([height, width]), cell_gradient_vector)
        hog_vector = []
        for i in range(cell_gradient_vector.shape[0] - 1):
            for j in range(cell_gradient_vector.shape[1] - 1):
                block_vector = []
                block_vector.extend(cell_gradient_vector[i][j])
                block_vector.extend(cell_gradient_vector[i][j + 1])
                block_vector.extend(cell_gradient_vector[i + 1][j])
                block_vector.extend(cell_gradient_vector[i + 1][j + 1])
                mag = lambda vector: math.sqrt(sum(i ** 2 for i in vector))
                magnitude = mag(block_vector)
                if magnitude != 0:
                    normalize = lambda block_vector, magnitude: [element / magnitude for element in block_vector]
                    block_vector = normalize(block_vector, magnitude)
                hog_vector.append(block_vector)
        return hog_vector, hog_image

    def global_gradient(self):
        gradient_values_x = cv2.Sobel(self.img, cv2.CV_64F, 1, 0, ksize=5)
        gradient_values_y = cv2.Sobel(self.img, cv2.CV_64F, 0, 1, ksize=5)
        gradient_magnitude = cv2.addWeighted(gradient_values_x, 0.5, gradient_values_y, 0.5, 0)
        gradient_angle = cv2.phase(gradient_values_x, gradient_values_y, angleInDegrees=True)
        return gradient_magnitude, gradient_angle

    def cell_gradient(self, cell_magnitude, cell_angle):
        orientation_centers = [0] * self.bin_size
        for i in range(cell_magnitude.shape[0]):
            for j in range(cell_magnitude.shape[1]):
                gradient_strength = cell_magnitude[i][j]
                gradient_angle = cell_angle[i][j]
                min_angle, max_angle, mod = self.get_closest_bins(gradient_angle)
                orientation_centers[min_angle] += (gradient_strength * (1 - (mod / self.angle_unit)))
                orientation_centers[max_angle] += (gradient_strength * (mod / self.angle_unit))
        return orientation_centers

    def get_closest_bins(self, gradient_angle):
        idx = int(gradient_angle / self.angle_unit)
        mod = gradient_angle % self.angle_unit
        return idx, (idx + 1) % self.bin_size, mod

    def render_gradient(self, image, cell_gradient):
        cell_width = self.cell_size / 2
        max_mag = np.array(cell_gradient).max()
        for x in range(cell_gradient.shape[0]):
            for y in range(cell_gradient.shape[1]):
                cell_grad = cell_gradient[x][y]
                cell_grad /= max_mag
                angle = 0
                angle_gap = self.angle_unit
                for magnitude in cell_grad:
                    angle_radian = math.radians(angle)
                    x1 = int(x * self.cell_size + magnitude * cell_width * math.cos(angle_radian))
                    y1 = int(y * self.cell_size + magnitude * cell_width * math.sin(angle_radian))
                    x2 = int(x * self.cell_size - magnitude * cell_width * math.cos(angle_radian))
                    y2 = int(y * self.cell_size - magnitude * cell_width * math.sin(angle_radian))
                    cv2.line(image, (y1, x1), (y2, x2), int(255 * math.sqrt(magnitude)))
                    angle += angle_gap
        return image

# move file to trainSet or testSet
def moveFile(srcFilePath, dstPath):
    if not os.path.isfile(srcFilePath):
        print("%s not exist!" %(srcFilePath))
    else:
        if not os.path.exists(dstPath):
            os.makedirs(dstPath)
        shutil.move(srcFilePath, dstPath)


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
    path = ['trainingSet', 'testingSet']
    for each in path:
        if not os.path.exists(each):
            os.mkdir(each)
    src = 'orl_faces\\s'

    for i in range(40):
        random_list = os.listdir(src + str(i + 1))
        print("processing the number s{0} directory.....".format(i + 1))
        random.shuffle(random_list)
        k = proportion * 10
        for j in range(len(random_list)):
            dstPath = path[0] if j < k else path[1]
            filename = random_list[j]
            srcFilePath = os.path.join(src + str(i + 1), filename)
            moveFile(srcFilePath, dstPath)
            srcfile = os.path.join(dstPath, filename)
            dstfile = os.path.join(dstPath, str(10 * (i + 1) + int(filename.split('.')[0])) + '.pgm')
            os.rename(srcfile, dstfile)
            print("move samples from directory {0} ----> {1}".format(srcFilePath, dstfile))

# change the gray picture to row vector
def img2vector(filename):
    img = mpimg.imread(filename)
    # print(img.shape)
    # plt.imshow(img)
    # plt.show()
    # hog = Hog_descriptor(img, cell_size = 4, bin_size = 8)
    # vector, image = hog.extract()
    # return vector[0] # 1*32个特征值

    return img.reshape(1, -1)

# 读取训练集和数据集
def readData(trainFilePath, testFilePath):
    trainingFileList = os.listdir(trainFilePath)
    testFileList = os.listdir(testFilePath)

    trainingLen = len(trainingFileList)
    trainLabels = []
    trainSet = np.zeros((trainingLen, 92 * 112)) # 92 * 112
    for i in np.arange(trainingLen):
        filename = trainingFileList[i]
        classNum = int(filename.split('.')[0])
        classNum = math.ceil(classNum / 10) - 1
        trainLabels.append(classNum)
        trainSet[i] = img2vector(os.path.join(trainFilePath, filename))

    testingLen = len(testFileList)
    testSet = np.zeros((testingLen, 92 * 112))
    testLabels = []
    for i in np.arange(testingLen):
        filename = testFileList[i]
        classNum = int(filename.split('.')[0])
        classNum = math.ceil(classNum / 10) - 1
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

    # 给距离加入权重
    w = []
    for i in range(k):
        w.append((distance[sortedArray[k-1]] - distance[sortedArray[i]])\
                 / (distance[sortedArray[k-1]] - distance[sortedArray[0]]))

    count = np.zeros(41)
    temp = 0
    for each in sortedArray:
        count[labels[each]] += 1 + w[temp]
        temp += 1

    label = np.argmax(count) # 如果label中有多个一样的样本数，那么取第一个最大的样本类别
    return label

def main(k):

    show_people(flag = True)
    # generate the trainingSet and the testingSet
    if not os.path.exists('testingSet') and not os.path.exists("trainingSet"):
        prompt = "Please input the proportion(0~1): "
        while True:
            receive = input(prompt)
            proportion = round(float(receive), 1)
            if  0 < proportion < 1:
                break
            prompt = "Please input again ! :) :"
        makeSet(proportion)

    # read data
    data = readData('trainingSet', 'testingSet')
    trainSet = data['trainSet']
    trainLabels = data['trainLabels']
    testSet = data['testSet']
    testLabels = data['testLabels']

    # normalization
    temp = trainSet.shape[0]
    array = np.vstack((trainSet, testSet))
    normalized_array = maxmin_norm(array)
    trainSet, testSet = normalized_array[:temp], normalized_array[temp:]

    correct_count = 0
    test_number = testSet.shape[0]
    string = "test sample serial number: {0}, sample label: {1}, classify label: {2}------>correct?: {3}"
    for i in np.arange(test_number):
       label =  kNNClassify(testSet[i], trainSet, trainLabels, k = k)
       if label == testLabels[i]:
           correct_count += 1
       print(string.format(i + 1, testLabels[i], label, label == testLabels[i]))

    print("face recognization accuracy: {}%".format((correct_count / test_number) * 100))
    return (correct_count / test_number) * 100

# verify the proper k
def selectK():
    x = list()
    y = list()
    for i in range(3, 11):
        x.append(i)
        y.append(main(i))
    plt.plot(x, y)
    plt.show()

if __name__ == "__main__":
   main(4) # 结果96.5%左右


# bmpToJpg('orl_faces\\s1')
# print(img2vector('orl_faces\s1\\1.jpg').shape)
# deleteImages('orl_faces\s1', 'jpg')
