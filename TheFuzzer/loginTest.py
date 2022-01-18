import requests
from bs4 import BeautifulSoup

# We want to keep the same cookie. Maybe
url = "http://localhost/login.php"
#s = requests.Session()
try:
    g = requests.get(url)
except:
    print("Connection cannot be made. Check your url and try again")
    exit(1)

soup = BeautifulSoup(g.text, 'html.parser')


user_token = ""
for tag in soup.find_all('input'):
    if 'name' in tag.attrs:
        # print(tag.attrs['name'])
        if tag.attrs['name'] == 'user_token':
            user_token = tag.attrs['value']

data = {'username': 'admin', 'password': 'password',
        'Login': 'Login', 'user_token': user_token}


cookie = {
    "PHPSESSID": g.cookies['PHPSESSID'],
    "security": g.cookies['security']}
print(data)

nani = requests.post(url=url, data=data, cookies=cookie)
print(nani.text)
print(nani.headers)
#
# data = {'username': 'admin', 'password': 'password',
# 'Login': 'Login', 'user_token': forms['user_token']}
# p = requests.post('http://localhost', )
