import os
import random

inputDirectory = "./original"
outputDirectory = "./processed"

def findPossibleIndex(toParse):
    toReturn = []
    for current in range(0,len(toParse)):
        if toParse[current] == " ":
            toReturn.append(current)
    toReturn.append(len(toParse))
    return toReturn

for filename in os.listdir(inputDirectory) :
    content = open(os.path.join(inputDirectory , filename), 'r')
    output = open(os.path.join(outputDirectory , filename),"w")
    currentLine = content.readline()

    outputFile = ""
  
    currentProbability = 0.3
    while currentLine:
        currentLine = content.readline()

        if random.random() <= currentProbability :
            possibleIndexes = findPossibleIndex(currentLine)
            insertPosition = possibleIndexes[random.randint(0,len(possibleIndexes)-1)]
            fileLink = filename
            while(fileLink == filename):
                fileLink = "site"+str(random.randint(1,len(os.listdir(inputDirectory))))+".txt"

            fileLink = " linkTo:"+fileLink
            if insertPosition == len(currentLine):
                currentLine += fileLink
            else:
                currentLine = currentLine[0:insertPosition]+fileLink+currentLine[insertPosition:]
        outputFile += currentLine
    output.write(outputFile)
