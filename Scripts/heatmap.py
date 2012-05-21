#**
#*  This work is distributed under the Lesser General Public License,
#*	see LICENSE for details
#*
#*  @author Gwennael ARBONA
#**

# Imports
from PIL import Image, ImageDraw
import os, string

#---------------------------------------------------------
#	Settings
#---------------------------------------------------------


# LD_Test 
#unrealToPixelRatio = 4.0
#xmin = -5120.0
#xmax = 0.0
#ymin = -1280.0
#ymax = 2048.0

# LEVEL_01
SourceImage="LEVEL_01.png"
unrealToPixelRatio = 2.0
xmin = -2480.0
xmax = 6224.0
ymin = -1488.0
ymax = 7231.0

# Color mapping
DotSize1 = 3
DotSize2 = 5
DotSize3 = 10
LineWidth = 1
HitColor = (255, 100, 0)
ShootColor = (255, 200, 0)
PosColor = (0, 100, 255)
DeathColor = (255, 0, 0)

#---------------------------------------------------------
#	Methods
#---------------------------------------------------------


# Process an image file to get a map
def ProcessMap (im, logName):
	
	# Processing flow map
	print "------------------------------"
	print "Processing flow map..."
	processLog (im, logName, "HIT", 3, HitColor, "")
	processLog (im, logName, "SHOOT", 2, ShootColor, "")
	processLog (im, logName, "DIED", 1, DeathColor, "")
	
	# Processing pawn list
	print "------------------------------"
	print "Getting pawn list..."
	PawnList=GetPawnList(logName)
	
	# Processing heat map
	print "------------------------------"
	print "Processing heat map..."
	#for pawn in PawnList:
	#	processLog (im, logName, "FLOW", 0, PosColor, pawn)
	print "------------------------------"


# Process a UDK log file
def processLog(imgData, logName, type, level, color, pawn):
	
	# Init
	f = open(logName, 'r')
	i = 0
	oldPos = (0,0)
	
	# Parsing
	for line in f:
		index = string.find(line, "DVLOG")
		if index == -1:
			continue
		
		data = line[index:]
		oldPos = processLogEntry(imgData, string.split(data, "/"), type, level, color, oldPos, pawn)
		i += 1
	print "Processed " + str(i) + " positions"
	return


# Process a valid log line
# DVLOG/SHOOT/ID/X/-305.2567/Y/-1557.8965/ENDLOG
# 0     1     2  3    4      5     6       7   
def processLogEntry(im, data, type, level, color, oldPos, pawn):
	
	# First check
	if len(data) < 5:
		return (0, 0)
	
	# Heatmap
	if data[1] == type:
		position = GetPxFromUnreal(im, data[4], data[6])
		DrawArea(im, position, level, color)
		return (0, 0)
	
	# Flowmap
	if type == "FLOW" and data[2] == pawn:
		if data[1] == "IPOS" or (data[1] == "POS" and oldPos == (0,0)):
			return GetPxFromUnreal(im, data[4], data[6])
		
		if data[1] == "POS":
			draw = ImageDraw.Draw(im)
			
			position = GetPxFromUnreal(im, data[4], data[6])
			
			draw.line((position, oldPos), fill=color, width=LineWidth)
			return position
		else:
			return oldPos
	else:
		return oldPos


# Draw an area
def DrawArea(im, position, level, color):
	draw = ImageDraw.Draw(im)
	
	if level == 1:
		draw.ellipse((position[0] - DotSize1 , position[1] - DotSize1, position[0] + DotSize1, position[1] + DotSize1), fill=color)
	elif level == 2:
		draw.ellipse((position[0] - DotSize2 , position[1] - DotSize2, position[0] + DotSize2, position[1] + DotSize2), fill=color)
	else:
		draw.ellipse((position[0] - DotSize3 , position[1] - DotSize3, position[0] + DotSize3, position[1] + DotSize3), fill=color)
	
	del draw
	return


# What is the pixel size of this unreal info
def GetPxFromUnreal (img, X, Y):
	ims = img.size
	newX = GetScale(float(X), xmin, xmax, ims[0]) - 1
	newY = ims[1] - GetScale(float(Y), ymin, ymax, ims[1]) - 1
	
	if newX >= ims[0]:
		newX = ims[0] - 1
	if newY >= ims[1]:
		newY = ims[1] - 1
	if newX < 0:
		newX = 0
	if newY < 0:
		newY = 0
	return (int(newX), int(newY))


# Pawn list
def GetPawnList(logName):
	
	# Init
	f = open(logName, 'r')
	pawns = []
	
	# Parsing
	for line in f:
		index = string.find(line, "DVLOG/IPOS/")
		if index == -1:
			continue
		
		data = string.split(line[index:], "/")
		if pawns.count(data[2]) == 0:
			pawns.append(data[2])
	
	# End
	f.close()
	print pawns
	return pawns


# Scale modifier
def GetScale(x, min, max, scale):
	return (scale / (max - min) * (x - min))


#---------------------------------------------------------
#	Code
#---------------------------------------------------------

# Init
print "------------------------------"
im = Image.open(SourceImage)
size = ((xmax - xmin) / unrealToPixelRatio), ((ymax - ymin) / unrealToPixelRatio)
print "Calculated image size is :"
print size
print "Real image size is :"
print im.size

# Processing
ProcessMap (im, "Launch.log")
im.save("flowmap.png", "png")
print "Saving..."

