#**
#*  This work is distributed under the Lesser General Public License,
#*	see LICENSE for details
#*	
#*	Execution : "gridmap.py <log file> <event>" will map the specifiec event (SHOOT, JUMP, LAND, KILL, HIT...)
#*
#*  @author Gwennael ARBONA
#**

# Imports
from PIL import Image, ImageDraw, ImageFont
import os, string, sys, datetime

#---------------------------------------------------------
#	Map settings
#---------------------------------------------------------

# LEVEL_01
res = 200.0
xmin = -2480.0
xmax = 6224.0
ymin = -1488.0
ymax = 7231.0
unrealToPixelRatio = 2.0
sourceImage = "LEVEL_01.png"


#---------------------------------------------------------
#	Global level
#---------------------------------------------------------

# Settings
logName = sys.argv[1]
eventType = sys.argv[2]
im = Image.open(sourceImage)
map = [[0] * int((xmax - xmin) / res) for n in xrange(int((ymax - ymin) / res))]
size = ((xmax - xmin) / unrealToPixelRatio), ((ymax - ymin) / unrealToPixelRatio)

# Process
def Process():	
	maxPixel=0
	print "Required image size is " + str(size) + ", found " + str(im.size)
	print "Map grid is " +  str(len(map))+ " by " + str(len(map[0]))
	count = processLog (im, logName, eventType)
	
	# Local maximum
	for x in range(int(xmin), int(xmax), int(res)):
		for y in range(int(ymin), int(ymax), int(res)):
			maxPixel = max(maxPixel, map[int(x/res)][int(y/res) ])
	print "Maximum pixel found is " + str(maxPixel)
	
	# Map drawing
	for x in range(int(xmin), int(xmax), int(res)):
		for y in range(int(ymin), int(ymax), int(res)):
			position = GetPxFromUnreal(im, x, y)
			DrawArea(im, position, GetColorFromLevel(map[int(x/res)][int(y/res)], maxPixel))
	
	# Map additionnal data
	usr_font = ImageFont.truetype("Arial.ttf", 64)
	d_usr = ImageDraw.Draw(im)
	d_usr = d_usr.text((400 ,im.size[1] - 150), GetInformation(count),(255,255,255), font=usr_font)
	im.save(eventType + "_heatmap.png", "png")


#---------------------------------------------------------
#	Methods
#---------------------------------------------------------

# Process a UDK log file
def processLog(imgData, logName, type):
	
	# Init
	f = open(logName, 'r')
	i = 0
	oldPos = (0,0)
	
	# Parsing
	for line in f:
		index = string.find(line, "DVL")
		if index == -1:
			continue
		
		data = line[index:]
		oldPos = processLogEntry(imgData, string.split(data, "/"), type, oldPos)
		i += 1
	print "Processed " + str(i) + " positions for " + type
	return i

# Process a valid log line
#   DVL/SHOOT/ID/X/-305.2567/Y/-1557.8965/Z/46.5563/EDL
#    0    1   2  3    4      5     6      7    8     9   
def processLogEntry(im, data, type, oldPos):
	
	# First check
	if len(data) < 5:
		return (0, 0)
	
	# Heatmap
	if data[1] == type:
		lX = int(float(data[4]) / res)
		lY = int(float(data[6]) / res)
		map[lX][lY] += 1
		return (0, 0)
	
	# Default
	else:
		return oldPos

#---------------------------------------------------------
#	Utility methods
#---------------------------------------------------------

# Draw an area
def DrawArea(im, position, color):
	if (color != (0,0,0)):
		draw = ImageDraw.Draw(im)
		offset = ((res /2) / unrealToPixelRatio)
		draw.rectangle([(position[0] - offset, position[1] - offset), (position[0] + offset, position[1] + offset)], fill=color)
		del draw
	return

	
# Map additionnal data
def GetInformation(count):
	now = datetime.datetime.now()
	information = "DEEPVOID"
	information += "  |  Generated on %d/%d/%d - %d:%d:%d" %  (now.month, now.day,  now.year,  now.hour,  now.minute,  now.second)
	information += "  |  Level is `" + sourceImage.replace(".png", "") + "`"
	information += "  |  Resolution is " + str(int(res)) + "cm"
	information += "  |  " + str(count) + " events in file"
	return information
	
# Get a color vector from a specific level
def GetColorFromLevel(level, max):
	lightingFactor = 255.0 / max
	lv = lightingFactor * level
	#return (GetValueInRange(lv, 100, 255), GetValueInRange(lv, 50, 200), GetValueInRange(lv, 0, 100))
	return (int(lv), 0, 0)

# Scale a color part
def GetValueInRange(value, min, max):
	if value <= min:
		return 0
	elif value > max:
		return 0
	else:
		return int(value)

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

# Scale modifier
def GetScale(x, min, max, scale):
	return (scale / (max - min) * (x - min))


#---------------------------------------------------------
#	Launch code
#---------------------------------------------------------

Process()
