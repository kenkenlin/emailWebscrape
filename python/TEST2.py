from selenium import webdriver
import time

driver = webdriver.Chrome()
driver.get("https://www.gmail.com")
#找到輸入框
element = driver.find_element_by_name("identifier");
#輸入內容
element.send_keys("kenlinlin@gmail.com");
#Next
email_next_button = driver.find_element_by_id("identifierNext");
email_next_button.click();
time.sleep(1);

element2 = driver.find_element_by_name("password");

element2.send_keys("yourpassword");

password_next_button = driver.find_element_by_id("passwordNext");
password_next_button.click();
