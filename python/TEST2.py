from selenium import webdriver
import time

driver = webdriver.Chrome()
driver.get("https://mail.google.com/mail/u/0/h/1pq68r75kzvdr/?v%3Dlui")
#找到輸入框
element = driver.find_element_by_name("identifier");
#輸入內容
element.send_keys("@gmail.com");
#Next
email_next_button = driver.find_element_by_id("identifierNext");
email_next_button.click();
time.sleep(1);

element2 = driver.find_element_by_name("password");

element2.send_keys("");

password_next_button = driver.find_element_by_id("passwordNext");
password_next_button.click();
time.sleep(10);
element3 = driver.find_element_by_id("sbq");
element3.click();
#關鍵字有以下三個
#Berlin Station hostel、Munich Station hostel、Frankfurt Station hostel
element3.send_keys("aa225456");
contain_next_button = driver.find_element_by_name("nvp_site_mail");
contain_next_button.click();
print("你Hello, World!")
