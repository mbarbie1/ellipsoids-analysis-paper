clear;

coordsX = [13, 26, 44, 67, 78]
coordsY = [43, 56, 10, 80, 40]

coords = [ coordsX; coordsY]
start = [20,1]
stop = [50,100]

coordsNew = removeCoordinatesOutOfBounds( coords, start, stop )
