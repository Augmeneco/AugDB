#!/usr/bin/python3
import socket, os, sys, pickle, json, re, traceback, time, base64, sqlite3, xmltodict

basedata = pickle.load(open('basedata.augdb','rb'))

def chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]

class convert:
    def sqlite(db,table):
        out = {}
        db = sqlite3.connect(db).cursor().execute('SELECT * FROM '+table)
        columns = [columns[0] for columns in db.description]
        rows = db.fetchall()
        for row in rows:
            for k in range(len(columns)):
                if columns[k] not in out:
                    out[columns[k]] = []
                out[columns[k]].append(row[k])
        return out


def toxml(db):
    out = '<?xml version="1.0" encoding="UTF-8"?><CONFIG><grid version="3"><saveoptions create="False" position="False" content="True"/><content>'
    out += '<cells cellcount="CELLCOUNT">'

    cellcount = 0
    columncount = 1
    rowcount = 0
    for cell in db:
        rowcount = 0
        out += '<cell'+str(cellcount+1)+' column="'+str(columncount)+'" row="'+str(rowcount)+'" text="'+cell+'"/>'
        cellcount += 1
        rowcount += 1
        for row in db[cell]:            
            out += '<cell'+str(cellcount+1)+' column="'+str(columncount)+'" row="'+str(rowcount)+'" text="'+str(row)+'"/>'
            cellcount += 1
            rowcount += 1
            
        columncount += 1
    out += '</cells></content></grid></CONFIG>'
    out = out.replace('CELLCOUNT',str(cellcount))
    return out

def send(text,conn):
    text = text.replace('&','')
    text = base64.b64encode(text.encode())
    for chunk in list(chunks(text,1024)):
        conn.send(chunk)
        conn.send('\r\n'.encode())
    conn.send('end'.encode())
    conn.send('\r\n'.encode()) 

sock = socket.socket()
sock.bind(('',6089))
sock.listen()
while True:
    try:
        conn, addr = sock.accept()
        print('Connected',addr)
        while True:
            out = ''
            data = ''.encode()
            while True:
                data_chunk = conn.recv(1024)                
                if data_chunk == ''.encode(): break
                data += data_chunk
                if '//end'.encode() in data_chunk: break

            data = data.replace(b'//end',b'')
            data = base64.b64decode(data).decode()
            data = data.replace('\n\r\n','').replace('    ','\t\t').replace('\n','\n\t')
            if data == '':
                conn.close()
                break

            if '<?xml version="1.0" encoding="UTF-8"?>' in data:
                data = data.replace('<?xml version="1.0" encoding="UTF-8"?>','')
                data = json.loads(json.dumps(xmltodict.parse(data)))['CONFIG']['grid']['content']['cells']

                bd = {}
                for cell in data:
                    if cell == '@cellcount': continue
                    if data[cell]['@row'] == '0':
                        bd[data[cell]['@text']] = []
                        continue
                    
                    bd[ list(bd.keys())[int(data[cell]['@column'])-1] ].append(data[cell]['@text'])

                basedata = bd
                pickle.dump(basedata,open('basedata.augdb','wb'))
                continue

            try:
                data = 'def func():\n\t'+data 
                exec(data)
                out = str(func())
                open('log.log','w').write(out)
                send(out,conn)
                print('отправленно')
                    
            except Exception as error:
                print('Произошла ошибка:',traceback.format_exc())
                send(traceback.format_exc(),conn)   

    except Exception as error:
        E = traceback.format_exc()
        print(E)
        if error == KeyboardInterrupt:
            conn.close()
            sock.close()
            os._exit(0)
