#**
#*  This work is distributed under the Lesser General Public License,
#*	see LICENSE for details
#*
#*	gridmap tool for DEEPVOID - Heatmap generation from event file (Launch.log with DV logging)
#*
#*	Execution : "gridmap.py <event> <resolution> " will map the specifiec event (SHOOT, JUMP, LAND, KILL, HIT...)
#*
#*  @author Gwennael ARBONA <gwennael.arbona@gmail.com>
#**

# Imports
from PIL import Image, ImageDraw, ImageFont
import os, string, sys, datetime, math

#---------------------------------------------------------
#	Map settings
#---------------------------------------------------------

# LEVEL_01
xmin = -2752.0
xmax = 7824.0
ymin = -1424.0
ymax = 6896.0
logBase = 1.4
bendAmount = 0.3
unrealToPixelRatio = 4.0
sourceImage = "LEVEL_01.png"


#---------------------------------------------------------
#	Global level
#---------------------------------------------------------

# Settings
eventType = sys.argv[1]
res = float(sys.argv[2])
map = [[0] * int((xmax - xmin) / (res/2)) for n in xrange(int((ymax - ymin) / (res/2)))]
size = ((xmax - xmin) / unrealToPixelRatio), ((ymax - ymin) / unrealToPixelRatio)

# Process
def Process():	
	maxPixel=0
	bg = Image.open(sourceImage)
	bg = bg.convert("RGBA")
	print "Required image size is " + str(size) + ", found " + str(bg.size)
	print "Map grid is " +  str(len(map))+ " by " + str(len(map[0]))
	count = processLog ("Launch.log", eventType)
	
	# Local maximum
	for x in range(int(xmin), int(xmax), int(res)):
		for y in range(int(ymin), int(ymax), int(res)):
			value = map[int(x/res)][int(y/res)]
			maxPixel = max(maxPixel, value)
	print "Maximum pixel found is " + str(maxPixel)
	
	# Map drawing
	im = Image.new('RGBA', bg.size, (0, 0, 0, 255))
	for x in range(int(xmin), int(xmax), int(res)):
		for y in range(int(ymin), int(ymax), int(res)):
			position = GetPxFromUnreal(im, x, y)
			DrawArea(im, position, GetColorFromLevel(map[int(x/res)][int(y/res)], maxPixel))
	
	# Map additionnal data
	bg = Image.blend(bg, im, bendAmount)
	d_usr = ImageDraw.Draw(bg)
	usr_font = ImageFont.truetype("Arial.ttf", 48)
	d_usr = d_usr.text((100, bg.size[1] - 80), GetInformation(count),(255,255,255), font=usr_font)
	bg.save(eventType + "_heatmap.png", "png")


#---------------------------------------------------------
#	Methods
#---------------------------------------------------------

# Process a UDK log file
def processLog(logName, type):
	
	# Init
	f = open(logName, 'r')
	i = 0
	
	# Parsing
	for line in f:
		index = string.find(line, "DVL")
		if index == -1:
			continue
		
		data = line[index:]
		i += processLogEntry(string.split(data, "/"), type)
	print "Processed " + str(i) + " positions for " + type
	return i

# Process a valid log line
#   DVL/SHOOT/ID/X/-305.2567/Y/-1557.8965/Z/46.5563/EDL
#    0    1   2  3    4      5     6      7    8     9   
def processLogEntry(data, type):
	
	# First check
	if len(data) < 5:
		return 0
	
	# Heatmap		
	elif data[1] == type:
		if type == "POS" or type == "IPOS":
			lX = int(float(data[5]) / res)
			lY = int(float(data[7]) / res)
		else:
			lX = int(float(data[4]) / res)
			lY = int(float(data[6]) / res)
		map[lX][lY] += 1
		return 1
	
	# Default
	else:
		return 0

#---------------------------------------------------------
#	Color methods
#---------------------------------------------------------

# Draw an area
def DrawArea(im, position, color):
	if (color != (0, 0, 0,)):
		draw = ImageDraw.Draw(im)
		offset = ((res /2) / unrealToPixelRatio)
		draw.rectangle([(position[0] - offset, position[1] - offset), (position[0] + offset, position[1] + offset)], fill=color)
		del draw
	return

# Get a color vector from a specific level
def GetColorFromLevel(level, mx):
	lightingFactor = float(255.0 / float(math.log(mx, logBase)))
	lv = float(lightingFactor * float(level))
	if level <= 0:
		return (0, 0, 0)
	if level > 255:
		return (255, 0, 0)
	elif lv < 64:
		return (0, GetColorCompUp(lv, 0.0), 255)
	elif lv < 128:
		return (0, 255, GetColorCompDown(lv, 64.0))
	elif lv < 192:
		return (GetColorCompUp(lv, 128.0), 255, 0)
	else:
		return (255, GetColorCompDown(lv, 192.0), 0)

# Get a color component from min (up verson)
def GetColorCompUp(value, mn):
	return int(((value - mn) / 64.0) * 255.0)

# Get a color component from min (down version)
def GetColorCompDown(value, mn):
	return 255 - int(((value - mn) / 64.0) * 255.0)


#---------------------------------------------------------
#	Utility methods
#---------------------------------------------------------

# Map additionnal data
def GetInformation(count):
	now = datetime.datetime.now()
	information = "DEEPVOID"
	information += "  |  %d/%d/%d - %d:%d:%d" %  (now.month, now.day,  now.year,  now.hour,  now.minute,  now.second)
	information += "  |  Level is `" + sourceImage.replace(".png", "") + "`"
	information += "  |  Resolution is " + str(int(res)) + "cm"
	information += "  |  " + str(count) + " matching events (`" + eventType + "`)"
	return information

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
