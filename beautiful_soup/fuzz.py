##########################################################
# Author: Alexander Kellermann Nieves                    #
# Date: March 4th, 2019                                  #
##########################################################

import sys
import argparse
import getopt
import requests
from bs4 import BeautifulSoup, SoupStrainer
from urllib.parse import urlparse


def main():
    try:
        s = '-o output --ofile=output -l a1 --limit=a1 -m --url=url -u url'
        args = s.split()
        optlist, args = getopt.getopt(
            sys.argv[1:], 'u:o:l:m', ['ofile=', 'limit=', 'url='])
    except getopt.GetoptError as err:
        print(err)
        usage()
        exit(2)

    output = None  # If output remains as None, print to stdout
    limit = None
    broken = True
    url = None

    for o, a in optlist:
        if o == "-m":
            broken = False
        if o in ("-u", "--url"):
            url = a
        if o in ("-o", "--ofile"):
            output = a
        if o in ("-l", "--limit"):
            limit = a

    g = requests.get(url)

    links = find_links(g.content)

    # Links now contains the links found on the initial domain
    local_found = []
    extern_found = []

    local, extern = parse_links(links)
    local_found.append(local)
    extern_found.append(extern)

    dead, alive = recursively_parse(extern)

    if output is None:
        output = sys.stdout
    else:
        temp_file = open(output, mode='w')
        output = temp_file

    for item in dead:
        print("dead\t\t{}".format(item), file=output)
    for item in alive:
        print("alive\t\t{}".format(item), file=output)
    for item in extern:
        print("external\t{}".format(item), file=output)

    exit()


def recursively_parse(links):
    dead = []
    alive = []
    for item in links:
        rq = requests.get(item)
        if rq.status_code != 200:
            #print("{} DEAD".format(item))
            dead.append(item)
        else:
            #print("{} ALIVE".format(item))
            alive.append(item)

    return dead, alive


def parse_links(links):
    local = []
    external = []
    for item in links:
        if item.startswith("/"):
            local.append(item)
        elif item.startswith("http://"):
            external.append(item)
        # Otherwise we just trash em, we have no need for on-page tags

    return(local, external)


def find_links(request) -> list:
    links = []
    for link in BeautifulSoup(request, parse_only=SoupStrainer('a'), features="html.parser"):
        if link.has_attr('href'):
            links.append(link['href'])
    return links


def usage():
    usage = """
    -u (--url=)   --- url to search through
    -o (--ofile=) --- output file to save results instead of stdout
    -l (--limit=) --- limit search to the given domain instead of the domain derived from the URL
    -m            --- output only the URLs of pages within the domain and not broken
    """
    print(usage)


if __name__ == "__main__":
    main()
