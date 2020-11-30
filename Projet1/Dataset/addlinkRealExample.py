import os
import random

inputDirectory = "./original"
outputDirectory = "./processed"

#probability parameters
TopLevel = 1.6
SecondLevel = 1.1
ThirdLevel = 0.8
FourAndAbove = 0.5


pickInside = 1.0
pickOutside = 0.5

topics = []
siteLevel = []
fileStructure = []

matrix = [[0,0,0,0],
          [0,0,0,0],
          [0,0,0,0],
          [0,0,0,0],
          [0,0,0,0],
          [0,0,0,0]]

count = 0

def findPossibleIndex(toParse):
    toReturn = []
    for current in range(0,len(toParse)):
        if toParse[current] == " ":
            toReturn.append(current)
    toReturn.append(len(toParse))
    return toReturn

def manageFile(inputPath,outputPath,topicIndex,currentLevel,filename):
    count = 0
    content = open(inputPath , 'r')
    output = open(outputPath ,"w")
    currentLine = content.readline()

    outputFile = ""

    while currentLine:
        currentLine = content.readline()
        randomPick = random.uniform(0.0,2.0)
        if randomPick <= pickInside+pickOutside :
            possibleIndexes = findPossibleIndex(currentLine)
            insertPosition = possibleIndexes[random.randint(0,len(possibleIndexes)-1)]

            selectedTopic = topicIndex

            if(randomPick<=pickOutside):
                while(selectedTopic == topicIndex):
                    selectedTopic = random.randint(0,len(topics)-1)

            randomPick = random.uniform(0.0,4.0)

            if(randomPick <= TopLevel + SecondLevel + ThirdLevel + FourAndAbove):
                selectedLevel = 0
                if(randomPick <= TopLevel):
                    selectedLevel = 1
                if(randomPick <= TopLevel+ SecondLevel and randomPick > TopLevel):
                    selectedLevel = 2
                if(randomPick <= TopLevel + SecondLevel + ThirdLevel and randomPick > TopLevel+ SecondLevel):
                    selectedLevel = 3
                if(randomPick <= TopLevel + SecondLevel + ThirdLevel + FourAndAbove and randomPick > TopLevel + SecondLevel + ThirdLevel):
                    if(len(siteLevel[selectedTopic]) == 4):
                        selectedLevel = 4
                    else:
                        selectedLevel = random.randint(4,len(siteLevel[selectedTopic]))

                i = 0
                found = False
                while i<len(siteLevel[selectedTopic]) and not found:
                    if siteLevel[selectedTopic][i] == str(selectedLevel)+"grade":
                        found = True
                        selectedLevel = i
                    i+=1

                i=0
                found = False
                referenceLevel = 0
                while i<len(siteLevel[selectedTopic]) and not found:
                    if siteLevel[selectedTopic][i] == siteLevel[selectedTopic][currentLevel]+"grade":
                        found = True
                        referenceLevel = i
                    i+=1


                if(selectedLevel>=referenceLevel):
                    matrix[selectedTopic][selectedLevel] += 1
                    fileLink = filename
                    while(fileLink == filename):
                        fileLink = fileStructure[selectedTopic][selectedLevel][random.randint(0,len(fileStructure[selectedTopic][selectedLevel])-1)]

                    fileLink = " linkTo:"+fileLink
                    count += 1
                    print(count)
                    if insertPosition == len(currentLine):
                        currentLine += fileLink
                    else:
                        currentLine = currentLine[0:insertPosition]+fileLink+currentLine[insertPosition:]
        outputFile += currentLine
    output.write(outputFile)
    return count

topicIndex=0

for foldername in os.listdir(inputDirectory) :

    if(foldername[0] != "."):

        topics.append(foldername)
        siteLevel.append([])
        fileStructure.append([])

        levelIndex=0
        for categoryName in os.listdir(inputDirectory+"/"+foldername):
            if(categoryName[0] != "."):
                siteLevel[topicIndex].append(categoryName)
                fileStructure[topicIndex].append([])
                for filename in os.listdir(inputDirectory+"/"+foldername+"/"+categoryName):
                    if(filename[0] != "."):
                        fileStructure[topicIndex][levelIndex].append(filename)

                levelIndex += 1
        topicIndex += 1


for i in range(0,len(topics)):
    for j in range(0,len(siteLevel[i])):
        for k in range(0,len(fileStructure[i][j])):
            count += manageFile(inputDirectory+"/"+topics[i]+"/"+siteLevel[i][j]+"/"+fileStructure[i][j][k],outputDirectory+"/"+fileStructure[i][j][k],i,j,fileStructure[i][j][k])

print(str(count)+" liens créés")

print(siteLevel)

print(matrix)