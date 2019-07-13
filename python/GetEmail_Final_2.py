import datetime
import email
import imaplib
import mailbox
import pandas as pd
import os
import getpass
import tqdm
import time
import sys

os.getcwd()

EMAIL_ACCOUNT = input("輸入帳號包含@example.com：\n")
PASSWORD = getpass.getpass("輸入密碼：\n")

os.system("pause")


mail = imaplib.IMAP4_SSL('imap.gmail.com')
mail.login(EMAIL_ACCOUNT, PASSWORD)
mail.list()
mail.select('inbox')
result, data = mail.uid('search', None, "ALL") # (ALL/UNSEEN)
i = len(data[0].split())

NameEmail = []
Content = []
Dict = {}

ttrange = 0

for x in range(i-1, i-200, -1):
    latest_email_uid = data[0].split()[x]
    result, email_data = mail.uid('fetch', latest_email_uid, '(RFC822)')
    raw_email = email_data[0][1]
    try:
        raw_email_string = raw_email.decode('utf-8')
    except:
        try:
            raw_email_string = raw_email.decode('big5')
        except:
            raw_email_string = " "
    finally:
        ttrange=ttrange+1
        sys.stdout.write("\r%d/200" % ttrange)
        sys.stdout.flush()
        
    email_message = email.message_from_string(raw_email_string)
    
    try:
        email_from = str(email.header.make_header(email.header.decode_header(email_message['From'])))
        subject = str(email.header.make_header(email.header.decode_header(email_message['Subject'])))
        NameEmail.append(email_from.strip('"').lstrip().rstrip())  
        Content.append(subject)
    except:
        NameEmail.append('N/A')
        Content.append('N/A')

Dict = {"Name&Email":NameEmail,
        "Content":Content}
    
df = pd.DataFrame(Dict, index=None)
df.index +=1

#篩選字串並製作新的DF
tar = input("輸入要搜索的關鍵字\n(若為負數請以："" , "" 逗號 )作為分隔：\n")
tar = tar.split(',')
targets = tar
print(targets)
df_2 = df[df['Name&Email'].apply(lambda sentence: any(word in sentence for word in targets))]
print("正在搜尋關鍵字為",
          targets,
      "的郵件")
os.system("pause")
#輸出CSV
df_split = df_2["Name&Email"].str.split("<", n = 1, expand = True) 
df_2['Name'] = df_split[0].str.rstrip(' "')
df_2['Email'] = df_split[1].str.rstrip('>')
df_2.drop(columns =["Name&Email"], inplace = True) 
last_col = df_2.pop(df_2.columns[0])
df_2.insert(2, last_col.name, last_col)
df_2.to_csv('Target.csv', encoding = 'utf_8_sig')
os.system("pause")
