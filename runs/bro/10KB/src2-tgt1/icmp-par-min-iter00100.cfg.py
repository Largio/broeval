
# Write results to this file
OUTFILE = 'runs/bro/10KB/src2-tgt1/icmp-par-min-iter00100.result.csv'

# Source computers for the request
SOURCE = ['10.0.0.1', '10.0.0.3']

# Target machines for the requests (aka server)
TARGET = ['10.0.0.2']

# IDS Mode. (ATM: noids, min, max, http, ssl, ftp, icmp, mysql)
IDSMODE = 'min'

# Connection mode (par = parallel, seq = sequential)
MODE = 'par'

# Number of evaluation repititions to run
EPOCHS = 100

# Number of iterations to be run in each evaluation repitition
ITER = 100

# Size of the file to be downloaded from target (in Bytes * 10^SIZE)
SIZE = 4

# Protocol to be used e.g. HTTP, SSL, FTP, MYSQL
PROTOCOL = 'icmp'