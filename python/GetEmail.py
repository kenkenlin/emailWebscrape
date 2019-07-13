import datetime
import email
import imaplib
import mailbox
import pandas as pd
import os
import getpass

os.getcwd()

EMAIL_ACCOUNT = "aa225456@gmail.com"
PASSWORD = input("輸入密碼：")

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

for x in range(i-1, 0, -1):
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
        print(x)
        
    email_message = email.message_from_string(raw_email_string)
    
    try:
        email_from = str(email.header.make_header(email.header.decode_header(email_message['From'])))
        subject = str(email.header.make_header(email.header.decode_header(email_message['Subject'])))
        NameEmail.append(email_from)  
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
df_2.to_csv('Target.csv', encoding = 'utf_8_sig')


