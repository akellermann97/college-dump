##########################################################
# Author: Alexander Kellermann Nieves                    #
# Date September 17th, 2018                              #
##########################################################

import sys
import argparse
import requests
from bs4 import BeautifulSoup
from urllib.parse import urlparse

import dvwa

rtime = 500


def main():

    ########################################################
    #     These are command line related entries           #
    ########################################################
    mode = None       # either discover or test
    url = None        # the url to be scanned
    options = []      # Options. A list because it can be more than one.

    if len(sys.argv) < 3:  # We know for sure this is incorrect
        help_and_exit()

    mode = get_mode()
    url = get_url()
    options = get_options()

    if mode == "test":
        test(url, options)
    else:
        discover(url, options)


def test(url, options):
    """ This is the official fuzzer test mode
    """
    master_list = baseline_stuff(url, options)

    # Grab the vector file and generate the appropriate lists.
    vector_list = [x for x in options if x.startswith('--vectors=')]
    vector_file_name = vector_list[0][10:]

    # We grab all the vectors we need and put them into appropriate arrays for use
    # later in the program
    my_sensitive_array = get_vectors(vector_file_name, 'SENS')
    my_sanitation_array = get_vectors(vector_file_name, 'SAN')
    my_sql_file = get_vectors(vector_file_name, 'SQL')
    my_xss_file = get_vectors(vector_file_name, 'XSS')

    print()
    print("################################")
    print("Vulnerabilities Tested and Found")
    print("################################")
    print()

    for line in my_xss_file:
        data = {'name': line, 'Submit': 'Submit'}

        for site in master_list:
            r = dvwa.post_page(site, data)
            dvwa.check_for_sensitive_leaks(r, my_sensitive_array)
            if not meets_time_requirement(r.elapsed.microseconds / 100):
                print("Page failed to respond in time : {}".format(site))
            if r.status_code != 200:
                print("Status Code Problem on: {}".format(site))
            if dvwa.find_alert(r) == True:
                print("XSS found on : {}".format(site))
                break

    for line in my_sql_file:
        for site in master_list:
            data = {'id': line.rstrip(), 'Submit': 'Submit'}
            r = dvwa.post_page(site, data)
            if r.status_code != 200:
                print("Status Code Problem on: {} {}".format(site, r.status_code))
            if dvwa.find_SQL_inject(r):
                print("SQL Injection found on: {}".format(site))

    num_of_san_problems = 0
    for site in master_list:
        for line in my_sanitation_array:
            data = {line: line}
            r = dvwa.post_page(site, data)
            if dvwa.check_for_sanitation_problems(r, line):
                num_of_san_problems += 1

    print("Number of Sanitation problems found: {}".format(num_of_san_problems))


def meets_time_requirement(time):
    """ Simple function to test if the time that the response took was
    less than the response time specified by the user
    """
    if time < rtime:
        return True
    return False


def remove_dupes(my_list):
    """ Function to remove duplicates from a list
    """
    temp_list = []
    for x in my_list:
        if 'logout' in x:
            break
        if x not in temp_list:
            temp_list.append(x)
    return temp_list


def discover(url, options):
    """ All the things in discover are also performed in Test.
    Therefore, the discover module just has the usual baseline stuff
    contained in it, and nothing more.
    """
    baseline_stuff(url, options)


def baseline_stuff(url, options) -> list:
    list_of_valid_site = []
    custom_auths = [x for x in options if x.startswith('--custom-auth=')]
    word_list = [x for x in options if x.startswith('--common-words=')]
    response_time = [x for x in options if x.startswith('--slow=')]
    if not word_list:
        print("--common-words= required. Please add a word list and run again")
        exit()
    else:
        guess_list = (word_list[0][15:].rstrip())

    if not response_time:
        pass  # Use the default of 500ms. Defined as global already
    else:
        # The user has supplied an argument to --slow=
        global rtime
        try:
            rtime = int(response_time[0][7:])
        except ValueError:
            print("value of --slow= must be a base 10 integer")
            exit()

    if len(custom_auths) == 1:
        if custom_auths[0] == '--custom-auth=dvwa':
            # Here we can run the dvwa specific functions.
            # This code can only be reached if the user specifically wants
            # to test dvwa
            try:
                new_url = craft_url(url)
                response = dvwa.dvwa_login(new_url, 'admin', 'password')
            except requests.exceptions.ConnectionError:
                print(
                    "Unable to establish with the url supplied. Check your url and try again.")
                exit(1)
        else:
            print("Error: {} not implemented".format(custom_auths[0]))
    else:
        print("Error: Incorrect number of --custom-auth supplied")

    print("LINKS SUCCESSFULLY DISCOVERED:")
    print("##############################")
    link_list = dvwa.find_links(response)
    for link in link_list:
        response = dvwa.load_page('{}/{}'.format(url, link))
        if response.status_code == 404:
            pass
        elif response.status_code == 200:
            print("{}/{}".format(url, link))
            list_of_valid_site.append("{}/{}".format(url, link))

    dvwa.dvwa_login(new_url, 'admin', 'password')

    print("")
    # This is code that guesses links based on a guessList.txt file
    # We can move this to the data section of the program, but I'm not sure it would be
    # worth the hassle
    try:
        with open(guess_list) as my_guess_list:
            print("LINKS SUCCESSFULLY GUESSED:")
            print("###########################")
            for word in my_guess_list:
                rword = word.rstrip()  # sword is the word but newline character removed
                response = dvwa.load_page('{}/{}'.format(url, rword))
                if response.status_code == 404:
                    pass  # Page doesn't exist
                elif response.status_code == 200:
                    print("{}/{}".format(url, rword))
                    list_of_valid_site.append("{}/{}".format(url, rword))

                response = dvwa.load_page('{}/{}.php'.format(url, rword))
                if response.status_code == 404:
                    pass  # Page doesn't exist
                elif response.status_code == 200:
                    print("{}/{}.php".format(url, rword))
                    list_of_valid_site.append("{}/{}.php".format(url, rword))
    except FileNotFoundError:
        print("File not found. Check your Filename and try again")
        exit()

    print()
    print("COOKIES")
    print("###########################")
    for x in dvwa.list_of_cookies:
        print(x)

    print()
    print("FORMS DISCOVERED ON WEBPAGES")
    print("############################")
    uniq_list = remove_dupes(list_of_valid_site)
    for site in uniq_list:
        if 'logout' in site:
            pass
        else:
            dvwa.get_forms(site)

    return uniq_list


def craft_url(url):
    """ If a URL doesn't already have a path on it, we might want to specially
    treat it by putting it into this function and making sure we get to the
    login page. This is because we don't automatically follow redirects
    """
    u = urlparse(url)
    if u.path == '/login.php':
        return url
    return "{}".format(u.scheme + "://" + u.netloc + "/" + 'login.php')


def get_mode():
    """ Checks to see if the input to the mode variable is either 'test' or 'discover', if neither
    Then it exits the program because the program.
    """
    if sys.argv[1].lower() == "test":
        return "test"
    elif sys.argv[1].lower() == "discover":
        return "discover"
    else:
        help_and_exit()
        return None


def get_url():
    """The url is the second element of the array, always. No error checking is done here.
    """
    return sys.argv[2]


def get_options():
    """This function returns every argument passed to the command line program after the
    4rd element because the rest of those arguments should be command line options
    """
    return sys.argv[3:]


def help_and_exit(exit_code=0):
    """When called, this function will display the help message, and then exit.
    exit_code: Value of the exit code, default 0 for successes
    """
    print(INTRO_MESSAGE)
    exit(exit_code)


def get_vectors(file, vtype: str) -> list:
    """
    Pass in a filename and extract the vectors of type str
    """
    opened_file = open(file)
    vectors = []
    critical_region = False
    for line in opened_file:
        # Going through each line
        if "#{}".format(vtype) not in line:
            # This isn't the heading.
            pass
        else:
            # We've reached the heading before the part of the file
            # That contains the actual vectors
            critical_region = True
        if critical_region == True:
            if line.rstrip() == "":
                critical_region = False
            else:
                vectors.append(line.rstrip())

    return vectors[1:]


INTRO_MESSAGE = """
fuzz [discover | test] url OPTIONS

COMMANDS:
  discover  Output a comprehensive, human-readable list of all discovered inputs to the system. Techniques include both crawling and guessing.
  test      Discover all inputs, then attempt a list of exploit vectors on those inputs. Report potential vulnerabilities.

OPTIONS:
  --custom-auth=string     Signal that the fuzzer should use hard-coded authentication for a specific application (e.g. dvwa). Optional.

  Discover options:
    --common-words=file    Newline-delimited file of common words to be used in page guessing. Required.

  Test options:
    --vectors=file         Newline-delimited file of common exploits to vulnerabilities. Required.
    --sensitive=file       Newline-delimited file data that should never be leaked. It's assumed that this data is in the application's database (e.g. test data), but is not reported in any response. Required.
    --random=[true|false]  When off, try each input to each page systematically.  When on, choose a random page, then a random input field and test all vectors. Default: false.
    --slow=500             Number of milliseconds considered when a response is considered \"slow\". Default is 500 milliseconds
"""

if __name__ == "__main__":
    main()
