import requests
import bs4
from bs4 import BeautifulSoup

global_cookie = ""
global_data = ""
list_of_cookies = []


def dvwa_login(url, username='admin', password='password'):
    """Attempts a login to dvwa. Returns output of the page.

    url: url of the dvwa page
    username: The username to log in
    password: password associated with the user
    """

    g = requests.get(url)
    soup = BeautifulSoup(g.text, 'html.parser')

    # In DVWA, they use a usertoken associated with a cookie in order to combat
    # CSRF Vulnerabilities. We get around this by grabbing the cookie and the
    # Associated user_token.
    user_token = ""
    for tag in soup.find_all('input'):
        if 'name' in tag.attrs:

            if tag.attrs['name'] == 'user_token':
                user_token = tag.attrs['value']

    # This is the POST data we're going to send in the request
    data = {'username': username, 'password': password,
            'Login': 'Login', 'user_token': user_token}

    # In order to pass the CSRF protection we need to use the
    # cookies that match up with the user_token
    cookie = {
        "PHPSESSID": g.cookies['PHPSESSID'],
        "security": 'low'}  # g.cookies['security']}

    global global_cookie
    global_cookie = cookie

    global global_data
    global_data = data

    global list_of_cookies
    list_of_cookies.append(global_cookie)

    return requests.post(url=url, data=data, cookies=cookie)


def load_page(url):
    """ Send a GET request to get a page."""
    global list_of_cookies
    r = requests.get(url=url, cookies=global_cookie)
    if len(r.cookies.items()) > 0:
        list_of_cookies.append(r.cookies.items())
    return r


def post_page(url, data):
    """ Sends GET request with parameters in the URL """
    return requests.get(url=url, params=data, cookies=global_cookie)


def get_dvwa_login_cookie():
    """ Returns the cookie with the login information"""
    return global_cookie


def check_for_sensitive_leaks(page, sens_array):
    for line in sens_array:
        if line.upper() in page.text.upper():
            print("sensitive leakage found: {}".format(line))


def check_for_sanitation_problems(page, line):
    if line in page.url:
        return True
    return False


def get_forms(url):
    """ For a given url, grab the page, and look for any inputs.
    print them to stdout 
    """
    list_of_inputs = []
    g = load_page(url)
    soup = BeautifulSoup(g.text, 'html.parser')
    for tag in soup.find_all('input'):
        if 'name' in tag.attrs:
            list_of_inputs.append("\t{}".format(tag['name']))

    if len(list_of_inputs) == 0:
        return

    print(soup.title.contents[0])
    for x in list_of_inputs:
        print(x)


def find_links(page):
    """ Given a plaintext html webpage, parse through the contents with
    bs4, then return a list of hyperlinks found on the page
    """
    rlist = []
    soup = BeautifulSoup(page.text, 'html.parser')
    for tag in soup.find_all('a'):
        rlist.append(tag['href'])

    return rlist


def find_alert(page):
    alert_found = False
    soup = BeautifulSoup(page.text, 'html.parser')
    for tag in soup.find_all('script'):
        if len(tag.contents) > 0:
            for x in tag.contents:
                if 'alert' in x:
                    alert_found = True

    return alert_found


def find_SQL_inject(page):
    alert_found = False
    soup = BeautifulSoup(page.text, 'html.parser')
    if len(soup.find_all('pre')) > 1:
        alert_found = True

    return alert_found
