local h = require('quiz.helpers')
local rr = h.rr
local _ = h._

local func = {}

function func.func_summ(req)
    local a = rr(1, 5)
    local b = rr(10, 20)
    local task = [[
def myf(a):
    return a + %i
print(myf(%i))]]
    return
    h.f(task, a, b),
    h.f("%i", a + b),
    h.f("%i", a),
    h.f("%i", b),
    'Error',
    h.task(req)
end

function func.func_arg_name(req)
    local a = rr(1, 5)
    local b = rr(10, 20)
    local task = [[
def myf(b):
    print(b)
a = %i
b = %i
myf(a)]]
    return
    h.f(task, a, b),
    h.f("%i", a),
    h.f("%i", b),
    h.f("%i", a + b),
    'Error',
    h.task(req)
end

function func.var_undefined(req)
    local a = rr(1, 5)
    local task = [[
def myf(x):
    return 2 * x
a = %i
b = myf(b)
print(b)]]
    return
    h.f(task, a),
    'Error',
    h.f("%i", a),
    h.f("%i", 2 * a),
    h.f("%i", 0),
    h.task(req)
end

function func.sin(req)
    return
    h.f([[>>> import math
          >>> math.sin(90)]]),
    '0.8939966636005579',
    '1',
    '0',
    '-1',
    h.task(req)
end

function func.cos(req)
    return
    h.f([[>>> import math
          >>> math.cos(90)]]),
    '-0.4480736161291701',
    '1',
    '0',
    '-1',
    h.task(req)
end

function func.sin_rev(req)
    return
    '1.0',
    h.f([[>>> import math
          >>> math.sin(math.radians(90))]]),
    h.f([[>>> import math
          >>> math.cos(math.radians(90))]]),
    h.f([[>>> import math
          >>> math.sin(90)]]),
    h.f([[>>> import math
          >>> math.cos(90)]]),
    h.task2(req)
end

function func.argv(req)
    return
    '',
    'sys.argv',
    'os.argv',
    'sys.argv()',
    'os.argv()',
    _("How to get command line arguments?", req)
end

function func.system(req)
    return
    '',
    'os.system("dir")',
    'sys.system("dir")',
    'os.ostem("dir")',
    'sys.ostem("dir")',
    _("How to run external command ('dir')?", req)
end

function func.argv1(req)
    return
    'python prog.py 19 input.fasta 6',
    'sys.argv[2]',
    'sys.argv(2)',
    'sys.argv(1)',
    'sys.argv[1]',
    _("How to get argument 'input.fasta'?", req)
end

function func.argv2(req)
    return
    'python prog.py 19 input.fasta 6',
    'sys.argv[0]',
    'sys.argv(0)',
    'sys.argv(1)',
    'sys.argv[1]',
    _("How to get script name ('prog.py')?", req)
end

function func.urllib2(req)
    return
    'import urllib2',
    'list(urllib2.urlopen("http://ya.ru"))',
    'urllib2.urlopen("http://ya.ru").read()',
    'str(urllib2.urlopen("http://ya.ru"))',
    'wget http://ya.ru :3',
    _("How to get list of lines of web page http://ya.ru?",
    req)
end

function func.randint(req)
    return
    'import random',
    'random.randint(1, 10)',
    'random.randint(1, 11)',
    'random.randint(range(1, 11))',
    'random.randint(range(1, 10))',
    _("How to get random number in range [1; 10]?", req)
end

function func.complement(req)
    return
    'seq = "ATTGC"',
[[seq_compl = ""
compl_dict = {"A": "T", "T": "A",
    "C": "G", "G": "C"}
for i in range(len(seq)):
    nucl = seq[-1 - i]
    nucl_compl = compl_dict[nucl]
    seq_compl += nucl_compl
print(seq_compl)]],
[[seq_compl = ""
compl_dict = {"A": "T", "T": "A",
    "C": "G", "G": "C"}
for i in range(len(seq)):
    nucl = seq[i]
    nucl_compl = compl_dict[nucl]
    seq_compl += nucl_compl
print(seq_compl)]],
[[seq_compl = ""
compl_dict = {"A": "T", "T": "A",
    "C": "G", "G": "C"}
for i in range(len(seq)):
    nucl = seq[-i]
    nucl_compl = compl_dict[nucl]
    seq_compl.append(nucl_compl)
print(seq_compl)]],
[[seq_compl = ""
compl_dict = {"A": "A", "T": "T",
    "C": "C", "G": "G"}
for i in range(len(seq)):
    nucl = seq[-i]
    nucl_compl = compl_dict[nucl]
    seq_compl.append(nucl_compl)
print(seq_compl)]],
    _("How to calculate complement DNA sequence?", req)
end

return func

