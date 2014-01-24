import os
import subprocess
import sys

BUILD_PATH = 'C:/Windows/Microsoft.NET/Framework/v4.0.30319/MSBuild.exe'
SLN_PATH = 'Code/Solutions/CryEngine_LEGACY.sln'
RESULT_PATH = 'result.txt'

def GetChanged(touchFile, slnFile):
    if not os.path.exists(touchFile):
        return 0

    print 'Compiling for ', touchFile
        
    os.utime(touchFile, None)
    buildpipe = subprocess.Popen([BUILD_PATH, slnFile, '/v:m', '/m:4', '/nologo', '/p:Platform=x64', 
                                  '/p:Configuration=debug', '/t:Build', '/clp:NoSummary'],\
                                 stdout=subprocess.PIPE)
    count = 0
    while True:
        line = buildpipe.stdout.readline()
        if (len(line) == 0):
            break
        if not ".cpp" in line:
            continue
        sys.stdout.write('.')
        count = count + 1
    sys.stdout.write('\n')
    return count

def GetMostFreqChangedFiles():
    pipe = subprocess.Popen(['git', 'log', '--pretty=format:', '--name-only'], stdout=subprocess.PIPE)
    lines = {}
    while True:
        line = pipe.stdout.readline()
        if (len(line)==0):
            break
        if not ".h" in line and not ".hpp" in line:
            continue
        line = line.strip()
        if line in lines:
            lines[line] = lines[line] + 1
        else:
            lines[line] = 1
    
    files = []
    count = 0
    for line in sorted(lines, key=lines.get, reverse=True):
        files.append((line, lines[line]))
        count = count + 1
        if count > 40:
            break
    return files
    
def main(slnFile, resultFile):
    files = GetMostFreqChangedFiles()
    files = [('Code/x3/x3common/x3_static.h', 1)]
    for file in files:
        changedFile, changeFreq = file
        compiledNum = GetChanged(changedFile, slnFile)
        
        with open(resultFile, 'a') as myfile:
            resultLine = "{0}\t{1}\t{2}\n".format(changedFile, changeFreq, compiledNum)
            myfile.write(resultLine)
            myfile.close()
            print resultLine

if __name__ == '__main__':    
    main(SLN_PATH, RESULT_PATH)
