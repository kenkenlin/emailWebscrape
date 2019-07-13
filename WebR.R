library(gmailr)
library(tmcn)
gmail_auth(scope = "full",secret_file = "client_secret.json") 
# 進行認證，secret_file 就是剛才下載的 .json檔
search_content <- 'from:(service@pxbillrc01.cathaybk.com.tw) subject:(國泰世華銀行消費彙整通知（請勿直接回覆）)'
searched_emails <- messages(search = search_content, num_results = 8, label_ids = NULL, include_spam_trash = FALSE)
# 應該會有 8 封，所以 num_results 給 8；另外不想把垃圾桶裡的跟著載入，include_spam_trash 給 FALSE
str(searched_emails[[1]])

# 把各組 id 抓出來
email_ids <- id(searched_emails)
length(email_ids)

# 根據 message id 取得每封 mail
get_emails <- function(message_ids) {
  results <- list()
  for (message_id in message_ids) {
    print(sprintf('getting message id %s', message_id))
    results[[message_id]] <- message(message_id)
  }
  return(results)
}
searched_emails <- get_emails(email_ids) 
# 取代原本的 searched_emails

searched_emails[[1]]

emails_body <- list() # 把各封的主體先拉出來
for(i in 1:8){
  emails_body[i] <- body(searched_emails[[i]])[[1]]
}
emails_body <- lapply(emails_body,toUTF8) # 用 tmcn 套件的 toUTF8 轉
emails_body[[1]]
