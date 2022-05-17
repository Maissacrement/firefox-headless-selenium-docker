#! python3
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.common.by import By

#--| Setup
options = Options()
options.add_argument("--headless")
service = Service('/usr/bin/geckodriver')
browser = webdriver.Firefox(options=options, service=service)
#--| Parse
browser.get('https://duckduckgo.com')
logo = browser.find_elements(by=By.CSS_SELECTOR, value='#logo_homepage_link')
print(logo[0].text)
#driver.get(url if "http" in url else "https://" + url)