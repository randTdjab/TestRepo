import os
import re       # I imported this just for getNumber Function
import shutil



DPath = input("comic path : ")
CType = input("Comic Type : ")

# This function takes a string as an Input and output the list of numbers in that string
def getNumber(string):
    temp = re.findall(r'\d+', string)
    res = list(map(int, temp))
    return res



# Extract last folder from path 
def pathToName(path):
    name = ""
    for i in range(len(path)):
        if (path[len(path)-i-1] == '\ '[0] ):
            for j in range(len(path)-i,len(path)):
                name += path[j]
            break
    return name




# Loading what Chapter to upload next or creating a new folder 
try :
    with open("MN-"+ pathToName(DPath) +".txt", 'r') as file:
        NextCh = file.read()
        file.close()
        pass
except : 
    with open("MN-"+ pathToName(DPath) +".txt", 'w') as file:
        NextCh = "1"
        file.write("1")
        file.close()
        pass


NextCh = int(NextCh)

# Os.listdir return the names of the folders or files that excit in the "DPath"
Files = os.listdir(DPath)


# this list contains the folders that we are going to move
SelectedFiles = []
DowChapters = []

# Geeting the Latest downloaded chapter
for i in Files:
    DowChapters.append(getNumber(i)[0])

LastDowChapter = max(DowChapters)


for i in Files:
    if (getNumber(i)[0] >= NextCh) and (getNumber(i)[0] <= LastDowChapter):
        SelectedFiles.append(i)


# Now I should Copy the image to the cover images to the selected file

for i in SelectedFiles:

    # copying the whole file to the comics folder
    source_dir = DPath + "/" + i
    destination_dir = "E:/A89 (my files)/BooksO/Comics/"+ CType + "/"+pathToName(DPath)+"/issue "+ str(getNumber(i)[0])
    shutil.copytree(source_dir, destination_dir)


with open("MN-"+ pathToName(DPath) +".txt", 'w') as file:
    file.write(str(LastDowChapter + 1))
    file.close()
    pass
