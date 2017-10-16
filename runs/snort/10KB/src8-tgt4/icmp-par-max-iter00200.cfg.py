
# Write results to this file
OUTFILE = 'runs/snort/10KB/src8-tgt4/icmp-par-max-iter00200.result.csv'

# Source computers for the request
SOURCE = ['10.0.0.11', '10.0.0.12', '10.0.0.13', '10.0.0.14', '10.0.0.31', '10.0.0.32', '10.0.0.33', '10.0.0.34']

# Target machines for the requests (aka server)
TARGET = ['10.0.0.21', '10.0.0.22', '10.0.0.23', '10.0.0.24']

# IDS Mode. (ATM: noids, min, max, http, ssl, ftp, icmp, mysql)
IDSMODE = 'max'

# Connection mode (par = parallel, seq = sequential)
MODE = 'par'

# Number of evaluation repititions to run
EPOCHS = 100

# Number of iterations to be run in each evaluation repitition
ITER = 200

# Size of the file to be downloaded from target (in Bytes * 10^SIZE)
SIZE = 4

# Protocol to be used e.g. HTTP, SSL, FTP, MYSQL
PROTOCOL = 'icmp'