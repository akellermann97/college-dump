# Author: Alexander Kellermann Nieves
# Date: September 18th, 2018
# This is a placeholder file.
# In theory everything that has to do with beautifulsoup should find its way
# here in this file. This is where the parsing of the individual webpage should happen.

from bs4 import BeautifulSoup
import sys
import requests
import typing


def get_page(link: str):
    """
    Given a http url, attempt to grab a page using GET.
    Returns None is there is an error

    link: a string containing the URL
    """
    try:
        return requests.get(link)
    except requests.exceptions.MissingSchema:
        return None
    except:
        print("Unhandled exception", file=sys.stderr)
        return None


def turn_request_into_soup(page: requests.models.Response):
    """
    Takes a request from Python Requests, and turns it into a bs4
    document. Returns None is there is an error

    page: Python Request Object

    returns:
    bs4.BeautifulSoup object
    """
    try:
        return BeautifulSoup(page.text, 'html.parser')
    except:
        return None


def find_forms(soup: BeautifulSoup):
    """
    Returns a list of forms found on a particular webpage
    """
    return soup.findAll('form')


def find_links(soup: BeautifulSoup):
    return soup.findAll('a')
