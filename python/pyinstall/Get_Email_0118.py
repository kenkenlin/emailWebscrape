import email
import imaplib
import pandas as pd
import os
import getpass
import sys
import datetime
import re
os.getcwd()

EMAIL_ACCOUNT = input("輸入帳號包含@example.com：\n")
PASSWORD = getpass.getpass("輸入密碼：\n")

rule = re.compile(r"[^\u4e00-\u9fa5]")
mail = []
try:
    imaploc = 'imap.'+EMAIL_ACCOUNT.split("@")[1]
    mail = imaplib.IMAP4_SSL(imaploc)
    try:
        mail.login(EMAIL_ACCOUNT, PASSWORD)
        print("登入成功！")
        os.system("pause")
    except:
        print("帳號密碼錯誤\n或在此解除GMAIL低風險應用程式封鎖選項"
                  +"https://myaccount.google.com/lesssecureapps")
        os.system("pause")
        exit
except:
    print("該網域已不支援此API")
    os.system("pause")
    exit

mail.list()
mail.select('inbox')
result, data = mail.uid('search', None, "ALL") # (ALL/UNSEEN)
i = len(data[0].split())

NameEmail = []
Date = []
Subject = []
Body = []

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
        Subject.append(subject)
    except:
        NameEmail.append('N/A')
        Subject.append('N/A')

    try:
        date_tuple = email.utils.parsedate_tz(email_message['Date'])
        local_date = datetime.datetime.fromtimestamp(email.utils.mktime_tz(date_tuple))
        local_message_date = "%s" %(str(local_date.strftime("%a, %d %b %Y %H:%M:%S")))
        Date.append(local_message_date)
    except:
        Date.append("N/A")

    try:
        for part in email_message.walk():
            part.get_content_type() == "text/plain"
            body = part.get_payload(decode=True)
        try:
            dirty_body = body.decode('utf-8')
            clean_body = rule.sub('', dirty_body).strip()
            Body.append(clean_body)
        except:
            try:
                dirty_body = body.decode('big5')
                clean_body = rule.sub('', dirty_body).strip()
                Body.append(clean_body)
            except:
                Body.append("N/A")

    except:
        Body.append("N/A")

Dict = {"Name&Email":NameEmail,
        "Date":Date,
        "Subject":Subject,
        "Body":Body}

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
df_2.loc[:,'Name'] = pd.Series(df_split[0].str.rstrip(' "'), index=df_2.index)
df_2.loc[:,'Email'] = pd.Series(df_split[1].str.rstrip('>'), index=df_2.index)
df_2 = df_2.drop(columns =["Name&Email"])
subject_col = df_2.pop(df_2.columns[1])
df_2.insert(4, subject_col.name, subject_col)
body_col = df_2.pop(df_2.columns[1])
df_2.insert(4, body_col.name, body_col)
try:
    df_2.to_csv(os.getcwd()+'\\Target.csv', encoding = 'utf_8_sig')
    print("輸出的資料儲存於目前工作路徑")
    os.system("pause")
except PermissionError:
    print("資料匯出失敗，請以系統管理員的身分執行")
    os.system("pause")
