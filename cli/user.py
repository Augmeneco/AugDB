import socket

sock = socket.socket()
sock.connect(('localhost',6089))
#sock.send(input('$ ').encode())

out = ''

while 'return' not in out:
    out += input()+'\n\t'

sock.send(out.encode())

print('Answ:',sock.recv(1024).decode()) 

sock.send('exit'.encode())