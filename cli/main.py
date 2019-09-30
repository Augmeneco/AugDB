#!/usr/bin/python3
import socket, os, sys, pickle, json, re, traceback

basedata = pickle.load(open('basedata.augdb','rb'))

def xml(db):
    out = '<?xml version="1.0" encoding="UTF-8"?><CONFIG><grid version="3"><saveoptions create="False" position="False" content="True"/><content>'
    out += '<cells cellcount="CELLCOUNT">'

    cellcount = 0
    columncount = 0
    rowcount = 0
    for cell in db:
        rowcount = 0
        out += '<cell'+str(cellcount+1)+' column="'+str(columncount)+'" row="'+str(rowcount)+'" text="'+cell+'"/>'
        cellcount += 1
        rowcount += 1
        for row in db[cell]:            
            out += '<cell'+str(cellcount+1)+' column="'+str(columncount)+'" row="'+str(rowcount)+'" text="'+row+'"/>'
            cellcount += 1
            rowcount += 1
            
        columncount += 1
    out += '</cells></content></grid></CONFIG>'
    out = out.replace('CELLCOUNT',str(cellcount))
    return out

sock = socket.socket()
sock.bind(('',6089))
sock.listen()
while True:
    try:
        conn, addr = sock.accept()
        print('Connected',addr)
        while True:
            out = ''
            data = conn.recv(1024).decode()
            if data != '': 

                if data == 'exit':
                    conn.close()
                    print(addr,'отключился')
                
                

                try:
                    data = 'def func():\n\t'+data 
                    exec(data)
                    out = str(func())
                    conn.send(out.encode())
                except Exception as error:
                    if 'Bad' in traceback.format_exc():
                        continue
                    print('Произошла ошибка:',traceback.format_exc())
                    conn.send(traceback.format_exc().encode())


            
            

    except Exception as error:
        E = traceback.format_exc()
        if 'Bad' in E: continue
        if error == KeyboardInterrupt:
            conn.close()
            os._exit(0)
        if error == BrokenPipeError:
            conn.close()
            print(addr,'отключился')
