import sys
import os.path
import json


asm_file = open(sys.argv[1], 'r')

branch_lookup = {}
branch_idx = 0

if (os.path.isfile('./branch_lookup.txt')):
    with open("./branch_lookup.txt", "r") as fp:
        saved_lookup = json.load(fp)
        # clean up branch lookup
        for branch in saved_lookup:
            branch_lookup[int(branch)] = int(saved_lookup[branch])

keys_list = list(branch_lookup.keys())
if (len(keys_list) > 0):
    keys_list.sort()
    branch_idx = keys_list[-1] + 1

# immediate to binary
def decimalToBinary(n):
    return format(n, '06b')

def targetToBinary(n):
    return format(n, '04b')

def removeComments(tokens):
    if '//' in tokens:
        return tokens[:tokens.index('//')]
    else:
        return tokens

def convertReg(reg):
    if (int(reg[1:]) < 16 and int(reg[1:]) >= 0):
        return format(int(reg[1:]), '04b')
    else:
        raise Exception("Invalid Register")
    
def compile(tokens, line):
    match tokens[0]:
        case 'add':
            return '00000' + convertReg(tokens[1])
        case 'sub':
            return '00001' + convertReg(tokens[1])
        case 'and':
            return '00010' + convertReg(tokens[1])
        case 'xor':
            return '00011' + convertReg(tokens[1])
        case 'or':
            return '00100' + convertReg(tokens[1])
        case 'not':
            return '00101' + convertReg(tokens[1])
        case 'rxor':
            return '00110' + convertReg(tokens[1])
        case 'lsl':
            return '00111' + convertReg(tokens[1])
        case 'lsr':
            return '01000' + convertReg(tokens[1])
        case 'inc':
            return '01001' + convertReg(tokens[1])
        case 'lwr':
            return '01010' + convertReg(tokens[1])
        case 'swr':
            return '01011' + convertReg(tokens[1])
        case 'set':
            return '011' + decimalToBinary(int(tokens[1]))
        case 'movi':
            return '100' + convertReg(tokens[1]) + convertReg(tokens[2])[-1] + '0'
        case 'movo':
            return '101' + convertReg(tokens[1])[-1] + '0' + convertReg(tokens[2])
        case 'halt':
            return '111111111'
        case _:
            raise Exception("Invalid Instruction on line " + str(line))

def handleBranch(tokens, target):
    match tokens[0]:
        case 'bneq':
            return '11000' + targetToBinary(target)
        case 'beq':
            return '11001' + targetToBinary(target)
        case 'bgt':
            return '11010' + targetToBinary(target)
        case 'blt':
            return '11011' + targetToBinary(target)

code = []
bin = []
branch_targets = {}
inst = ['add', 'sub', 'and', 'xor', 'or', 'not', 'rxor', 'lsl', 'lsr', 'inc', 'lwr', 'swr', 'set', 'movi', 'movo', 'bneq', 'beq', 'bgt', 'blt', 'halt']
b_inst = ['bneq', 'beq', 'bgt', 'blt']

# clean assembly
for line in asm_file:
    tokens = line.split()
    tokens = removeComments(tokens)
    if len(tokens) == 0:
        continue
    code.append(tokens)
    
# sweep branch targests
for i, tokens in enumerate(code):
    if (tokens[0] not in inst):
        branch_targets[tokens[0]] = (i, branch_idx)
        branch_lookup[branch_idx] = i
        branch_idx += 1
        code.pop(i)

for i, line in enumerate(code):
    if (line[0] in b_inst):
        bin.append(handleBranch(line, branch_targets[line[1]][1]))
    else:
        bin.append(compile(line, i))

bin_name = './bin/' + sys.argv[1].split('\\')[-1].split('.')[0] + '.txt'
bin_file = open(bin_name, 'w')

print('Writing to ' + bin_name + '...')

for i, line in enumerate(bin):
    if (i != len(bin) - 1):
        bin_file.write(line + '\n')
    else:
        bin_file.write(line)

# write branch lookup to file
with open("./branch_lookup.txt", "w") as fp:
    json.dump(branch_lookup, fp)