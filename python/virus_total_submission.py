#Company: OpenPath LLC
#Owner: Sahr Lebbie

PURPOSE="Grabs Multiple IPs from Splunk using the OpenPath TA and Submits to Virus Total."
import time
import os
import re
import ipaddress
import requests

os.system('clear')
print("   XX XX     XXXXXXX  XXXXXXX   XXXX      XX")
print(" XX     XX   XX   XX  XX        XX  XX    XX")
print("XX       XX  XX   XX  XX        XX   XX   XX")
print("XX       XX  XXXXXXX  XXXXXXX   XX    XX  XX")
print("XX       XX  XX       XX        XX     XX XX")
print(" XX     XX   XX       XX        XX      XXXX")
print("   XX XX     XX       XXXXXXX   XX      XXXX")

print('\n')
time.sleep(2)
print('\n')

print("XXXXXXX        XXX       XXXXXXXXXXX  XX    XX")
print("XX   XX       XX  XX         XX       XX    XX")
print("XX   XX      XX    XX        XX       XX    XX")
print("XXXXXXX     XX XXXX XX       XX       XXXXXXXX")
print("XX         XX        XX      XX       XX    XX")
print("XX        XX          XX     XX       XX    XX")
print("XX       XX            XX    XX       XX    XX")
time.sleep(2)
os.system('clear')
print('\n')

print("Welcome to Openpath LLC Script to: " + PURPOSE)
print("Let's Get Started")

apikey = '<API_KEY>'
filename = "<what_file_you_want_to_SAVE_and_ingest>"
splunk_ioc_file = "<where_splunk_saves_your_IOC>"

with open(splunk_ioc_file, 'r') as ioc_file:
    ip = re.compile('^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
    for ioc in ioc_file:
        if ip.match(ioc):
            print(ioc + " is an ip-address. We will run this IOC as an ip on the API endpoint")
            ip_url = 'https://www.virustotal.com/vtapi/v2/ip-address/report'
            params = {'apikey': apikey, 'ip': ioc}
            chunk_size = 100
            response = requests.get(ip_url, params=params)
            print(response.json())
        else:
            print(ioc + " is a domain. We will run this IOC as a domain on the API endpoint")
            domain_url = 'https://www.virustotal.com/vtapi/v2/domain/report'
            params = {'apikey': apikey, 'domain': ioc}
            chunk_size = 100
            response = requests.get(domain_url, params=params)
            print(response.json())

#with open(filename, 'wb') as splunk_file:
#    for chunk in response.iter_content(chunk_size):
#        splunk_file.write(chunk)

''' 
If you wanted to use an authorization code, you can do so after provisioning your token from splunk.
'''
