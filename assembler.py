import sys
import os.path
import json


asm_file = open(sys.argv[1], 'r')

branch_lookup = {}
branch_idx = 1

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


bin = []
pc = -1
idx = 0
branch_target = -1

for line in asm_file:
    idx += 1
    tokens = line.split()
    tokens = removeComments(tokens)
    if len(tokens) == 0:
        continue
    
    if (tokens[0] == 'LOOP_BEGIN'):
        branch_target = pc + 1
        continue
    
    pc += 1
    if (tokens[0] == 'bneq' and branch_target != -1):
        branch_lookup[branch_idx] = branch_target
        bin.append('110' + decimalToBinary(branch_idx))
        branch_idx += 1
        branch_target = -1
        continue
    else:
        bin.append(compile(tokens, idx))

bin_file = open('./bin/a.txt', 'w')

for i in range(len(bin)):
    if (i != len(bin) - 1):
        bin_file.write(bin[i] + '\n')
    else:
        bin_file.write(bin[i])

# write branch lookup to file
with open("./branch_lookup.txt", "w") as fp:
    json.dump(branch_lookup, fp)