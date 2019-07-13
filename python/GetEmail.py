import datetime
import email
import imaplib
import mailbox
import pandas as pd
import os

os.getcwd()

EMAIL_ACCOUNT = "x91003502@gmail.com"
PASSWORD = "xxx"

mail = imaplib.IMAP4_SSL('imap.gmail.com')
mail.login(EMAIL_ACCOUNT, PASSWORD)
mail.list()
mail.select('inbox')
result, data = mail.uid('search', None, "ALL") # (ALL/UNSEEN)
i = len(data[0].split())

Name = []
Email = []
Content = []
Dict = {}

for x in range(i-1, 8857, -1):
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
        Name.append(email_from.split('<')[0])  
        Email.append(email_from.split('<')[1].strip()[:-1])
        Content.append(subject)
    except:
        Name.append('N/A')
        Email.append('N/A')
        Content.append('N/A')

Dict = {"Name":Name,
        "Email":Email,
        "Content":Content}
    
df = pd.DataFrame(Dict)
df.index +=1
df.to_csv('Result.csv', encoding = 'utf_8_sig')