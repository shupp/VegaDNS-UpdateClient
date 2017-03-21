#!/usr/bin/env python

import threading
import time
import subprocess
import argparse
import os

import redis


# environment defaults
host=os.getenv("REDIS_HOST", default='127.0.0.1')
port=os.getenv("REDIS_PORT", default='6379')
channel=os.getenv("REDIS_CHANNEL", default='VEGADNS-CHANGES')
script=os.getenv("UPDATE_SCRIPT", default='/etc/update-data.sh')

parser = argparse.ArgumentParser(
    description='Listen for VegaDNS update notifications from Redis Pub/Sub'
)
parser.add_argument('--host', dest='host', action='store',
                    default=host, help='Redis host')
parser.add_argument('--port', dest='port', action='store',
                    default=port, help='Redis port')
parser.add_argument('--channel', dest='channel', action='store',
                    default=channel, help='Redis channel')
parser.add_argument('--script', dest='script', action='store',
                    default=script,
                    help='Location of update-data.sh script')

args = parser.parse_args()


class Listener(threading.Thread):
    def __init__(self, r, args):
        threading.Thread.__init__(self)
        self.redis = r
        self.pubsub = self.redis.pubsub()
        self.pubsub.subscribe(args.channel)

    def work(self, item):
        try:
            print subprocess.check_output(
                [args.script],
                stderr=subprocess.STDOUT
            )
        except Exception, e:
            print e

    def run(self):
        for item in self.pubsub.listen():
                self.work(item)


if __name__ == "__main__":
    r = redis.Redis(host=args.host, port=args.port)
    client = Listener(r, args)
    client.daemon = True
    print "starting redis listener"
    client.start()

    # Run in foreground and wait for signals
    while True:
        time.sleep(1)
